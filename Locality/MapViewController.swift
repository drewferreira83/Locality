//
//  MapViewController.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/15/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

protocol MapService {
    func set( showUser: Bool )
    func set( region: MKCoordinateRegion)
}

class MapViewController: UIViewController, MapService {
    var locality: Locality!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func reload(_ sender: Any) {
        // Request should go to Locality object
        //LocationService.share.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Start functionality.
        locality = Locality( map: self )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func set( showUser: Bool){
        // The LocationService is reporting that access to user location might have changed.
        //  Change could be caused either by a change in App access to user location -OR-
        //  the user has changed the track location option in the settings.
        mapView.showsUserLocation = showUser
    }
    
    func set( region: MKCoordinateRegion ) {
        mapView.setRegion(region, animated: true)
   }
    

}

