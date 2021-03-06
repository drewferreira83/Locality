//
//  LocationDelegate.swift
//  TQuery
//
//  Created by Andrew Ferreira on 12/31/15.
//  Copyright © 2015 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

protocol LocationListener {
    // Called when access has potentially changed
    // The MapViewController is the expected delegate and will set mapView.showsUserLocation based on settings and access.
    func accessChanged( allowed: Bool )
    func locationChanged(coordinate: CLLocationCoordinate2D)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    //public static let share = LocationService()

    fileprivate var locMgr = CLLocationManager()
    
    fileprivate var lastLocation: CLLocation?
    
    public let listener: LocationListener!
    
    
    public var userLocation: CLLocationCoordinate2D {
        get { return lastLocation?.coordinate ?? Default.Map.center }
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
    
    init( listener: LocationListener ) {
        self.listener = listener
        lastLocation = locMgr.location
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
    // The LocationService is reporting that access to user location might have changed.
    //  Change could be caused either by a change in App access to user location -OR-
    //  the user has changed the track location option in the settings.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            update()
        default:
            print( "Not permitted to access location." )
        }
        
        listener.accessChanged(allowed: isEnabled)
    }
    
    //  DELEGATE METHOD
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Received updated location.
        manager.stopUpdatingLocation()
        let newLocation = locations[0]

        if (lastLocation == nil) || (lastLocation! != newLocation) {
            lastLocation = newLocation
            listener.locationChanged(coordinate: newLocation.coordinate)
        }
   }
    
    func update() {
        // Request latest location, if permitted.
        if  isEnabled {
            // TODO: This takes a long time in testing...
            //locMgr.requestLocation()
            locMgr.startUpdatingLocation()
        }
    }
    
    // DELEGATE METHOD:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print( "locationManager failed with error '\(error.localizedDescription)'\n" )
    }
}

extension Locality: LocationListener {
    // LocationServiceDelegate
    func accessChanged(allowed: Bool) {
        map.set( showUser: allowed)
    }
    
    func locationChanged( coordinate: CLLocationCoordinate2D ) {
        // Update the center of the map.  This function returns before the map is recentered.
        map.set( center: coordinate )

        // Get the map's region and change the center coordinate.  The Span does not change on user movement.
        // It is not sufficient to call refreshStops because the map hasn't updated its region yet from the set(center:) command.
        var newRegion = map.getRegion()
        newRegion.center = coordinate
        
        // Get the stops within the new region.
        let query = Query(kind: .stops, data: newRegion )
        handler.deliver(query: query)
    }
    
    
    func refreshStops() {
        // This gets stops that fit in current map.
        let query = Query( kind: .stops, data: map.getRegion() )
        handler.deliver(query: query)
    }
}



