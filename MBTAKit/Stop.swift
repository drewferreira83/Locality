//
//  Stop.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

// This class is created from data extracted from the MBTA's JSON response.
// This is the data that is available to the outside world in a flatter form.
public class Stop: NSObject {
    public static let Unknown = Stop()
    
    public struct Attributes: Decodable {
        let address: String?
        let description: String?
        let latitude: Double
        let location_type: Int
        let longitude: Double
        let name: String
        let platform_code: String?
        let platform_name: String?
        let wheelchair_boarding: Int
    }
    
    // REQUIRED
    public let id: String
    public let name: String
    public let coordinate: CLLocationCoordinate2D
    
    public let address: String?
    public let descr: String?
    public let locationType: Int
    public let platformCode: String?
    public let platformName: String?
    
    fileprivate var _isUnknown = false
    public var isUnknown: Bool {
        return _isUnknown
    }
    
    // Optional
    public var parentID: String?
    //public var parentStop: Stop?
    
    override private init() {
        id = "stop.unknown"
        name = "Unknown Stop"
        coordinate = Default.Map.center
        locationType = -1
        address = nil
        descr = "Unknown Stop"
        platformCode = nil
        platformName = nil
        parentID = nil
        _isUnknown = true
        super.init()
    }
    
    init( source: JXObject ) {
        self.id = source.id
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Stop could not get attributes from JXObject. \(source)")
        }
        
        self.name = attributes.name
        self.coordinate = CLLocationCoordinate2DMake(attributes.latitude, attributes.longitude)
        self.parentID = source.relatedID(key: "parent_station")
        
        // Optional Detailed Information
        self.address = attributes.address
        self.descr = attributes.description
        self.locationType = attributes.location_type
        self.platformCode = attributes.platform_code
        self.platformName = attributes.platform_name
        
        
        super.init()
    }

}
