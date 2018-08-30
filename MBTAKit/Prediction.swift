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
        let stop_sequence: Int?
        let status: String?
    }

    public let id: String
    public let dir: Int
    public let status: String?
    
    // Use this data to create new query if more specific data is needed
    public let routeID: String
    public let stopID: String
    public let tripID: String
    public let vehicleID: String?

    // The route, stop, and trip must be created by looking in the included data of the JXTop object
    public var route: Route!
    public var stop: Stop!
    public var trip: Trip!
    public var vehicle: Vehicle?
    
    public var arrival: Date?
    public var departure: Date?
    public var stopSequence: Int
    
    init( source: JXObject, included: [JXObject] ) {
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Predictions could not extract attributes from JXObject \(source)")
        }

        // Data specific to this prediction
        self.id = source.id
        self.dir = attributes.direction_id
        self.stopSequence = attributes.stop_sequence ?? -1
        self.status = attributes.status
        
        // Arrival and departure times.
        // If Arrival is nil, then this is the first stop
        if let datetime = attributes.arrival_time {
            arrival = DateFactory.make(datetime: datetime)
        }
        
        // if Departure is nil, then this is the last stop
        if let datetime = attributes.departure_time {
            departure = DateFactory.make(datetime:datetime)
        }
    
        
        // PREDICTION object MUST include ROUTE STOP and TRIP ids.
        guard let routeID = source.relatedID( key: "route" ) else {
            fatalError( "Prediction didn't have route ID. \(source.id)")
        }
        self.routeID = routeID
        
        guard let stopID = source.relatedID( key: "stop" ) else {
            fatalError( "Prediction didn't have stop ID. \(source.id)")
        }
        self.stopID = stopID
        
        guard let tripID = source.relatedID( key: "trip" ) else {
            fatalError( "Predictions didn't have trip ID. \(source.id)")
        }
        self.tripID = tripID

        // Vehicle ID is not required.
        self.vehicleID = source.relatedID(key: "vehicle")
    
        
        // INCLUDED DATA must include Route Stop and Trip.  May include vehicle.
        // Now create and store Route, Stop, and Trip info
        guard let jxRouteObject = included.search(forKind: .route, id: routeID) else {
            fatalError( "Prediction did not include route data. \(source.id)")
        }
        route = Route( source: jxRouteObject )
        
        guard let jxStopObject = included.search(forKind: .stop, id: stopID) else {
            fatalError( "Prediction did not include stop data. \(source.id)")
        }
        stop = Stop( source: jxStopObject )
        
        guard let jxTripObject = included.search(forKind: .trip, id: tripID) else {
            fatalError( "Prediction did not include stop data. \(source.id)")
        }
        trip = Trip( source: jxTripObject)
        
        // Vehicle is optional?
        if let jxVehicleObject = included.search(forKind: .vehicle, id: vehicleID ) {
            vehicle = Vehicle( source: jxVehicleObject )
        }
        super.init()
        
        if (vehicleID != nil) && (vehicle == nil) {
            print( "Note:  Prediction has vehicleID, but did not include vehicle data. \(self)")
        }
    }
    
    public var vehicleStatus: String {
        return (vehicle?.status ?? "-")
    }
    
    public var predictionStatus: String {
        return( status ?? "x")
    }
    
    public var directionDescription: String {
        return "\(route.directions[dir]) to \(trip.headsign)"
    }
   
    public var timeDescription: String {
        if let departure = departure {
            return departure.minutesFromNow()
        }
        
        if let arrival = arrival {
            return "Arr: \(arrival.minutesFromNow())"
        }
        
        return "No Info!"
    }
    
    override public var description: String {
         return "[PRE:\(route.displayName) \(directionDescription)" +
               "\n   \(timeDescription) \(predictionStatus) \(vehicleStatus)]"
    }
}
