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
        
        switch (query.kind) {
        case .stops:
            let jxStopsData = try! decoder.decode( JXStopsData.self , from: data)
            query.response = jxStopsData.export()
            
        case .routes:
            let jxRoutesData = try! decoder.decode(JXRoutesData.self, from: data)
            query.response = jxRoutesData.export()
            
        case .vehicles:
            let jxVehicleData = try! decoder.decode(JXVehiclesData.self, from: data)
            query.response = jxVehicleData.export()
            
        case .predictions:
            let jxPredictionData = try! decoder.decode(JXPredictionData.self, from: data)
            query.response = jxPredictionData.export()
            
        default:
            fatalError( "Don't know how to handle Query \(query.kind)")
        }

        listener.receive(query: query)
    }
    
    override open var description: String {
        return "Version 3.0, August 2018"
    }

}
