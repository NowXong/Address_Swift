//
//  LogInModel.swift
//  INMAC
//
//  Created by Ria Song on 2021/03/23.
//

import Foundation

protocol LogInModelProtocol: class {
    func itemDownloaded(items: Int)
}

class LogInModel: NSObject {
    var delegate : LogInModelProtocol!
    var urlPath = "http://" + Share.macIP + "/inmac/loginCheck.jsp"
    var result = 0
    
    
    func downloadItems(userEmail : String, userPw : String) {
        let urlAdd = "?userEmail=\(userEmail)&userPw=\(userPw)"
        urlPath = urlPath+urlAdd
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error)in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloading")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        
        for i in 0..<jsonResult.count{
            
            jsonElement = jsonResult[i] as! NSDictionary
            print(jsonElement)
            
            if let count = jsonElement["result"] as? Int{
                result = count
                print("count : \(count)")
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: self.result)
        })
    }
}
