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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500 // meters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: NSArray) {
        let location: CLLocation = locations.lastObject as CLLocation
        println(Double(location.coordinate.latitude))
        println(Double(location.coordinate.longitude))
        
        let userData: NSDictionary = ["lat": location.coordinate.latitude, "lng": location.coordinate.longitude]
        NSNotificationCenter.defaultCenter().postNotificationName("locationChanged", object: nil, userInfo: userData)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        println("Fail")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        println("Status")
    }
    
}