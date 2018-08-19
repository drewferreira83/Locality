//
//  Query.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/18/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

open class Package: CustomStringConvertible {
    static private var counter = 0
    
    public enum Kind: String {
        case stopsByLocation = "Stops by location"
        case stop = "Stop"
        
        case error = "Error"
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
}


class PackageTracker: CustomStringConvertible {
    private var packages = [Package]()
    
    var count: Int {
        return packages.count
    }
    
    var isEmpty: Bool {
        return packages.isEmpty
    }
    
    func track( package: Package ) {
        packages.append( package )
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
        if let index = indexOf(package: package) {
            packages.remove(at: index)
        }
    }
    
    func remove( matchingUrl: URL ) {
        if let index = indexOf(url: matchingUrl) {
            packages.remove(at: index)
        }
    }
    
    func removeAll() {
        packages.removeAll(keepingCapacity: false)
    }
    
    public var description: String {
        return "v3.0"
    }
    
    //  Functions to support array indexing.
    private func indexOf( package: Package ) -> Int? {
        for i in 0..<packages.count {
            if packages[i].url == package.url {
                return i
            }
        }
        return nil
    }
    
    private func indexOf( url: URL ) -> Int? {
        for i in 0..<packages.count {
            if packages[i].url == url {
                return i
            }
        }
        return nil
    }
}
