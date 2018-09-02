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
    
    static let URL_HEAD = "https://api-v3.mbta.com"
    static let MBTA_KEY = "?api_key=0de754c34a1445aeac7cbc2c385ef0ae"
    
    static func makeURL(query: Query) -> URL? {
        var baseString: String = URL_HEAD
        
        switch ( query.kind )
        {
        case .stops:
            baseString.append( "/stops")
            baseString.append( MBTA_KEY )
            baseString.append( "&include=parent_station" )

            // If there is a region, use the center and get nearby stops
            if let region = query.data as? MKCoordinateRegion {
                let center = region.center
                let radius = region.maxDelta
                
                baseString.append( "&filter[latitude]=\(center.latitude)" )
                baseString.append( "&filter[longitude]=\(center.longitude)" )
                baseString.append( "&filter[radius]=\(radius)" )
                break
            }

            // If the data is an stop ID
            if let stopID = query.data as? String {
                baseString.append( "&filter[id]=\(stopID)")
                break
            }
            
            fatalError( "Stops query requires an ID or region. Data=\(String(describing:query.data))" )
            
        case .routes:
            // If Data is nil, return all routes
            // If Data is a string, return route with that ID
            // if Data is a stop, return routes at that stop
            baseString.append( "/routes" )
            baseString.append( MBTA_KEY )
            baseString.append("&sort=sort_order")
            if let routeID = query.data as? String {
                baseString.append( "&filter[id]=\(routeID)" )
            }
            if let stop = query.data as? Stop {
                baseString.append( "&filter[stop]=\(stop.id)")
            }

        case .trips:
            baseString.append( "/trips" )
            baseString.append( MBTA_KEY)

            // Trips take a tripID.
            if let tripID = query.data as? String {
                baseString.append( "&filter[id]=\(tripID)")
                break
                
            }
            
            if let route = query.data as? Route {
                baseString.append( "&filter[route]=\(route.id)" )
                break
            }
            
            fatalError( "Trips query requires an ID or Route. data=\(String(describing:query.data))")
            
        case .vehicles:
            baseString.append( "/vehicles" )
            baseString.append( MBTA_KEY)

            // No data means get all.
            if query.data == nil {
                break
            }
            
            // Valid parameters are Route and Vehicle ID
            if let route = query.data as? Route {
                baseString.append( "&filter[route]=\(route.id)")
                break
            }
            
            if let id = query.data as? String {
                baseString.append( "&filter[id]=\(id)")
                break
            }
            
            if let trip = query.data as? Trip {
                baseString.append( "&filter[trip]=\(trip.id)" )
            }

            fatalError( "Vehicle Query requires an ID, Route, or Trip.  data=\(String(describing: query.data))")
            
        case .predictions:
            baseString.append("/predictions")
            baseString.append( MBTA_KEY )
            
            if let stop = query.data as? Stop {
                baseString.append( "&sort=departure_time,arrival_time")
                baseString.append( "&include=route,stop,trip,vehicle" )
                baseString.append( "&filter[stop]=\(stop.id)")
                break
            }
            
            fatalError( "Prediction Query requires Stop. data=\(String(describing:query.data))")
            
        default:
            fatalError( "Unsupported query: \(query.kind)" )
        }
        
        
        guard let url = URL( string: baseString ) else {
            fatalError( "Failed to create URL from \(baseString)" )
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
