//
//  LocationViewController.swift
//  Donors Choose
//
//  Created by Alan Friedman on 3/17/15.
//  Copyright (c) 2015 Alan Friedman. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    let locHelper = LocationHelper()
    
    @IBOutlet weak var zipField: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
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
            let propsVC = ProposalsViewController(lat: lat!, lng: lng!, zip: nil)
            navigationController?.pushViewController(propsVC, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitZipCode(sender: AnyObject) {
        let zip = zipField!.text
        let propsVC = ProposalsViewController(lat: nil, lng: nil, zip: zip)
        navigationController?.pushViewController(propsVC, animated: true)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        println("HERE")
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
