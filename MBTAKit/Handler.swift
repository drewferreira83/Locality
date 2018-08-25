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

open class Handler: CustomStringConvertible {
    fileprivate let decoder = JSONDecoder()
    var listener: Listener!
    var activeQueries = QueryTracker()
    
    public init(  ) {

    }
    
    public var description: String {
        return "Version 3.0, August 2018"
    }
    
    // Main App Access point
    @discardableResult public func deliver(query: Query) -> Bool {
        guard listener != nil else {
            fatalError( "No one is listening.")
        }
        

        if let url = MURL.makeURL(query: query) {
           // print( "Issuing \(url)")
            // Create and issue request.
            URLSession.shared.dataTask(with: url, completionHandler: responseHandler).resume()

            // Update and track Query.
            query.issued = Date()
            activeQueries.track(query: query)
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
            let mbtaResult = try! decoder.decode(StopsData.self, from: data)
            query.response = mbtaResult.data
            
        case .routes:
            let mbtaResult = try! decoder.decode(RoutesData.self, from: data)
            query.response = mbtaResult.data
            
        default:
            fatalError( "Don't know how to handle Query \(query.kind)")
        }

        listener.receive(query: query)
    }
    
}
