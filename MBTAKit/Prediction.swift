//
//  Prediction.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/26/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

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
    public var route = Route.Unknown
    
    public var stop = Stop.Unknown
    public var trip = Trip.Unknown
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

        // Fill in the Stop, Trip, Route and Vehicle from the included data (if it exists).
        // TripID is invalid for Green Line Trains east of Park.
        // Some shuttles or unscheduled trips don't have all of this data.
        if let jxStopData = included.search(forKind: .stop, id: stopID) {
            stop = Stop( source: jxStopData )
        } else {
            print( "Unknown Stop '\(stopID)' for prediction \(id)")
        }
        if let jxTripData = included.search(forKind: .trip, id: tripID) {
            trip = Trip( source: jxTripData )
        } else {
            print( "Unknown Trip '\(tripID)' for prediction \(id)" )
        }
        if let jxRouteData = included.search( forKind: .route, id: routeID ) {
            route = Route( source: jxRouteData )
        } else {
            print( "Unknown Route '\(routeID)' for prediciton \(id)" )
        }
        // Vehicle is optional?
        if let jxVehicleObject = included.search(forKind: .vehicle, id: vehicleID ) {
            vehicle = Vehicle( source: jxVehicleObject )
        }

        super.init()
        
        if (vehicleID != nil) && (vehicle == nil) {
            // Haven't encountered this...
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
        if route.isUnknown {
            // Haven't encountered this situation
            return ""
        }

        var toDescription: String = ""
        
        if trip.isUnknown {
            // For Green Line trains east of Park, the tripID is invalid.
            switch (route.id) {
            case "Green-B":
                toDescription = " towards Boston College"
            case "Green-C":
                toDescription = " towards Cleveland Circle"
            case "Green-D":
                toDescription = " towards Riverside"
            case "Green-E":
                toDescription = " towards Heath St"
            default:
                break
            }
        } else {
            toDescription = " to \(trip.headsign)"
        }
        
        return route.directions[dir] + toDescription
    }
   
    public var timeDescription: String {
        if let status = status {
            return status
        }
        
        if let departure = departure {
            return departure.minutesFromNow()
        }
        
        if let arrival = arrival {
            return "Arr: \(arrival.minutesFromNow())"
        }
        
        return "No Info!"
    }
    
    override public var description: String {
         return "[PRE:\(route.fullName) \(directionDescription)" +
               "\n   \(timeDescription) \(predictionStatus) \(vehicleStatus)]"
    }
}
