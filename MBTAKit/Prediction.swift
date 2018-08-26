//
//  Prediction.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/26/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

public class Prediction: NSObject {
    public let id: String
    public let dir: Int
    public let routeID: String
    public let stopID: String
    public let tripID: String
    
    public var arrival: Date?
    public var departure: Date?
    
    init( id: String, dir: Int, routeID: String, stopID: String, tripID: String ) {
        self.id = id
        self.dir = dir
        self.routeID = routeID
        self.stopID = stopID
        self.tripID = tripID
    
        super.init()
    }
    
    override public var description: String {
        return( "[Prediction: \(id),\(dir),\(routeID),\(stopID),\(tripID)" )
    }
}
