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

public struct Strings {
    public static let NBSP = "\u{00a0}"
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
        case incoming = "INCOMING_AT"      // Approaching station
        case stopped = "STOPPED_AT"        // At station
        case inTransit = "IN_TRANSIT_TO"   // Departed previous station
        
        case unknown = "unknown"
    }

    // What to display for the previous statuses.
    public static let VehicleStatusDescription = [
        VehicleStatus.incoming.rawValue: "Incoming",
        VehicleStatus.stopped.rawValue: "Stopped at",
        VehicleStatus.inTransit.rawValue: "In Transit to" ]
    
}

