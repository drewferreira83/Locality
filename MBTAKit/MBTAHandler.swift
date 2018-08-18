//
//  MBTAHandler.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

public protocol MBTAListener {
    func receive(package: Package) -> Void
}

open class MBTAHandler: CustomStringConvertible {
   public static let share = MBTAHandler()
    
    private init() {
    
    }
    
    public var description: String {
        return "Version 3.0, August 2018"
    }
    
    public func deliver(package: Package) -> String? {
        switch ( package.kind )
        {
        case .stopsByLocation:
            // Data must be a CLLocation
            if let coordinate = package.data as? CLLocationCoordinate2D {
                print( "Get Stops near \(coordinate)")
                return nil
            }
            return( "Stops By Location requires a CLLocationCoordinate2D")

        case .stop:
            if let stopID = package.data as? String {
                print( "Get Stop \(stopID)")
                return nil
            }
            return("Stop requires a String")
        }
    }
    
    
}
