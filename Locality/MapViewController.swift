//
//  MapViewController.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/15/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

// Only use these methods to interact with the MKMapView.
protocol MapManager {
    func getRegion() -> MKCoordinateRegion
    
    func set( showUser: Bool )
    func set( region: MKCoordinateRegion )
    func set( center: CLLocationCoordinate2D )
    
    func add( marks: [Mark])
    func removeMarks(ofType: MarkType)
    func removeAllMarks()
}

class MapViewController: UIViewController, MapManager {

    var locality: Locality!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func reload(_ sender: Any) {
        // Request should go to Locality object
        //LocationService.share.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setRegion(Default.Map.region, animated: false)
        
        // Start functionality.
        locality = Locality( mapManager: self )
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /****  PUBLIC FUNCTIONS  ****/
    
    public func set( showUser: Bool ){
        // The LocationService is reporting that access to user location might have changed.
        //  Change could be caused either by a change in App access to user location -OR-
        //  the user has changed the track location option in the settings.
        DispatchQueue.main.async {
            self.mapView.showsUserLocation = showUser
        }
    }
    
    func set( region: MKCoordinateRegion ) {
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func set( center: CLLocationCoordinate2D ) {
        DispatchQueue.main.async {
            self.mapView.setCenter(center, animated: true)
        }
    }
    
    func getRegion() -> MKCoordinateRegion {
        return mapView.region
    }
    
    func add( marks: [Mark] ) {
       DispatchQueue.main.async {
            self.mapView.addAnnotations(marks)
        }
    }
    
    func removeMarks(ofType: MarkType) {
        var matchingMarks = [Mark]()
        for annotation in mapView.annotations {
            if let mark = annotation as? Mark {
                if mark.type == ofType  {
                    matchingMarks.append( mark )
                }
            }
        }
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(matchingMarks)
        }
    }
    
    func removeAllMarks() {
        let annotations = mapView.annotations
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(annotations)
        }
    }
}

