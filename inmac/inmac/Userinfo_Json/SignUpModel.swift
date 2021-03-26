//
//  SignUpModel.swift
//  INMAC
//
//  Created by Ria Song on 2021/03/23.
//

import Foundation

class SignUpModel: NSObject{
    
    var urlPath = "http://" + Share.macIP + "/inmac/memberInsert.jsp"
    
    var urlPathCheck = "http://" + Share.macIP + "/inmac/idCheck.jsp"
    
    
    // insertItems의 () 매개변수들은 AddViewController에서 값을 넣어줘서 함께 실행할거고 → Bool로 실행 여부 확인할거야.
    func userSignUpItems(userEmail: String, userPw: String, userName: String, userPhone: String) -> Bool {
        var result: Bool = true
        let urlAdd = "?userEmail=\(userEmail)&userPw=\(userPw)&userName=\(userName)&userPhone=\(userPhone)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        // task
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to user signup data") // 앱스토어에 올릴때는 print 부분 다 지워야 함
                result = false
            } else {
                print("Data is user signup!")
                result = true
            }
        }
        task.resume() // resume()을 해줘야 task가 실행 된다.
        return result
    } // func END
    
    
    // 
    // insertItems의 () 매개변수들은 AddViewController에서 값을 넣어줘서 함께 실행할거고 → Bool로 실행 여부 확인할거야.
    func userIdCheckItems(userEmail: String) -> Bool {
        var result: Bool = true
        let urlAdd = "?userEmail=\(userEmail)"
        urlPathCheck = urlPathCheck + urlAdd
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPathCheck = urlPathCheck.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPathCheck)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        // task
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to user id check data") // 앱스토어에 올릴때는 print 부분 다 지워야 함
                result = false
            } else {
                print("Data is user id check!")
                result = true
            }
        }
        task.resume() // resume()을 해줘야 task가 실행 된다.
        return result
    } // func END
}
