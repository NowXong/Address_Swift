//
//  AddressInsertModel.swift
//  inmac
//
//  Created by Ria Song on 2021/03/23.
//

import Foundation
protocol AdrMaxModelProtocol: class{
    func adrMaxItemDownloaded(items: Int)
}

class AddressInsertModel: NSObject{
    
    // 01 address 테이블 에 입력
    var urlPath01 = "http://" + Share.macIP + "/inmac/addressInsert01.jsp"
    
    // 02 Max 값 구하기
    var delegate: AdrMaxModelProtocol!
    var urlPath02 = "http://" + Share.macIP + "/inmac/addressInsert02.jsp"
    var adrMax = 0
    
    // 03 register 테이블 에 입력
    var urlPath03 = "http://" + Share.macIP + "/inmac/addressInsert03.jsp"
    
    // 01 시작 ***********************************************************************
    // insertItems의 () 매개변수들은 AddViewController에서 값을 넣어줘서 함께 실행할거고 → Bool로 실행 여부 확인할거야.
    func addressInsertItems(addressName: String, addressPhone: String, addressEmail: String, addressMemo: String, addressBirth: String, at filepath: URL, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        let urlAdd01 = "?addressName=\(addressName)&addressPhone=\(addressPhone)&addressEmail=\(addressEmail)&addressMemo=\(addressMemo)&addressBirth=\(addressBirth)"
        urlPath01 = urlPath01 + urlAdd01
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath01 = urlPath01.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath01)! // 텍스트 글자를 url모드로 바꿔줌
        let parameters = [
            "name" : ""
        ]
        
        // 경로로부터 요청을 생성한다. 이 때 Content-Type 헤더 필드를 변경한다.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\"XXXXX\"",
                         forHTTPHeaderField: "Content-Type")
        
        // 파일URL로부터 multipart 데이터를 생성하고 업로드한다.
        if let data = buildBody(with: filepath, parameters: parameters) {
            let task = URLSession.shared.uploadTask(with: request, from: data){ data, res, _ in
                completionHandler(data, res)
            }
            task.resume()
        }
    } // func END (addressInsertItems)
    
    func buildBody(with fileURL: URL, parameters: [String: String]?) -> Data? {
        // 파일을 읽을 수 없다면 nil을 리턴
        guard let filedata = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        // 바운더리 값을 정하고,
        // 각 파트의 헤더가 될 라인들을 배열로 만든다.
        // 이 배열을 \r\n 으로 조인하여 한 덩어리로 만들어서
        // 데이터로 인코딩한다.
        let boundary = "XXXXX"
        let mimetype = "image/jpeg"
        let headerLines = ["--\(boundary)",
                           "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"",
                           "Content-Type: \(mimetype)",
                           "\r\n"]
        var data = headerLines.joined(separator:"\r\n").data(using:.utf8)!
        
        // 그 다음에 파일 데이터를 붙이고
        data.append(contentsOf: filedata)
        data.append(contentsOf: "\r\n".data(using: .utf8)!)
        
        // 일반적인 데이터 넣을때 사용하는 폼
        // --\(boundary)\r\n
        // Content-Disposition: form-data; name=\"값\"\r\n\r\n
        // 내용\r\n
        let lines = ["--\(boundary)","Content-Disposition: form-data; name=\"name\"\r\n","values\r\n"]
        data.append(contentsOf: lines.joined(separator: "\r\n").data(using: .utf8)!)
        
        // 마지막으로 데이터의 끝임을 알리는 바운더리를 한 번 더 사용한다.
        // 이는 '새로운 개행'이 필요하므로 앞에 \r\n이 있어야 함에 유의 한다.
        data.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        return data
    }// func END (buildBody)
    
    
    // 사진 없을 때
    func addressInsertXItems(addressName: String, addressPhone: String, addressEmail: String, addressText: String, addressBirth: String, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        let urlAdd01 = "?addressName=\(addressName)&addressPhone=\(addressPhone)&addressEmail=\(addressEmail)&addressText=\(addressText)&addressBirth=\(addressBirth)"
        urlPath01 = urlPath01 + urlAdd01
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath01 = urlPath01.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath01)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        // task
        let task = defaultSession.dataTask(with: url){ data, res, _ in
            completionHandler(data, res)
        }
        task.resume()
    } // func END
    
    // 01 끝 ***********************************************************************
    
    
    // 02 시작 ***********************************************************************
    func adrMaxItems(){
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    
        let url = URL(string: urlPath02)!
        
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
        print("Max")
        
        for i in 0..<jsonResult.count{
            // jsonResult[i]번째를 NSDictionary 타입으로 변환
            jsonElement = jsonResult[i] as! NSDictionary
            
            //  scode는 jsonElement의 code값인데, String으로 형변환 시켜.
            if let addressNo = jsonElement["addressNo"] as? Int{
                self.adrMax = addressNo
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.adrMaxItemDownloaded(items: self.adrMax)
        })
    }
    // 02 끝 ***********************************************************************
    
    
    // 03 시작 ***********************************************************************
    func adrInsert03Items(userEmail: String, addressNo: Int, completionHandler: @escaping(Data?, URLResponse?) -> Void) {

        let urlAdd03 = "?userEmail=\(userEmail)&addressNo=\(addressNo)"
        urlPath03 = urlPath03 + urlAdd03
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath03 = urlPath03.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath03)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        // task
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data") // 앱스토어에 올릴때는 print 부분 다 지워야 함
            } else {
                print("Data is inserted!")
            }
        }
        task.resume() // resume()을 해줘야 task가 실행 된다.

    } // func END
    // 01 끝 ***********************************************************************
}
