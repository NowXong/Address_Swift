//
//  AddViewController.swift
//  inmac
//
//  Created by Ria Song on 2021/03/23.
//

import UIKit

class AddViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, AdrMaxModelProtocol {
    
    @IBOutlet var txt_addressName: UITextField!
    @IBOutlet var txt_addressPhone: UITextField!
    @IBOutlet var txt_addressMemo: UITextField!
    @IBOutlet var txt_addressBirth: UITextField!
    @IBOutlet var iv_addressImage: UIImageView!
    @IBOutlet var txt_addressEmail: UITextField!
    
    
    // 변수
    var check = 0
    var adrMax = 0
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToImage))
        iv_addressImage.addGestureRecognizer(tapGesture)
        iv_addressImage.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            check = 1
            iv_addressImage.image = image
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
    
    // Max 값을 위한 func
    func adrMaxItemDownloaded(items: Int) {
        adrMax = 0
        adrMax = items
        print("최대값은 ? : \(adrMax)")
        
        let addressInsertModel = AddressInsertModel() // instance 선언
        addressInsertModel.adrInsert03Items(userEmail: Share.userID, addressNo: adrMax, completionHandler: {_,_ in print("Register Upload Success")
            DispatchQueue.main.async { () -> Void in
                self.navigationController?.popViewController(animated: true) // 현재화면 종료
            }
        })
    }
    
    
    @IBAction func btn_RegisterAddress(_ sender: UIButton) {
        
        let addressName = txt_addressName.text
        let addressPhone = txt_addressPhone.text
        let addressEmail = txt_addressEmail.text
        let addressMemo = txt_addressMemo.text
        let addressBirth = txt_addressBirth.text
        
        let addressInsertModel = AddressInsertModel() // instance 선언
        if check == 1 {
            addressInsertModel.addressInsertItems(addressName: addressName!, addressPhone: addressPhone!, addressEmail: addressEmail!, addressMemo: addressMemo!, addressBirth: addressBirth!, at: imageURL!, completionHandler: {_, _ in
                DispatchQueue.main.async { () -> Void in
                    addressInsertModel.delegate = self
                    addressInsertModel.adrMaxItems()
                    
                }
            })
        } else {
            addressInsertModel.addressInsertXItems(addressName: addressName!, addressPhone: addressPhone!, addressEmail: addressEmail!, addressText: addressMemo!, addressBirth: addressBirth!, completionHandler: {_, _ in
                DispatchQueue.main.async { () -> Void in
                    addressInsertModel.delegate = self
                    addressInsertModel.adrMaxItems()
                }
            })
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
