//
//  MapViewController.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/15/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, LocationAccessDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func reload(_ sender: Any) {
        LocationService.share.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LocationService.share.delegate = self
        //update(coordinate: LocationService.share.here)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // LocationServiceDelegate
    func access( allowed: Bool){
        // The LocationService is reporting that access to user location might have changed.
        //  Change could be caused either by a change in App access to user location -OR-
        //  the user has changed the track location option in the settings.
        mapView.showsUserLocation = allowed
    }
    
    func update( coordinate: CLLocationCoordinate2D ) {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(coordinate, span)

        mapView.setRegion(region, animated: true)
        
        //let package = Package(kind: .stopsByLocation, data: coordinate)
   }
    

}

