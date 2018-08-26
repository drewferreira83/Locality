//
//  JXStop.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

// Wrapper struct to decode JSON returned from a /stops call.
struct JXStopsData: Decodable {
    let data: [JXStop]?
    let jsonapi: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case data
        case jsonapi
    }
    
    func export() -> [Stop] {
        var stops = [Stop]()
        
        if let data = data {
            for jxStop in data {
                stops.append( jxStop.export() )
            }
        }

        return stops
    }
}

struct JXStop: Decodable {
    struct Attributes: Decodable {
        public let address: String?
        public let description: String?
        public let latitude: Double
        public let location_type: Int
        public let longitude: Double
        public let name: String
        public let platform_code: String?
        public let platform_name: String?
        public let wheelchair_boarding: Int
    }
    
    struct RelationshipElement: Decodable {
        let data: [String:String]?
    }
    
    struct Relationships: Decodable {
        //let child_stops: RelationshipElement
        //let facilities: RelationshipElement?
        let parent_station: RelationshipElement
    }
    
    enum CodingKeys: CodingKey {
        case id
        case attributes
        case relationships
        case type
    }
    
    let attributes: Attributes
    let id: String
    let relationships: Relationships
    let type: String
    
    func export() -> Stop {
        let coordinate = CLLocationCoordinate2DMake(attributes.latitude, attributes.longitude   )
        let stop = Stop(id: id, name: attributes.name, coordinate: coordinate)
        stop.parentStation = relationships.parent_station.data?[ "id" ]
        
        return stop
    }
   
}

