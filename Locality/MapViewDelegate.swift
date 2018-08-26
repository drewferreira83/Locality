//
//  MapViewDelegate.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/24/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // This is for custom annotations on the map, like stations and vehicles.  This refers to the
    // displayed symbol on the map, NOT THE CALLOUT BUBBLE.
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
        // Are we working with a custom annotation?
        if let mark = annotation as? Mark {
            if let markView = mapView.dequeueReusableAnnotationView(withIdentifier: MarkView.Identifier) as? MarkView {
                // We are reusing this annotation.  Need to overwrite the old values.
                markView.annotation = mark
                markView.updateImage()
                return markView
            } else {
                // Need to create a new custom annotation view
                return MarkView(mark: mark)
            }
        }
        
        return nil
    }
    
    //  This doesn't seem to be hit when the view is selected programmatically.
    //  If you do select it programmatically, call this function also.
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let markView = view as? MarkView {
            if let mark = markView.mark {
                locality.didSelect( mark: mark )
            }
        }
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // For the custom annotation views, send the callout away.
        if let markView = view as? MarkView {
            // Inform the core.
            print( "Deselected \(markView.description)")
            //didDeselect( markView: markView )
        }
    }
    
    //  Tapping on the simple bubble on an anno will trigger the detail to appear at the bottom of the screen.
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let markView = view as? MarkView {
            print( "Do display Detail for \(markView.description)")
            // displayDetailView(for: markView )
        }
    }
    
    // Need to turn off the callout for the User Location annotation view.
    // Can only change it here for some reason.
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.canShowCallout = !(view.annotation is MKUserLocation)
        }
    }
}

extension Locality {
    func didSelect( mark: Mark ) {
        
        switch mark.kind {
        case .stop:
            guard let stop = mark.stop else {
                fatalError( "No Stop data for Mark \(mark)")
            }
            // Get predictions at this stop.
            let query = Query(kind: .predictions, data: stop)
            handler.deliver(query: query)
            
        default:
            print( "Selected \(mark), but ignored" )
        }
    }
}
