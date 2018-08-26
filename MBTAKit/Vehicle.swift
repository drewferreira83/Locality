//
//  Vehicle.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

public class Vehicle: NSObject {
    public let id: String
    public let coordinate: CLLocationCoordinate2D

    public var directionID: Int?
    public var bearing: Int?
    public var status: String?
    public var speed: Double?
    
    public var routeID: String?
    public var stopID: String?
    public var tripID: String?
    
    init( id: String, coordinate: CLLocationCoordinate2D ) {
        self.id = id
        self.coordinate = coordinate
        super.init()
    }
}
