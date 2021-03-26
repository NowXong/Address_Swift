//
//  SignUpViewController.swift
//  inmac
//
//  Created by Ria Song on 2021/03/21.
//

import UIKit

class SignUpViewController: UIViewController, RegisterModelProtocol, EmailCheckModelProtocol {
    
    @IBOutlet var txt_userEmail: BindingTextField!
    @IBOutlet var txt_userPw: BindingTextField!
    @IBOutlet var txt_userPwCheck: BindingTextField!
    @IBOutlet var txt_userName: UITextField!
    @IBOutlet var txt_userPhone: UITextField!
    
    @IBOutlet var lbl_IdCheck: UILabel!
    @IBOutlet var lbl_Pw: UILabel!
    @IBOutlet var lbl_PwCheck: UILabel!
    

    var emailCheck = 0
    var overlapCheck = 0
    var isEmailValid = false
    var isPasswordValid  = false
    var isPasswordCheckValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()

    }


    @IBAction func btn_SignUp(_ sender: UIButton) {
        
        let nameCheck = checkNil(str: txt_userName.text!)
        let phoneCheck = checkNil(str: txt_userPhone.text!)
        switch overlapCheck {
        case 1:
            switch emailCheck {
            case 1:
                let resultAlert = UIAlertController(title: "회원가입 실패", message: "중복된 아이디입니다.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
            case 0:
                if isEmailValid == true && isPasswordValid == true && isPasswordCheckValid == true && nameCheck == 1 && phoneCheck == 1 {
                    let id = txt_userEmail.text
                    let password = txt_userPw.text
                    let name = txt_userName.text
                    let phone = txt_userPhone.text
                    
                    let registerModel = RegisterModel()
                    registerModel.delegate = self
                    registerModel.insertItems(userEmail: id!, userPw: password!, userName: name!, userPhone: phone!)
                } else if isEmailValid == false {
                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "아이디를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }else if isPasswordValid == false {
                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "비밀번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }else if isPasswordCheckValid == false {
                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "비밀번호 확인 란을 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }else if nameCheck == 0 {
                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "이름을 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }else if phoneCheck == 0 {
                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "전화번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }
            default:
                break
            }
        case 0:
            let resultAlert = UIAlertController(title: "회원가입 실패", message: "아이디 중복 확인을 해주세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    
    @IBAction func btn_CheckId(_ sender: UIButton) {
        
        switch checkNil(str: txt_userEmail.text!) {
            case 0 :
                let resultAlert = UIAlertController(title: "이메일 중복 체크 실패", message: "아이디를 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
                overlapCheck = 0
            case 1 :
                if isEmailValid == true{
                    let emailCheckModel = EmailCheckModel()
                    emailCheckModel.delegate = self
                    emailCheckModel.downloadItems(userEmail: txt_userEmail.text!)
                    overlapCheck = 1
                } else {
                    overlapCheck = 0
                    let resultAlert = UIAlertController(title: "이메일 중복 체크 실패", message: "이메일 형식으로 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                }
            default:
                break
        }
        
    }
    

    
    func itemDownloaded(items: Int) {
        switch items {
        case 1:
            let resultAlert = UIAlertController(title: "완료", message: "가입이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        case 0:
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 하였습니다.\n관리자에게 문의해 주세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func emailDownloaded(items: Int) {
        emailCheck = items
        switch items {
        case 0:
            let resultAlert = UIAlertController(title: "아이디 중복 확인", message: "사용 가능한 아이디 입니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        case 1:
            let resultAlert = UIAlertController(title: "아이디 중복 확인", message: "중복된 아이디 입니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    

    
    private func setupTextField(){
        txt_userEmail.bind { (text) in
            self.isEmailValid = self.isValidEmail(text)
            if self.isEmailValid == false {
                self.lbl_IdCheck.text = "잘못된 이메일 형식입니다."
                self.lbl_IdCheck.textColor = UIColor.red
            } else {
                self.lbl_IdCheck.text = ""
            }
        }
        txt_userPw.bind{ (text) in
            self.isPasswordValid = self.isValidPassword(text)
            if self.isPasswordValid == false {
                self.lbl_Pw.text = "대문자, 소문자, 숫자를 모두 포함하여 8자 이상 입력하세요."
                self.lbl_Pw.textColor = UIColor.blue
            }else {
                self.lbl_Pw.text = ""
            }
        }
        txt_userPwCheck.bind{ (text) in
            if self.txt_userPwCheck.text != self.txt_userPw.text {
                self.lbl_PwCheck.text = "비밀번호가 일치하지 않습니다."
                self.lbl_PwCheck.textColor = UIColor.red
                self.isPasswordCheckValid = false
            } else if self.txt_userPwCheck.text == self.txt_userPw.text {
                self.lbl_PwCheck.text = "비밀번호가 일치합니다."
                self.lbl_PwCheck.textColor = UIColor.blue
                self.isPasswordCheckValid = true
            } else {
                self.lbl_PwCheck.text = ""
                self.isPasswordCheckValid = true
            }
        }
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,12}$"

        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    
    func checkNil(str: String) -> Int {
        let check = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if check.isEmpty{
            return 0
        } else {
            return 1
        }
    }
    
    
    
    
    
    
} // END

class BindingTextField: UITextField {
    var textEdited : ((String) -> Void)? = nil
    func bind(completion : @escaping (String) -> Void){
        textEdited = completion
        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField){
        guard let text = textField.text else {
            return
        }
        textEdited?(text)
    }
}

