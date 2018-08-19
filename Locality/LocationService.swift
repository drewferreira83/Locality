//
//  LocationDelegate.swift
//  TQuery
//
//  Created by Andrew Ferreira on 12/31/15.
//  Copyright © 2015 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

protocol LocationAccessDelegate {
    // Called when access has potentially changed
    // The MapViewController is the expected delegate and will set mapView.showsUserLocation based on settings and access.
    func access( allowed: Bool )
    func update( coordinate: CLLocationCoordinate2D)
}

//  Current priorities:
//    signifcant is prefered over standard.
enum LocationTrigger: Int {
    case standard, significant, once, never
}

class LocationService: NSObject, CLLocationManagerDelegate {
    public static let share = LocationService()
    private static let defaultLocation = CLLocation(latitude: 42.3601, longitude: -71.0589)

    fileprivate var locMgr = CLLocationManager()
    fileprivate var userLocation: CLLocation!
    fileprivate var trigger = LocationTrigger.never
    
    public var delegate: LocationAccessDelegate?
    public var here: CLLocationCoordinate2D {
        get { return locMgr.location?.coordinate ?? LocationService.defaultLocation.coordinate }
    }

    public var isEnabled: Bool {
        get { return CLLocationManager.locationServicesEnabled() }
    }
    
    // CURRENT STATE Returns true IFF user setting is true AND app has explicit authorization (not unset)
    // This is get-only!  Set UserSettings.trackUser to turn it on and off, but ask LocationService if both app
    //       and user have given permission.
    public var mayTrackUser: Bool {
        get {return isEnabled}
    }
    
    fileprivate override init() {
        userLocation = locMgr.location

        super.init()

        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.distanceFilter = 50.0
        
        // If app authorization has not been determined, ask for permission from OS
        // Once set, it will remain set until app is deleted.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locMgr.requestWhenInUseAuthorization()
        }
    }
    
    /*
    // Checks for authorization from user and App. Will start or stop monitoring based on settings.
    // This method should be called when the user changes the track setting -OR- when the app 
    // is notified of an authorization change from iOS.
    public func validate() {
        if isEnabled {
            // User OK, app OK:  Start updating!
            startMonitoring()
        }
        
        delegate?.access(allowed: isEnabled)
    }
 
    fileprivate func stopMonitoring() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            locMgr.stopUpdatingLocation()
        }
    }
    */
    
    // CLLocationDelegate METHOD
    //
    //  This is always called when the app starts and when it regains active status.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            update()
        default:
            print( "Not permitted to access location." )
        }
        delegate?.access(allowed: isEnabled)
    }
    
    //  DELEGATE METHOD
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Received updated location.
        userLocation = locations[0]
        delegate?.update(coordinate: userLocation.coordinate)
   }
    
    func update() {
        // Request latest location, if permitted.
        if  isEnabled {
            // TODO: This takes a long time in testing...
            locMgr.requestLocation()
        }
    }
    
    // DELEGATE METHOD:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print( "locationManager failed with error '\(error.localizedDescription)'\n" )
    }
}



