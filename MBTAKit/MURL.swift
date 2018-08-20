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
    
    static func makeURL(package: Package) -> URL? {
        var baseString: String = URL_HEAD
        
        switch ( package.kind )
        {
        case .stops:
            // If the data is a coordinate
            if let coordinate = package.data as? CLLocationCoordinate2D {
                baseString.append( "stops?")
                baseString.append( MBTA_KEY )
                baseString.append( "&filter[latitude]=\(coordinate.latitude)&filter[longitude]=\(coordinate.longitude)" )
                break
            }

            // If the data is an stop ID
            if let stopID = package.data as? String {
                baseString.append( "stops?" )
                baseString.append( MBTA_KEY)
                baseString.append( "&filter[id]=\(stopID)")
                break
            }
            print( "ERROR: Stop requires a StopID string or CLLocationCoordinate2D")
            return nil
            
        default:
            print( "Don't know how to make URL for '\(package.kind)")
            return nil
        }
        
        guard let url = URL( string: baseString ) else {
            print( "Failed to create URL from \(baseString)")
            return nil
        }
        
        package.url = url
        
        return  url
        
    }
}
