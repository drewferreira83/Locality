//
//  Stop.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

// Wrapper struct to decode JSON returned from a /stops call.
struct StopsData: Decodable {
    let data: [Stop]?
    //let jsonapi: String
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct Stop: Decodable {
    public struct Attributes: Decodable {
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
    
    // CURRENTLY IGNORED
    public struct Relationships: Decodable {
        public let child_stops: [Stop]?
        public let facilities: [String:String]
        public let parent_station: [String:String?]
    }
    
    enum CodingKeys: CodingKey {
        case id
        case attributes
        case type
    }
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    //public let relationships: Relationships

    // Full name is retained in attributes.name
    public var shortName: String {
        var workingString = attributes.name
        
        for word in Stop.abbrevs.keys {
            if let replacement = Stop.abbrevs[ word ] {
                workingString = workingString.replacingOccurrences( of: word, with: replacement )
            }
        }
        
        return workingString
    }
    
    // These strings occur in stop names.  Abbreviate the name to display accoring to these pairs.
    fileprivate static let abbrevs: [String: String] = [
        "Commonwealth": "Comm",                 // Generally shorter is better
        "Massachusetts": "Mass",
        "before Manulife Building": "Inbound",  // Silver line
        "after Manulife Building": "Outbound",  // Silver Line
        " - Outbound": "",                      // Some stations make the distinction (Ashmont)
        " - Inbound": "",
        " - to Ashmont/Braintree": "",
        " - to Alewife": "",
        " (Limited Stops)": "",
        "JFK/UMASS Ashmont": "JFK/UMASS",
        "JFK/UMASS Braintree": "JFK/UMASS",
        ", Boston": ""                          // Ferry terminals.  Don't remove ", Hull" because that's important info.
    ]
    
}

