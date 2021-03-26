//
//  AddressJsonModel.swift
//  Address_Swift
//
//  Created by JiEunPark on 2021/02/17.
//

import Foundation

// protocol은 DB의 table과 연결되어있기 때문에 필요한 것.
// insertModel에선 필요없다 (?)
protocol AddressJsonModelProtocol: class{
    func addressItemDownloaded(items: NSArray) // <- 여기에 담은 아이템을 아래 delegate에서 사용하고, tableView에서 궁극적으로 사용.
}

class AddressJsonModel: NSObject{
    var delegate: AddressJsonModelProtocol!
    var urlPath = "http://" + Share.macIP + "/inmac/select_addressList.jsp"
    
    func downloadItems(){
        let urlAdd = "?userEmail=\(Share.userID)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            } else {
                print("Data is downloading")
                // URLSession에 들어있는 data를 parsing
                self.parseJSON(data!)
            }
        }
        task.resume() // 위의 task를 실행해주는 함수.
    }
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            // JSON 모델 탈피(?)
            // JSON 파일 불러오는 함수 → JSONSerialization
            // options ???
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        }catch let error as NSError{
            print(error)
        }
        
        // json은 key와 value값이 필요하므로 Dictionary 타입 사용
        var jsonElement = NSDictionary()
        
        let locations = NSMutableArray()
        
        print("for전")
        
        for i in 0..<jsonResult.count{
            // jsonResult[i]번째를 NSDictionary 타입으로 변환
            jsonElement = jsonResult[i] as! NSDictionary
            print("for후 \(jsonElement)")
            print("for후 \(jsonResult[i])")
            
            // DBModel instance 선언
            // let query = DBModel() // 배열이 비어있으므로 밑에 query.~~~ 다 연결해준것
            
            
            //  scode는 jsonElement의 code값인데, String으로 형변환 시켜.
            if let addressNo = jsonElement["addressNo"] as? Int,
               let addressName = jsonElement["addressName"] as? String,
               let addressPhone = jsonElement["addressPhone"] as? String,
               let addressEmail = jsonElement["addressEmail"] as? String,
               let addressMemo = jsonElement["addressMemo"] as? String,
               let addressBirth = jsonElement["addressBirth"] as? String,
               let addressMvp = jsonElement["addressMvp"] as? String,
               let addressImage = jsonElement["addressImage"] as? String{
                print("addressNO:\(addressNo)")
                // 아래처럼 미리 생성해놓은 constructor 사용해도 됨.
                let query = AddressModel(addressNo: addressNo, addressName: addressName, addressPhone: addressPhone, addressEmail: addressEmail, addressMemo: addressMemo, addressBirth: addressBirth, addressMvp: addressMvp, addressImage: addressImage )
                locations.add(query) // locations 배열에 한뭉텅이씩 담기
                print("query = \(query)")
            }
            
            // locations.add(query) // locations 배열에 한뭉텅이씩 담기
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.addressItemDownloaded(items: locations)
            
        })
    }
    
} // END
