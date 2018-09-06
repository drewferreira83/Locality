//
//  ResponseHandler
//  Locality
//
//  Created by Andrew Ferreira on 8/20/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

extension Locality {

    // NEVER ON THE MAIN THREAD!!!!
    public func process(query: Query) {
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
                if stop.parentID == nil {
                    marks.append(Mark(stop: stop))
                }
            }
            
            // Remove old stops.
            map.removeMarks(ofKind: .stop)
            map.add(marks: marks)
            
        case .routes:
            guard let routes = query.response as? [Route] else {
                print("/routes returned something unexpected.")
                return
            }
            
            // If these routes are for a particular stop, then display the routes.
            if let stop = query.data as? Stop {
                map.show(routes: routes, for: stop)
                return
            }
            
            print( "Got /Routes, but didn't have associated stop. \(query)")
            
        case .vehicles:
            guard let vehicles = query.response as? [Vehicle] else {
                print( "/vehicles returned something unexpected." )
                return
            }
            
            var marks = [Mark]()
            for vehicle in vehicles {
                marks.append( Mark(vehicle: vehicle))
            }
            
            map.removeMarks(ofKind: .vehicle)
            map.add(marks: marks)
            print( "Displayed \(marks.count) vehicles.:")
            
        case .predictions:
            guard let predictions = query.response as? [Prediction] else {
                fatalError( "/predictions returned something unexpected. \(query)")
            }
            guard let stop = query.data as? Stop else {
                fatalError( "Could not get Stop from prediction data. \(query)")
            }
            map.show( predictions: predictions, for: stop )
            
        default:
            print( "Don't know what to do with Query \(query.kind)")
        }
    }
    
}
