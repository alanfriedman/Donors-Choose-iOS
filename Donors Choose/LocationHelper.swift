//
//  LocationHelper.swift
//  Weather Triggers
//
//  Created by Alan Friedman on 8/4/14.
//  Copyright (c) 2014 Alan Friedman. All rights reserved.
//

import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    
    func getUserLocation() {
        // Create the location manager if this object does not
        // already have one.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        // Set a movement threshold for new events.
        locationManager.distanceFilter = 500 // meters
//        
//        if(utils.iOSVersion.floatValue >= 8.0){
        locationManager.requestWhenInUseAuthorization()
//        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: NSArray) {
        let location: CLLocation = locations.lastObject as CLLocation
        println(Double(location.coordinate.latitude))
        println(Double(location.coordinate.longitude))
        
        let userData: NSDictionary = ["lat": location.coordinate.latitude, "lng": location.coordinate.longitude]
        NSNotificationCenter.defaultCenter().postNotificationName("locationChanged", object: nil, userInfo: userData)
//        blockUIHelper.block(type: "text", message: "Cannot connect to the Internet")
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        println("Fail")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        println("Status")
    }
    
}