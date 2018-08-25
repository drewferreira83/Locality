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
/*
                if let parent = stop.relationships.parent_station {
                    print( "Stop \(stop.id) has parent \(String(describing: parent.id))")
                }
 */
                if stop.id == "door-gover-main" {
                    print( "Stop!" )
                }
                
                marks.append(Mark(stop: stop))
            }
            map.add(marks: marks)
            
        case .routes:
            guard let routes = query.response as? [Route] else {
                print("/routes returned something unexpected.")
                return
            }
            for route in routes {
                routeDict[route.id] = route
            }
            
        default:
            print( "Don't know what to do with Query \(query.kind)")
        }
    }
    
}
