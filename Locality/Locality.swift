//
//  Core.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/21/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit

public class Locality: NSObject {
    let BOSTON = CLLocationCoordinate2D( latitude: 42.36, longitude: -71.062)

    static public var share: Locality!
    
    var routeDict = [String: Route]()
    var handler = Handler()
    var locationService = LocationService()
    
    var map: MapService!
    
    init( map: MapService ) {
        self.map = map
        super.init()

        Locality.share = self
        handler.listener = self
        locationService.listener = self

        //Get routes
        let query = Query(kind: .routes)
        handler.deliver(query: query)
    }
    
    override public var description: String {
        return( "Locality Core Object, v0.1")
    }
    
}
