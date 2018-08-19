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
    public func deliver(package: Package) -> Bool {
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
        if listener == nil {
            print( "No one is listening to handler" )
        }
        if let error = error {
            print( "Handler got error \(error.localizedDescription)")
        }
        guard let data = data else {
            print( "No Data in handler?")
            return
        }
        guard let url = response?.url else {
            print( "Can't find response url in handler?" )
            return
        }
        
        let mbtaResult = try! decoder.decode(MBTAResult.self, from: data)
        
        // Look up matching package
        guard let package = activePackages.find(matchingUrl: url, andRemove: true ) else {
            print( "Handler got unexpeected response! \(url)")
            return
        }

        package.received = Date()
        package.response = mbtaResult
        listener?.receive(package: package)
        
        activePackages.remove(package: package)
    }
    
}
