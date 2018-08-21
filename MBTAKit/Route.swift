//
//  Stop.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/17/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

// Wrapper struct to decode JSON returned from a /stops call.
struct RoutesData: Decodable {
    let data: [Route]?
    //let jsonapi: String
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct Route: Decodable {
    public struct Attributes: Decodable {
        public let color: String
        public let description: String
        public let direction_names: [String]
        public let long_name: String
        public let short_name: String
        public let sort_order: Int
        public let text_color: String
        public let type: Int
    }

    public let id: String
    public let attributes: Attributes
    
    enum CodingKeys: CodingKey {
        case id
        case attributes
    }
   
}

