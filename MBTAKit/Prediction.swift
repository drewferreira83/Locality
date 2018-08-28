//
//  Prediction.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/26/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

//
public class Prediction: NSObject {
    
    public struct Attributes: Decodable {
        let arrival_time: String?
        let departure_time: String?
        let direction_id: Int
        let stop_sequence: Int
    }

    public let id: String
    public let dir: Int
    
    // Use this data to create new query if more specific data is needed
    public let routeID: String
    public let stopID: String
    public let tripID: String
    public let vehicleID: String?
    
    public var route: Route!
    public var stop: Stop!
    public var trip: Trip!
    public var vehicle: Vehicle?
    
    public var arrival: Date?
    public var departure: Date?
    
    init( source: JXObject ) {
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Predictions could not extract attributes from JXObject \(source)")
        }

        self.id = source.id
        self.dir = attributes.direction_id
        
        if let datetime = attributes.arrival_time {
            arrival = DateFactory.make(datetime: datetime)
        }
        
        if let datetime = attributes.departure_time {
            departure = DateFactory.make(datetime:datetime)
        }
        
        guard let routeID = source.relatedID( key: "route" ) else {
            fatalError( "Predictions didn't have route data. \(source)")
        }
        self.routeID = routeID
        
        guard let stopID = source.relatedID( key: "stop" ) else {
            fatalError( "Predictions didn't have stop data. \(source)")
        }
        self.stopID = stopID
        
        guard let tripID = source.relatedID( key: "trip" ) else {
            fatalError( "Predictions didn't have trip data. \(source)")
        }
        self.tripID = tripID

        self.vehicleID = source.relatedID(key: "vehicle")
        
        super.init()
        
    }
    override public var description: String {
        return "[PRE:" + route.longName + "(" + route.shortName + "), " + route.directions[dir] + " " + String(describing: departure) + "]"
    }
}
