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
        print( "Received \(query)")
        
        switch query.kind {
        case .stops:
            guard let stops = query.response as? [Stop] else {
                print( "/stops returned something unexpected.")
                return
            }

            //  Create marks for the stops.
            var marks = [Mark]()
            for stop in stops {
                // Ignore child stations.
                if stop.parentStation == nil {
                    marks.append(Mark(stop: stop))
                }
            }
            map.removeAllMarks()
            map.add(marks: marks)
            
        case .routes:
            guard let routes = query.response as? [Route] else {
                print("/routes returned something unexpected.")
                return
            }
            for route in routes {
                routeDict[route.id] = route
            }
            print( "Loaded \(routeDict.count) routes")
            
        default:
            print( "Don't know what to do with Query \(query.kind)")
        }
    }
    
}
