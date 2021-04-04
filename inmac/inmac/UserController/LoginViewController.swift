//
//  LoginViewController.swift
//  inmac
//
//  Created by Ria Song on 2021/03/21.
//

import UIKit
import SQLite3

class LoginViewController: UIViewController, LogInModelProtocol, UITextFieldDelegate {
    
    
    @IBOutlet var txt_userEmail: UITextField!
    @IBOutlet var txt_userPw: UITextField!
    @IBOutlet var btn_ViewPwImage: UIButton!
    @IBOutlet var switchLogin: UISwitch!
    
    
    // 변수
    var iconClick = true
    var db: OpaquePointer?
    var email = [String]()
    var cheking = [Int]()
    var result = 0
    var overlapCheck = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 패스워드 보여주는 버튼 이미지 설정
        btn_ViewPwImage.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
        // SQLite 생성
        creatSQLite()
        
        // SQLite에 있는 데이터를 모두 불러옴
        readValues()
        
        // 불러온 데이터 중 자동로그인이 되어있는지 확인
        for i in 0..<cheking.count {
            if cheking[i] == 1 {
                // 자동로그인이 되어있으면 쉐어벨류에 아이디 저장
                Share.userID = email[i]
                // 로그인 화면에서 바로 메인 화면으로 넘기기
                self.performSegue(withIdentifier: "sgMain", sender: self)
            }
        }
        
        txt_userEmail.delegate = self
        
        
    } // viewDidLoad end
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func btn_ViewPassword(_ sender: UIButton) {
        
        if(iconClick == true) {
            txt_userPw.isSecureTextEntry=false
            btn_ViewPwImage.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            btn_ViewPwImage.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            txt_userPw.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
        
    }
    
    @IBAction func btn_Login(_ sender: UIButton) {
        
        getLoginData()
        Share.userID = txt_userEmail.text!
        print("Login")
        print("Share.userEmail",Share.userID)
        
    }
    
    func creatSQLite() {
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("INMACSQLite.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS INMACSQLite (sid INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, cheking INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errmsg)")
        }
    }
    
    func readValues() {
        
        let queryString = "SELECT * FROM INMACSQLite"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errmsg)")
            return
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {        // 읽어올 데이터가 있는지
            let _ = sqlite3_column_int(stmt, 0)
            email.append(String(cString: sqlite3_column_text(stmt, 1)))
            cheking.append(Int(sqlite3_column_int(stmt, 2)))
        }
    }
    
    func getLoginData() {
        let logInModel = LogInModel()
        logInModel.delegate = self
        logInModel.downloadItems(userEmail: txt_userEmail.text!, userPw: txt_userPw.text!)
    }
    
    
    func itemDownloaded(items: Int) {
        result = items
        print("result ----> \(result)")
        LoginCheck()
    }
    
    func LoginCheck() {
        switch result {                         // MySQL에서 입력한 값의 데이터가 있는지 확인
        case 1:
            if switchLogin.isOn == true {       // 자동로그인 스위치를 켰는지 확인
                // SQLite에 입력한 값이 있는지 확인
                for i in 0..<cheking.count {
                    // 만약 있다면 SQLite에 입력한 값의 아이디의 자동로그인 상태를 바꿔줌
                    if email[i] == txt_userEmail.text! {
                        overlapCheck = 1
                        var stmt: OpaquePointer?
                        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
                        let queryString = "UPDATE INMACSQLite SET cheking = ? where email = ?"
                        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("error preparing insert : \(errmsg)")
                            return
                        }
                        if sqlite3_bind_text(stmt, 1, "1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("error binding checking : \(errmsg)")
                            return
                        }
                        if sqlite3_bind_text(stmt, 2, txt_userEmail.text, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("error binding txt_userEmail : \(errmsg)")
                            return
                        }
                        // sqlite 실행
                        if sqlite3_step(stmt) != SQLITE_DONE {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("failure inserting : \(errmsg)")
                            return
                        }
                        let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                            Share.userID = self.email[i]
                            self.performSegue(withIdentifier: "sgMain", sender: self)
                        })
                        resultAlert.addAction(okAction)
                        present(resultAlert, animated: true, completion: nil)
                    }
                }
                // SQLite에 입력한 값의 자료가 없다면 새로 입력함.
                switch overlapCheck {
                case 0:
                    var stmt: OpaquePointer?
                    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
                    
                    let queryString = "INSERT INTO INMACSQLite (email, cheking) VALUES (?,?)"
                    
                    if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error preparing insert : \(errmsg)")
                        return
                    }
                    // 자동로그인 상태를 입력해줌
                    if sqlite3_bind_text(stmt, 1, txt_userEmail.text, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error binding txt_userEmail : \(errmsg)")
                        return
                    }
                    if sqlite3_bind_text(stmt, 2, "1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error binding checking : \(errmsg)")
                        return
                    }
                    
                    // sqlite 실행
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure inserting : \(errmsg)")
                        return
                    }
                    let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                        Share.userID = self.txt_userEmail.text!
                        self.performSegue(withIdentifier: "sgMain", sender: self)
                    })
                    resultAlert.addAction(okAction)
                    present(resultAlert, animated: true, completion: nil)
                    
                default:
                    break
                }
            } else {
                // 자동로그인 스위치를 키지 않은 경우는 그냥 쉐어벨류에 입력한 값을 저장해주고 메인화면으로 넘겨줌
                let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                    Share.userID = self.txt_userEmail.text!
                    self.performSegue(withIdentifier: "sgMain", sender: self)
                })
                resultAlert.addAction(okAction)
                present(resultAlert, animated: true, completion: nil)
                print("Login successfully! Not Auto-Login")
            }
        case 0: // 메인화면 이동 막기
            let userAlert = UIAlertController(title: "경고", message: "ID나 암호가 틀렸습니다.", preferredStyle: UIAlertController.Style.actionSheet)
            let onAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            userAlert.addAction(onAction)
            present(userAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
} // END
