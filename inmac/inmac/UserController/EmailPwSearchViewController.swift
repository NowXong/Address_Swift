//
//  EmailPwSearchViewController.swift
//  INMAC
//
//  Created by Ria Song on 2021/03/23.
//

import UIKit

class EmailPwSearchViewController: UIViewController, SearchEmailPwProtocol {
  

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    
    var segmentCheck = 0
    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.isHidden = true
        emailTextField.isHidden = true
    }
    
    @IBAction func idPwSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentCheck = 0
            emailLabel.isHidden = true
            emailTextField.isHidden = true
            emailTextField.text = ""
            nameTextField.text = ""
            phoneTextField.text = ""
            searchButton.setTitle("아이디 찾기", for: .normal)
        case 1:
            segmentCheck = 1
            emailLabel.isHidden = false
            emailTextField.isHidden = false
            emailTextField.text = ""
            nameTextField.text = ""
            phoneTextField.text = ""
            searchButton.setTitle("비밀번호 찾기", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func actionSearchButton(_ sender: UIButton) {
        var nameNilCheck = checkNil(str: nameTextField.text!)
        var phoneNilCheck = checkNil(str: phoneTextField.text!)
        var emailNilCheck = checkNil(str: emailTextField.text!)
        
        let searchIdPwModel = SearchEmailPwModel()
        searchIdPwModel.delegate = self
        
        switch segmentCheck {
        case 0:
            if nameNilCheck != 0 && phoneNilCheck != 0 {
                searchIdPwModel.searchEmailItems(userName: nameTextField.text!, userPhone: phoneTextField.text!)
            } else {
                let resultAlert = UIAlertController(title: "실패", message: "모든 항목을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
            }
        case 1:
            if nameNilCheck != 0 && phoneNilCheck != 0 && emailNilCheck != 0{
                searchIdPwModel.searchPasswordItems(userEmail: emailTextField.text!, userName: nameTextField.text!, userPhone: phoneTextField.text!)
            } else {
                let resultAlert = UIAlertController(title: "실패", message: "모든 항목을 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                    self.navigationController?.popViewController(animated: true)
                })
                resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func itemDownloaded(items: String) {
        var segmentName = ""
        switch segmentCheck {
        case 0:
            segmentName = "아이디"
        case 1:
            segmentName = "비밀번호"
        default:
            break
        }
        if items == ""{
            let resultAlert = UIAlertController(title: "\(segmentName) 찾기 실패", message: "일치하는 정보가 없습니다.\n입력하신 정보를 다시 한 번 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil)
        } else {
            let resultAlert = UIAlertController(title: "\(segmentName) 찾기 성공", message: "\(nameTextField.text!) 님의 \(segmentName)는 \(items) 입니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "로그인 화면으로 이동하기", style: UIAlertAction.Style.default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil)
        }
    }
    
    func checkNil(str: String) -> Int {
        let check = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if check.isEmpty{
            return 0
        } else {
            return 1
        }
    }

}
