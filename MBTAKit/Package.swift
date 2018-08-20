//
//  Query.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/18/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

/*
 *  .stops
 *    DATA:
 *      String, Stop ID.
 *      CLLocationCoordinate
 *    Returns: Array of Stops
 *
 *  .
 
 */

open class Package: Hashable, CustomStringConvertible {
    static private var counter = 0
    
    public var hashValue: Int {
        return id
    }
    
    public enum Kind: String {
        case alert
        case predictions
        case schedules
        case stops
        case trips
        case vehicles

        case error
    }
    
    public let kind: Kind
    public let data: Any?
    public var response: Any?
    
    public var url: URL? = nil
    public var id: Int = -1
    
    public var created: Date = Date()
    public var issued: Date?
    public var received: Date?
    
    init( kind: Kind, data: Any?) {
        self.kind = kind
        self.data = data
        self.id = Package.counter
        Package.counter += 1
    }
    
    public var description: String {
        return( "Package: \(kind)")
    }

    // The URL is used to distinguish packages
    static public func == ( lhs: Package, rhs: Package ) -> Bool {
        return lhs.url == rhs.url
    }
    
    static public func != (lhs: Package, rhs: Package) -> Bool {
        return lhs.url != rhs.url
    }
}

class PackageTracker: CustomStringConvertible {
    private var packages = Set<Package>()
    
    var count: Int {
        return packages.count
    }
    
    var isEmpty: Bool {
        return packages.isEmpty
    }
    
    func contains( package: Package ) -> Bool {
        return packages.contains( package)
    }
    
    func track( package: Package ) {
        packages.insert(package )
    }
    
    func find( matchingUrl: URL, andRemove: Bool = false ) -> Package? {
        for package in packages {
            if package.url == matchingUrl {
                if andRemove {
                    remove( package: package )
                }
                return package
            }
        }
        
        return nil
    }
    
    func remove( package: Package ) {
        packages.remove( package)
    }
    
    func removeAll() {
        packages.removeAll(keepingCapacity: false)
    }
    
    public var description: String {
        return "v3.0"
    }
}
