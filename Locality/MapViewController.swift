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
    func removeMarks(ofKind: Mark.Kind)
    func getMarks(ofKind: Mark.Kind) -> [Mark]
    
    func show( predictions: [Prediction], for stop: Stop )
    func hidePredictions()
    
    // showDetail( predictions:)
    func show( routes: [Route], for stop: Stop )
    // showDetail( vehicle: )
    
}

class MapViewController: UIViewController, MapManager {
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func reload(_ sender: Any) {
        // Request should go to Locality object
        locality.refreshStops()
    }
    
    var predictionViewController: PredictionViewController!
    var locality: Locality!
    
    var selectedMarkView: MarkView?
    
    override func viewDidLoad() {
        predictionViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PredictionViewController") as! PredictionViewController)
        
        super.viewDidLoad()

        addChildViewController(predictionViewController)
        view.addSubview(predictionViewController.view)

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
    
    func removeMarks(ofKind: Mark.Kind) {
        let matchingMarks = getMarks(ofKind: ofKind)
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(matchingMarks)
        }
    }
    
    func getMarks(ofKind: Mark.Kind) -> [Mark]{
        var matchingMarks = [Mark]()
        for annotation in mapView.annotations {
            if let mark = annotation as? Mark {
                if ofKind == .all || ofKind == mark.kind {
                    matchingMarks.append( mark )
                }
            }
        }
        
        return matchingMarks
    }
    
    func hidePredictions() {
        DispatchQueue.main.async {
            self.predictionViewController.dismissAnimated()
        }
    }
    
    func show(predictions: [Prediction], for stop: Stop) {
        DispatchQueue.main.async {
            self.predictionViewController.titleLabel.text = stop.name
            self.predictionViewController.predictions = predictions
            self.predictionViewController.showAnimated()
        }
    }
    
    func show( routes: [Route], for stop: Stop ) {
        guard let markView = selectedMarkView else {
            print( "Got routes for stop \(stop) but that MarkView is not selected." )
            return
        }

        let listOfRoutes = NSMutableAttributedString()
        for route in routes {
            if listOfRoutes.length > 0 {
                listOfRoutes.append( NSAttributedString(string: " "))
            }
            listOfRoutes.append(route.colorfy(string: Strings.NBSP + route.abbreviatedName + Strings.NBSP))
        }
        
        DispatchQueue.main.async {
            markView.routeLabel.attributedText = listOfRoutes
            markView.routeLabel.layoutIfNeeded()
        }
    }

}
