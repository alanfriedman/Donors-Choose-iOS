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
    
    func performHTTPRequest(host: String, path: String?, query: String?, method: String, params: Dictionary<String, AnyObject>?, callback: (json: AnyObject) -> ()){

        var paramsDict = params
        
        var qStr: String = "?"
        var counter: Int = 0
        
        var components: NSURLComponents = NSURLComponents()
        components.scheme = "http"
        components.host = host
        components.path = path?
        components.query = query
        
        var fullURL = components.URL

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
                self.timer.invalidate()
                if(data.length != 0) {
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: NSErrorPointer()) as? NSDictionary
                    println("JSON returned...")
                    if json != nil {
                        if json!["error"] == nil {
                            callback(json: json!)
                        }
                    }
                } else {
                    println("No data returned")
                }
            })
        })
        
        task.resume()
        
    }
}

var urlRequestHelper: URLRequestHelper = URLRequestHelper()
