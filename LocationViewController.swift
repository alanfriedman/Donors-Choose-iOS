//
//  LocationViewController.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/17/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITextFieldDelegate {
    let locHelper = LocationHelper()
    
    var cancelClosure: (() -> ())?
    var useCurrentLocationClosure: ((lat: Double, lng: Double) -> ())?
    var useZipCodeClosure: ((zip: String) -> ())?
    
    @IBOutlet weak var zipField: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience init(hasLoc: Bool) {
        let appBundle = NSBundle.mainBundle()
        self.init(nibName: "LocationViewController", bundle: appBundle)
        if hasLoc {
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
            navigationItem.leftBarButtonItem = cancelItem
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let zip = zipField!.text
        self.useZipCodeClosure?(zip: zip)
        
        return true
    }
    
    func cancel(sender: AnyObject) {
        self.cancelClosure?()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationChanged:", name:"locationChanged", object: nil)
        
        self.title = "Choose Location"

    }
    
    @IBAction func useCurrentLocation(sender: AnyObject) {
        
        locHelper.getUserLocation()
        
    }
    
    func locationChanged(notification: NSNotification) {
        var lat: Double?
        var lng: Double?
        if let userInfo = notification.userInfo {
            if let latitude: Double = userInfo["lat"] as? Double {
                lat = latitude
            }
            if let longitude: Double = userInfo["lng"] as? Double {
                lng = longitude
            }

            self.useCurrentLocationClosure?(lat: lat!, lng: lng!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitZipCode(sender: AnyObject) {
        let zip = zipField!.text
        self.useZipCodeClosure?(zip: zip)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
