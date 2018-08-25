//
//  Stop.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

// This class is created from data extracted from the MBTA's JSON response.  This is the data that is available to the outside world in a flatter form.
public class Stop: NSObject {
    // REQUIRED
    public let id: String
    public let name: String
    public let coordinate: CLLocationCoordinate2D
    
    // Optional
    public var parentStation: String?
    
    init( id: String, name: String, coordinate: CLLocationCoordinate2D ) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        super.init()
    }
}
