//
//  MBTAService.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/20/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

extension Locality: Listener {

     // NEVER ON THE MAIN THREAD!!!!
    public func receive(query: Query) {
        print( "Got a Query!")
        switch query.kind {
        case .stops:
            guard let stops = query.response as? [Stop] else {
                print( "/stops returned something unexpected.")
                return
            }
            for stop in stops {
                print( stop.attributes.name)
            }
            
        case .routes:
            guard let routes = query.response as? [Route] else {
                print("/routes returned something unexpected.")
                return
            }
            for route in routes {
                routeDict[route.id] = route
                print( route.attributes.long_name)
            }
            
        default:
            print( "Don't know what to do with Query \(query.kind)")
        }
    }
    
}
