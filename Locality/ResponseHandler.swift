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
            map.removeMarks(ofKind: .stop)
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
                fatalError( "/predictions returned something unexpected." )
            }
            
            // Display Prediction View with predictions data.
            let predictionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PredictionViewController") as! PredictionViewController
            
            predictionView.predictions = predictions
            
            map.show(view: predictionView.view)
            
            
        default:
            print( "Don't know what to do with Query \(query.kind)")
        }
    }
    
}
