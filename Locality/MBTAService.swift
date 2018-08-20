//
//  MBTAService.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/20/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

public class MBTAService: MBTAListener {
    let BOSTON = CLLocationCoordinate2D( latitude: 42.36, longitude: -71.062)
    static public let share = MBTAService()
    
    public func start() {
        MBTAHandler.share.register(listener: self)
        
        let package = Package(kind: .stops, data: BOSTON )
        MBTAHandler.share.deliver(package: package)
    }
    

    // NEVER ON THE MAIN THREAD!!!!
    public func receive(package: Package) {
        print( "Got a package!")
        switch package.kind {
        case .stops:
            guard let stops = package.response as? [Stop] else {
                print( "/stops returned something unexpected.")
                return
            }
            for stop in stops {
                print( stop.attributes.name)
            }
        default:
            print( "Don't know what to do with package \(package.kind)")
        }
    }
    
}
