//
//  Query.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/18/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation


public class Package: CustomStringConvertible {
    public enum Kind: String {
        case stopsByLocation = "Stops by location"
        case stop = "Stop"
    }
    
    public let kind: Kind
    public let data: Any?
    
    init( kind: Kind, data: Any?) {
        self.kind = kind
        self.data = data
    }
    
    public var description: String {
        return( "Package: \(kind)")
    }
}
