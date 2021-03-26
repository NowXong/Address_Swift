////
////  RegisterViewController.swift
////  Moca
////
////  Created by 김대환 on 2021/03/04.
////
//
//import UIKit
//
//class RegisterViewController: UIViewController, RegisterModelProtocol, EmailCheckModelProtocol {
//
//    
//    @IBOutlet var idTextField: BindingTextField!
//    @IBOutlet var passwordTextField: BindingTextField!
//    @IBOutlet var passwordCheckTextField: BindingTextField!
//    @IBOutlet var nameTextField: UITextField!
//    @IBOutlet var phoneTextField: UITextField!
//    
//    @IBOutlet var idLabel: UILabel!
//    @IBOutlet var passwordLabel: UILabel!
//    @IBOutlet var passwordCheckLabel: UILabel!
//    
//    
//    var emailCheck = 0
//    var overlapCheck = 0
//    var isEmailValid = false
//    var isPasswordValid  = false
//    var isPasswordCheckValid = false
//    
//    // 아무곳이나 눌러 softkeyboard 지우기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupTextField()
//    }
//    
//    @IBAction func emailCheckButton(_ sender: UIButton) {
//        switch checkNil(str: idTextField.text!) {
//            case 0 :
//                let resultAlert = UIAlertController(title: "이메일 중복 체크 실패", message: "아이디를 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
//                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                resultAlert.addAction(onAction)
//                self.present(resultAlert, animated: true, completion: nil)
//                overlapCheck = 0
//            case 1 :
//                if isEmailValid == true{
//                    let emailCheckModel = EmailCheckModel()
//                    emailCheckModel.delegate = self
//                    emailCheckModel.downloadItems(userEmail: idTextField.text!)
//                    overlapCheck = 1
//                } else {
//                    overlapCheck = 0
//                    let resultAlert = UIAlertController(title: "이메일 중복 체크 실패", message: "이메일 형식으로 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }
//            default:
//                break
//        }
//    }
//    
//    @IBAction func registerBtn(_ sender: UIButton) {
//        var nameCheck = checkNil(str: nameTextField.text!)
//        var phoneCheck = checkNil(str: phoneTextField.text!)
//        switch overlapCheck {
//        case 1:
//            switch emailCheck {
//            case 1:
//                let resultAlert = UIAlertController(title: "회원가입 실패", message: "중복 된 아이디입니다.", preferredStyle: UIAlertController.Style.alert)
//                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                resultAlert.addAction(onAction)
//                self.present(resultAlert, animated: true, completion: nil)
//            case 0:
//                if isEmailValid == true && isPasswordValid == true && isPasswordCheckValid == true && nameCheck == 1 && phoneCheck == 1 {
//                    let id = idTextField.text
//                    let password = passwordTextField.text
//                    let name = nameTextField.text
//                    let phone = phoneTextField.text
//                    
//                    let registerModel = RegisterModel()
//                    registerModel.delegate = self
//                    registerModel.insertItems(userEmail: id!, userPw: password!, userName: name!, userPhone: phone!)
//                } else if isEmailValid == false {
//                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "아이디를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }else if isPasswordValid == false {
//                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "비밀번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }else if isPasswordCheckValid == false {
//                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "비밀번호 확인 란을 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }else if nameCheck == 0 {
//                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "이름을 입력해 주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }else if phoneCheck == 0 {
//                    let resultAlert = UIAlertController(title: "회원가입 실패", message: "전화번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                    resultAlert.addAction(onAction)
//                    self.present(resultAlert, animated: true, completion: nil)
//                }
//            default:
//                break
//            }
//        case 0:
//            let resultAlert = UIAlertController(title: "회원가입 실패", message: "아이디 중복 확인을 해주세요.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
//            resultAlert.addAction(onAction)
//            self.present(resultAlert, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//
//    func emailDownloaded(items: Int) {
//        emailCheck = items
//        switch items {
//        case 0:
//            let resultAlert = UIAlertController(title: "아이디 중복 확인", message: "사용 가능한 아이디 입니다.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//            resultAlert.addAction(onAction)
//            self.present(resultAlert, animated: true, completion: nil)
//        case 1:
//            let resultAlert = UIAlertController(title: "아이디 중복 확인", message: "중복된 아이디 입니다.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
//            resultAlert.addAction(onAction)
//            self.present(resultAlert, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//    
//    func itemDownloaded(items: Int) {
//        switch items {
//        case 1:
//            let resultAlert = UIAlertController(title: "완료", message: "가입이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
//                self.navigationController?.popViewController(animated: true)
//            })
//            resultAlert.addAction(onAction)
//            self.present(resultAlert, animated: true, completion: nil)
//        case 0:
//            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 하였습니다.\n관리자에게 문의해 주세요.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
//                self.navigationController?.popViewController(animated: true)
//            })
//            resultAlert.addAction(onAction)
//            self.present(resultAlert, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//    
//    private func setupTextField(){
//        idTextField.bind { (text) in
//            self.isEmailValid = self.isValidEmail(text)
//            if self.isEmailValid == false {
//                self.idLabel.text = "이메일 형식을 확인해주세요."
//            } else {
//                self.idLabel.text = ""
//            }
//        }
//        passwordTextField.bind{ (text) in
//            self.isPasswordValid = self.isValidPassword(text)
//            if self.isPasswordValid == false {
//                self.passwordLabel.text = "비밀번호는 대문자, 소문자, 숫자를 모두 포함한 8~12자리 입니다.(특수문자 제외)"
//            }else {
//                self.passwordLabel.text = ""
//            }
//        }
//        passwordCheckTextField.bind{ (text) in
//            if self.passwordTextField.text != text {
//                self.passwordCheckLabel.text = "비밀번호가 일치하지 않습니다."
//                self.isPasswordCheckValid = false
//            }else {
//                self.passwordCheckLabel.text = ""
//                self.isPasswordCheckValid = true
//            }
//        }
//    }
//    
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//
//    func isValidPassword(_ password: String) -> Bool {
//        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,12}$"
//
//        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//        return predicate.evaluate(with: password)
//    }
//    
//    func checkNil(str: String) -> Int {
//        let check = str.trimmingCharacters(in: .whitespacesAndNewlines)
//        if check.isEmpty{
//            return 0
//        } else {
//            return 1
//        }
//    }
//
//}
//
//class BindingTextField: UITextField {
//
//    var textEdited : ((String) -> Void)? = nil
//    func bind(completion : @escaping (String) -> Void){
//        textEdited = completion
//        addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//    }
//
//    @objc func textFieldEditingChanged(_ textField : UITextField){
//        guard let text = textField.text else {
//            return
//        }
//        textEdited?(text)
//    }
//    
//    
//}
