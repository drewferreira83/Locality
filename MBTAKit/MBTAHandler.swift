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
    
    var listener: MBTAListener?
    
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
        if let urlString = MURL.makeURL(package: package) {
            guard let url = URL( string: urlString )  else {
                fatalError( "MBTAHandler: Failed to generate legal URL [[[  \(urlString)  ]]]")
            }
            let task = URLSession.shared.dataTask(with: url, completionHandler: handler)
            task.resume()
            return( true )
        }
        
        print( "MURL Error...")
        return false
    }
    
    fileprivate func handler( _ data: Data?, response: URLResponse?, error: Error? ) -> Void {
        if error != nil {
            print("handler got error: \(error!.localizedDescription)")
        } else if data == nil {
            print( "handler got no data")
        } else {
            print( "urlResponse = \(String(describing: response))")
        }
    }
    /*
    // Liason to realtime MBTA server
    fileprivate func issueQuery( _ type: QType, urlString: String,
                                 completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void) -> Int {
        // Abort if we have a malformed URL.
        guard let validURL = URL( string: urlString ) else {
            fatalError("MBTAHandler: Illegal query '\(urlString)'." )
        }
        
        let ticket = QueryTicket( type: type )
        activeQueries[ urlString ] = ticket
        
        qprint( "\(ticket.id)> Sent \(type.rawValue)" )
        
        let task = URLSession.shared.dataTask( with: validURL, completionHandler: completionHandler )
        countOut( urlString )
        enableTimeout()
        task.resume()
        
        return ticket.id
    }
     
    
    // Sample handler
    fileprivate func alertHeadersHandler( _ data: Data?, response: URLResponse?, error: Error? ) -> Void {
        var errorString: String?
        var alertHeaders = [AlertHeader]()
        
        if error != nil {
            errorString = error!.localizedDescription
        } else if data == nil {
            errorString = "Server returned no data for alertHeaders by Route."
        } else {
            let result = genericProcessing(data: data!)
            
            if let parsedDict = result.dictionary {
                if let headerArray = parsedDict[ KEYS.ALERT_HEADERS ] as? NSArray {
                    for item in headerArray {
                        if let headerDict = item as? NSDictionary {
                            let newHeader = AlertHeader(attributes: headerDict)
                            alertHeaders.append(newHeader)
                        }
                    }
                }
            } else {
                errorString = result.error
            }
        }
        
        
        sendPackage( MBTAPackage( name: response?.url?.absoluteString, qType: .AlertHeadersByRoute, data: alertHeaders, error: errorString))
    }
     
     */
    
}
