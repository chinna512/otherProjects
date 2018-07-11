//
//  RestAPI.swift
//  EXampleChart
//
//  Created by Chinnababu on 6/19/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class RestAPI: NSURLConnection {
    
    class  func getDataForTheKeyWord(keyWord:String, callbackHandler:((NSError?, NSDictionary?) -> Void)!){
        var request = URLRequest(url:URL(string: String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/search-mpool/query/%@/", keyWord))!)
        request.setValue("Basic  aW9zYXBwQG1zb3VyY2VvbmUuY29tOlNvdXJjZW9uZUAxMjM=", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 180
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with:data!, options: [])
                let jsonData = NSMutableDictionary(dictionary:json as! NSDictionary)
                callbackHandler(nil,jsonData)
            } catch let error as NSError {
                callbackHandler(error, nil)
            }
        })
        task.resume()
    }
}
