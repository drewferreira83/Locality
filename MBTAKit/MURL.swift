//
//  MURL.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

class MURL {
    // Unprocessed MBTA URL looks like
    // https://api-v3.mbta.com/  stops     ?api_key=123   &filter[latitude]=42.3601    &filter[longitude]=-71.0589
    //  URL_HEAD +              Command +   MBTA_KEY     { + Filter                      + Filter ...  }
   
    // Command one of: vehicles, trips, stops, schedules, routes, predictions, alerts
    
    static let URL_HEAD = "https://api-v3.mbta.com/"
    static let MBTA_KEY = "?api_key=0de754c34a1445aeac7cbc2c385ef0ae"
    
    static func makeURL(query: Query) -> URL? {
        var baseString: String = URL_HEAD
        
        switch ( query.kind )
        {
        case .stops:
            
            // If there is a region, use the center and get nearby stops
            if let region = query.data as? MKCoordinateRegion {
                let center = region.center
                let radius = region.maxDelta
                
                baseString.append( "stops")
                baseString.append( MBTA_KEY )
                baseString.append( "&filter[latitude]=\(center.latitude)" )
                baseString.append( "&filter[longitude]=\(center.longitude)" )
                baseString.append( "&filter[radius]=\(radius)" )
                break
            }

            // If the data is an stop ID
            if let stopID = query.data as? String {
                baseString.append( "stops" )
                baseString.append( MBTA_KEY)
                baseString.append( "&filter[id]=\(stopID)")
                break
            }
            
            
            print( "ERROR: Stop requires a StopID string, coordinate, or region." )
            return nil
            
        case .routes:
            // Routes takes either no arg
            baseString.append( "routes" )
            baseString.append( MBTA_KEY )
            
        case .trips:
            // Trips take a tripID.
            if let tripID = query.data as? String {
                baseString.append( "trips" )
                baseString.append( MBTA_KEY)
                baseString.append( "&filter[id]=\(tripID)")
                break
                
            }
            
            print( "ERROR: Trips expected a tripID" )
            return nil
            
        case .vehicles:
            // If the data is a Stop
            if let stop = query.data as? Stop {
                baseString.append( "vehicles" )
                baseString.append( MBTA_KEY)
                baseString.append( "&filter[route]=Red")
                break
            }
            
            
        default:
            print( "Don't know how to make URL for '\(query.kind)")
            return nil
        }
        
        guard let url = URL( string: baseString ) else {
            print( "Failed to create URL from \(baseString)")
            return nil
        }
        
        query.url = url
        
        return  url
        
    }
}

extension MKCoordinateRegion {
    // Return the larger of the width or height of the region.
    public var maxDelta: Double {
        return max( span.latitudeDelta, span.longitudeDelta )
    }
}
