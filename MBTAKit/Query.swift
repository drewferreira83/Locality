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

open class Query: Hashable, CustomStringConvertible {
    static private var counter = 0
    
    public var hashValue: Int {
        return id
    }
    
    // Do not confuse with JXObject.Kind
    public enum Kind: String {
        case alert
        case predictions
        case routes
        case schedules
        case stops
        case trips
        case vehicles
        
        case outstanding

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
    
    init( kind: Kind, data: Any? = nil) {
        self.kind = kind
        self.data = data
        self.id = Query.counter
        Query.counter += 1
    }
    
    public var statusDescription: String {
        if let timestamp = received {
            return( "Received \(timestamp)")
        } else if let timestamp = issued {
            return( "Issued \(timestamp)")
        }
        
        return( "Created \(created)")
    }
    
    public var description: String {
        return( "Query[\(kind)] \(statusDescription)")
    }
    
    public var isPending: Bool {
        return received == nil
    }

    // The URL is used to distinguish queries
    static public func == ( lhs: Query, rhs: Query ) -> Bool {
        return lhs.url == rhs.url
    }
    
    static public func != (lhs: Query, rhs: Query) -> Bool {
        return lhs.url != rhs.url
    }
}

class QueryTracker: CustomStringConvertible {
    private var queries = Set<Query>()
    
    var count: Int {
        return queries.count
    }
    
    var isEmpty: Bool {
        return queries.isEmpty
    }
    
    func contains( query: Query ) -> Bool {
        return queries.contains( query )
    }
    
    func track( query: Query ) {
        queries.insert( query )
    }
    
    func find( matchingUrl: URL, andRemove: Bool = false ) -> Query? {
        for query in queries {
            if query.url == matchingUrl {
                if andRemove {
                    remove( query: query )
                }
                return query
            }
        }
        
        return nil
    }
    
    func remove( query: Query ) {
        queries.remove( query)
    }
    
    func removeAll() {
        queries.removeAll(keepingCapacity: false)
    }
    
    public var description: String {
        return "v3.0"
    }
    
    func overdue( since: Date ) {
        // THis will return overdue queries
    }
}
