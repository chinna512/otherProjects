//
//  RestAPI.swift
//  EXampleChart
//
//  Created by Chinnababu on 6/19/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class RestAPI: NSURLConnection {
    
    class  func getDataForTheKeyWord(keyWord:String, index:Int,searchValue:String, callbackHandler:((NSError?, NSDictionary?) -> Void)!){
        var urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/search-mpool/query/%@/", keyWord)
        if index == 100{
           urlString =  String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/skill-compensation-search/query/%@/level/%@", keyWord,searchValue)
        }
        let query  = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url:URL(string:query!)!)
        request.setValue("Basic  aW9zYXBwQG1zb3VyY2VvbmUuY29tOlNvdXJjZW9uZUAxMjM=", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 180
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if data != nil{
                do {
                    let json = try JSONSerialization.jsonObject(with:data!, options: [])
                    let jsonData = NSMutableDictionary(dictionary:json as! NSDictionary)
                    callbackHandler(nil,jsonData)
                } catch let error as NSError {
                    callbackHandler(error, nil)
                }
            }else{
                callbackHandler(error! as NSError, nil)
            }
        })
        task.resume()
    }
    
    class  func getDataForSubSearchToTheKeyWord(keyWord:String, index:Int,searchValue:String, callbackHandler:((NSError?, NSMutableArray?) -> Void)!){
        
        var urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/search-mpool/query/%@/", keyWord)
        if index == 50{
            urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/organization-movement-search/query/sap/organization-name/%@/", keyWord)

        }
        if index == 60{
            
            urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/location-movement-search/query/sap/location-name/%@/", keyWord)
            
        }
        if index == 70{
            urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/organization-by-location-search/query/sap/location-name/%@/", keyWord)
        }
        
        if index == 100{
            urlString = String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/skill-compensation-search/query/%@/level/%@", keyWord,searchValue)
        }
        if index == 110{
            urlString =  String(format: "https://www.hiringnow.com/mPoolSearch-portlet/api/secure/jsonws/share/skill-suggester/query/%@", keyWord)
        }
        let query  = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url:URL(string:query!)!)
        request.setValue("Basic  aW9zYXBwQG1zb3VyY2VvbmUuY29tOlNvdXJjZW9uZUAxMjM=", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 180
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if data != nil{
                do {
                    let json = try JSONSerialization.jsonObject(with:data!, options: [])
                    let jsonArray = NSMutableArray(array: json as! NSArray)
                    callbackHandler(nil,jsonArray)
                } catch let error as NSError {
                    callbackHandler(error, nil)
                }
            }else{
                callbackHandler(error as NSError?, nil)
            }
        })
        task.resume()
    }
}
