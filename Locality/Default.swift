//
//  Default.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit
import UIKit

public struct Default {
    public struct Map {
        public static let span = MKCoordinateSpanMake( 0.01, 0.01)
        public static let center = CLLocationCoordinate2DMake( 42.36, -71.06 )  // Boston
        public static let region = MKCoordinateRegionMake(Map.center, Map.span)
    }
}

public struct GTFS {
    public enum LocationType: Int {
        case unknown = -1  // Extension
        case stop = 0
        case station = 1
        case entrance = 2
    }
    
    // Wheelchair boarding in GTFS
    public enum Accessibility: Int {
        case unknown = 0
        case accessible = 1
        case notAccessible = 2
    }
    
    public enum VehicleStatus: String {
        case incoming = "INCOMING_AT"
        case stopped = "STOPPED_AT"
        case inTransit = "IN_TRANSIT_TO"
    }
}

