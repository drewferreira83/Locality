//
//  MBTAHandler.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//
// The main app channels all MBTA queries through the handler.  The handler does boring
// stuff like issuing and tracking queries and reporting on timeouts and errors.
//
// MURL makes the URL to be sent to the MBTA server.

//

import Foundation
import MapKit

public protocol Listener {
    func receive(query: Query) -> Void
}

open class Handler: NSObject {
    

    fileprivate let decoder = JSONDecoder()
    let listener: Listener
    var activeQueries = QueryTracker()
    
    public init( listener: Listener ) {
        self.listener = listener
        super.init()
    }
    
    
    // Main App Access point
    @discardableResult public func deliver(query: Query) -> Bool {
        if query.kind == .outstanding {
            print( ".outstanding query not implemented yet." )
            return false
        }

        if let url = MURL.makeURL(query: query) {
            print( "***Issuing \(url)")

            // Update and track Query.
            query.issued = Date()
            activeQueries.track(query: query)

            // Create and issue request.
            URLSession.shared.dataTask(with: url, completionHandler: responseHandler).resume()

            return( true )
        }
        
        print( "MURL Error...")
        return false
    }
    
    fileprivate func responseHandler( _ data: Data?, response: URLResponse?, error: Error? ) -> Void {
        guard error == nil else {
            print( "Handler got error \(error!.localizedDescription)")
            return
        }
        guard let data = data else {
            print( "No Data in handler?")
            return
        }
        guard let url = response?.url else {
            print( "Can't find response url in handler?" )
            return
        }
        
        // Look up matching Query
        guard let query = activeQueries.find(matchingUrl: url, andRemove: true ) else {
            print( "Handler got unexpeected response! \(url)")
            return
        }

        query.received = Date()
        
        let jxTop = try! decoder.decode(JXTop.self, from: data)
        guard jxTop.errors == nil else {
            fatalError( "Error reported: \(jxTop.errors!)")
        }
        guard let jxTopData = jxTop.data else {
            fatalError( "Decoder got no data." )
        }

        
        // TODO:  Complete processing of attributes for each type of object returned.
        // Modify exposed classes to take JXObject!  stop = Stop( element )
        switch (query.kind) {

        case .stops:
            var stops = [Stop]()
            
            for element in jxTopData {
                let stop = Stop(source: element)
                
                // If the stop has a parentID, then look for any included info.
                if let parentID = stop.parentID, let jxParentObject = jxTop.search(forKind: .stop, id: parentID) {
                    // Store the parent stop information
                    stop.parentStop = Stop(source: jxParentObject)
                }

                stops.append( stop )
            }
            query.response = stops
            
        case .routes:
            var routes = [Route]()
            
            for element in jxTopData {
                routes.append( Route(source: element) )
            }
            
            query.response = routes
            /*
        case .vehicles:
            let jxVehicleData = try! decoder.decode(JXVehiclesData.self, from: data)
            query.response = jxVehicleData.export()
*/
        case .predictions:
            var predictions = [Prediction]()
            
            for element in jxTopData {
                let prediction = Prediction( source: element )
                
                // Now create and store Route, Stop, and Trip info
                guard let jxRouteObject = jxTop.search(forKind: .route, id: prediction.routeID) else {
                    fatalError( "Predictions did not include route data. \(element)")
                }
                prediction.route = Route( source: jxRouteObject )
                
                guard let jxStopObject = jxTop.search(forKind: .stop, id: prediction.stopID) else {
                    fatalError( "Predictions did not include stop data. \(element)")
                }
                prediction.stop = Stop( source: jxStopObject )
                
                predictions.append( prediction )
            }
            
            query.response = predictions

        default:
            fatalError( "Don't know how to handle Query \(query.kind)")
        }

        listener.receive(query: query)
    }
    
    override open var description: String {
        return "Version 3.0, August 2018"
    }

}


