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
    struct Attributes: Decodable {
        let bearing: Int?
        let current_status: String
        let current_stop_sequence: Int?
        let direction_id: Int?
        let label: String?
        let latitude: Double
        let longitude: Double
        let speed: Double?
        let updated_at: String?
    }
    
    public let id: String
    public let coordinate: CLLocationCoordinate2D

    public var directionID: Int?
    public var bearing: Int?
    public var status: String?
    public var speed: Double?
    public var stopSequence: Int?
    public var updated: Date?
    
    public var routeID: String?
    public var stopID: String?
    public var tripID: String?
    
    public var route: Route?
    public var stop: Stop?
    public var trip: Trip?
    
    
    init( source: JXObject ) {
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Vehicle couldn't interpret attributes. \(source)")
        }
        
        self.id = source.id
        self.coordinate = CLLocationCoordinate2DMake(attributes.latitude, attributes.longitude)
        self.directionID = attributes.direction_id
        self.bearing = attributes.bearing
        self.status = attributes.current_status
        self.stopSequence = attributes.current_stop_sequence
        if let datetime = attributes.updated_at {
            self.updated = DateFactory.make(datetime: datetime)
        }
        
        self.routeID = source.relatedID(key: "route")
        self.stopID = source.relatedID(key: "stop")
        self.tripID = source.relatedID(key: "trip")
        
        super.init()
    }
}
