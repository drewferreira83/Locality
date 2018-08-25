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
    
    init( id: String, dir: Int, headsign: String, accessible: Int ) {
        self.id = id
        self.dir = dir
        self.headsign = headsign
        self.accessible = accessible
        super.init()
    }
}
