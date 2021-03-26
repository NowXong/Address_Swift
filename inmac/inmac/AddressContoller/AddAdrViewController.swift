//
//  AddAdrViewController.swift
//  Address_Swift
//
//  Created by JiEunPark on 2021/02/17.
//

import UIKit

class AddAdrViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, AdrMaxModelProtocol {
    

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var txtBirth: UITextField!
    
    
    var check = 0
    
    var adrMax = 0
    
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    @IBOutlet weak var ivProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToImage))
        ivProfile.addGestureRecognizer(tapGesture)
        ivProfile.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            check = 1
            ivProfile.image = image
            
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        }
        
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    @objc func touchToImage(sender: UITapGestureRecognizer) {
        
        if (sender.state == .ended) {
            // 앨범 호출
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // Max 값을 위한
    func adrMaxItemDownloaded(items: Int) {
        adrMax = items
        print("최대값은 ? : \(adrMax)")
        
        let addressInsertModel = AddressInsertModel() // instance 선언
        addressInsertModel.adrInsert03Items(user_userEmail: Share.userID, address_addressNo: adrMax)
        DispatchQueue.main.async { () -> Void in
            self.navigationController?.popViewController(animated: true) // 현재화면 종료
        }
        
    }
    
    
    @IBAction func btnNewAddress(_ sender: UIButton) {
        let addressName = txtName.text
        let addressPhone = txtPhone.text
        let addressEmail = txtEmail.text
        let addressText = txtText.text
        let addressBirth = txtBirth.text
        
        let addressInsertModel = AddressInsertModel() // instance 선언
        if check == 1 {
            addressInsertModel.addressInsertItems(addressName: addressName!, addressPhone: addressPhone!, addressEmail: addressEmail!, addressText: addressText!, addressBirth: addressBirth!, at: imageURL!, completionHandler: {_, _ in
                DispatchQueue.main.async { () -> Void in
                    addressInsertModel.delegate = self
                    addressInsertModel.adrMaxItems()
                    
                }
            })
        } else {
            addressInsertModel.addressInsertXItems(addressName: addressName!, addressPhone: addressPhone!, addressEmail: addressEmail!, addressText: addressText!, addressBirth: addressBirth!, completionHandler: {_, _ in
                DispatchQueue.main.async { () -> Void in
                    addressInsertModel.delegate = self
                    addressInsertModel.adrMaxItems()
                }
            })
        }
        
        
//        if result == true{
            // insert 잘됨
//            let resultAlert = UIAlertController(title: "완료", message: "입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
//                self.navigationController?.popViewController(animated: true) // 현재화면 종료
//            })
//            resultAlert.addAction(onAction)
//            present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
//        } else {
            // insert 실패
//            let resultAlert = UIAlertController(title: "실패", message: "문제가 발생했습니다. 같은 에러가 지속적으로 발생하면 관리자에게 문의주세요.", preferredStyle: UIAlertController.Style.alert)
//            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//            resultAlert.addAction(onAction)
//            present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
//        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
