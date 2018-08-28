//
//  JXStruct.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/27/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation


// To help with readability...
typealias StringDictionary = [String:String]

struct JXDataBlock: Decodable {
    let data: StringDictionary
}

typealias Relationships = [String: JXDataBlock]

struct JXTop: Decodable {
    let jsonapi: StringDictionary?
    let data: [JXObject]?
    let included: [JXObject]?
    let links: StringDictionary?
    let errors: JXError?
    
    func search( forKind: JXObject.Kind, id: String ) -> JXObject? {
        if included == nil {
            return nil
        }
        
        for element in included! {
            if element.kind == forKind && element.id == id {
                return element
            }
        }
        
        return nil
    }
}

class JXObject: Decodable {
    class AttrTrip: Decodable {
        let block_id: String
        let direction_id: Int
        let headsign: String
        let name: String
        let wheelchair_accessible: Int
    }
    
    class AttrVehicle: Decodable {
        let bearing: Int?
        let current_status: String
        let current_stop_sequence: Int?
        let direction_id: Int
        let latitude: Double
        let longitude: Double
        let speed: Double?
        // let updated_at: Date
    }
    
    
    enum Kind: String {
        case route, stop, trip, vehicle, prediction
        // case schedule, service, shape
    }
    
    enum Keys: String, CodingKey {
        case attributes
        case id
        case type
        case links
        case relationships
    }
    
    let id:String
    let kind: Kind
    let links: StringDictionary?
    let relationships: Relationships?
    let attributes: Any?
    

    required init(from decoder: Decoder ) throws {
        let container = try decoder.container(keyedBy: JXObject.Keys.self)
        
        let typeString : String = try! container.decode(String.self, forKey: .type)
        guard let kind = Kind(rawValue: typeString) else {
            fatalError( "Unsupported JXObject of kind: \(typeString)")
        }
        
        self.kind = kind
        self.id = try! container.decode(String.self, forKey: .id)
        self.links = try? container.decode(StringDictionary.self, forKey: .links)
        self.relationships = try? container.decode(Relationships.self, forKey: .relationships)
        
        switch kind {
        case .route:
            attributes = try? container.decode(Route.Attributes.self, forKey: .attributes)
        case .trip:
            attributes = try? container.decode( AttrTrip.self, forKey: .attributes)
        case .stop:
            attributes = try? container.decode( Stop.Attributes.self, forKey: .attributes)
        case .vehicle:
            attributes = try? container.decode(AttrVehicle.self, forKey: .attributes )
        case .prediction:
            attributes = try? container.decode(Prediction.Attributes.self, forKey: .attributes )
            /*
        case .schedule:
            attributes = try? container.decode( JXSchedule.Attributes.self, forKey: .attributes )
             */
        }
    }


}
    

    

