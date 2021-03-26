//
//  AddressModel.swift
//  inmac
//
//  Created by Ria Song on 2021/03/23.
//

import Foundation

// Java의 Bean -> Address
class AddressModel: NSObject{
    // Properties (Java의 field)
    var addressNo: Int?
    var addressName: String?
    var addressPhone: String?
    var addressEmail: String?
    var addressMemo: String?
    var addressBirth: String?
    var addressMvp: String?
    var addressImage: String?
    
    // Empty constructor
    override init() {
        
    }
    
    // constructor
    init(addressNo: Int, addressName: String, addressPhone: String, addressEmail: String, addressMemo: String, addressBirth:String, addressMvp:String, addressImage:String) {
        self.addressNo = addressNo
        self.addressName = addressName
        self.addressPhone = addressPhone
        self.addressEmail = addressEmail
        self.addressMemo = addressMemo
        self.addressBirth = addressBirth
        self.addressMvp = addressMvp
        self.addressImage = addressImage
    }
    
    // constructor
    init(addressNo: Int, addressName: String, addressPhone: String, addressEmail: String, addressMemo: String, addressBirth:String, addressImage:String) {
        self.addressNo = addressNo
        self.addressName = addressName
        self.addressPhone = addressPhone
        self.addressEmail = addressEmail
        self.addressMemo = addressMemo
        self.addressBirth = addressBirth
        self.addressImage = addressImage
    }
}
