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

public protocol MBTAListener {
    func receive(package: Package) -> Void
}



open class MBTAHandler: CustomStringConvertible {
    public static let share = MBTAHandler()
    
    fileprivate let decoder = JSONDecoder()
    var listener: MBTAListener?
    var activePackages = PackageTracker()
    
    private init() {
    
    }
    
    public func register( listener: MBTAListener) {
        self.listener = listener
    }
    
    public var description: String {
        return "Version 3.0, August 2018"
    }
    
    // Main App Access point
    @discardableResult public func deliver(package: Package) -> Bool {
        guard listener != nil else {
            fatalError( "No one is listening.")
        }
        

        if let url = MURL.makeURL(package: package) {
            // Create and issue request.
            URLSession.shared.dataTask(with: url, completionHandler: newStyleHandler).resume()

            // Update and track package.
            package.issued = Date()
            activePackages.track(package: package)
            return( true )
        }
        
        print( "MURL Error...")
        return false
    }
    
    fileprivate func newStyleHandler( _ data: Data?, response: URLResponse?, error: Error? ) -> Void {
        guard listener != nil else {
            fatalError( "No one is listening to handler" )
        }
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
        
        // Look up matching package
        guard let package = activePackages.find(matchingUrl: url, andRemove: true ) else {
            print( "Handler got unexpeected response! \(url)")
            return
        }

        package.received = Date()
        
        switch (package.kind) {
        case .stops:
            let mbtaResult = try! decoder.decode(StopsData.self, from: data)
            package.response = mbtaResult.data
            
        default:
            fatalError( "Don't know how to handle package \(package.kind)")
        }

        listener!.receive(package: package)
    }
    
}
