//
//  Trip.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

public class Trip: NSObject {
    let id: String
    let dir: Int
    let headsign: String
    let accessible: Int
    let routeID: String?
    
    init( id: String, dir: Int, routeID: String?, headsign: String, accessible: Int ) {
        self.id = id
        self.dir = dir
        self.routeID = routeID
        self.headsign = headsign
        self.accessible = accessible
        super.init()
    }
    
    override public var description: String {
        return( "[Trip: id=\(id), dir=\(dir), headsign=\(headsign), accessible=\(accessible)]")
    }
}
