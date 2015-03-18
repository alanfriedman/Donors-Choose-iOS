//
//  URLRequestHelper.swift
//  Weather Triggers
//
//  Created by Alan Friedman on 8/6/14.
//  Copyright (c) 2014 Alan Friedman. All rights reserved.
//

import Foundation

class URLRequestHelper: NSObject {
    
    var timer: NSTimer = NSTimer()
    
    func performHTTPRequest(host: String, path: String?, query: String?, method: String, params: Dictionary<String, AnyObject>?, callback: (json: AnyObject) -> Void){

//        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("blockUI"), userInfo: nil, repeats: false)
        
        var paramsDict = params
        
        var qStr: String = "?"
        var counter: Int = 0
        
//        for (key, val) in paramsDict {
//            if counter == 0 {
//                qStr = qStr + key + "=" + (val as String)
//            } else {
//                qStr = qStr + "&" + key + "=" + (val as String)
//            }
//            counter++
//        }
        
        var components: NSURLComponents = NSURLComponents()
        components.scheme = "http"
        components.host = host
        components.path = path?
        components.query = query
        
//        println(components.host)
//        println(components.path)
        
        var fullURL = components.URL
//        println(components.URL)
        
//        var fullURL = NSURL(string: url)!
//        if path != nil {
//            fullURL = fullURL.URLByAppendingPathComponent(path!)
//        }
        var request = NSMutableURLRequest(URL: fullURL!)
        
        
        var session = NSURLSession.sharedSession()
        
        var err: NSError?
        
        if method != "GET" {
            request.HTTPMethod = method
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(paramsDict!, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(), {
//                println("Response: \(response)")
//                println("Error: \(error)")
                self.timer.invalidate()
//                blockUIHelper.unblock()
                if(data.length != 0) {
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: NSErrorPointer()) as? NSDictionary
//                    println("JSON return: \(json!)")
                    println("JSON returned...")
                    if(json == nil) {
//                        blockUIHelper.block(type: "text", message: "There was a problem with your request.", autoFade: true)
//                            callback(json: ["error": true])
//                        return
                    } else {
                        if json!["error"] == nil {
                            callback(json: json!)
                        } else {
//                            blockUIHelper.block(type: "text", message: "There was a problem with your request.", autoFade: true)
//                            callback(json: ["error": true])
                        }
                    }
                } else {
                    println("No data returned")
                }
            })
        })
        
        task.resume()
        
    }
//    
//    func blockUI() {
//        blockUIHelper.block(type: "activity")
//    }
}

var urlRequestHelper: URLRequestHelper = URLRequestHelper()
