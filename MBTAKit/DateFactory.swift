//
//  DateParser.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/26/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

class DateFactory {
    // MBTA sends timestamps in this format: "2018-08-26T12:09:51-04:00",
    static let ISOdateFormatter = ISO8601DateFormatter()
    static let dateFormatter = DateFormatter()
    
    static public func make( datetime: String ) -> Date? {
        return ISOdateFormatter.date(from: datetime)
    }
}

extension String {
    func asDate() -> Date? {
        return DateFactory.ISOdateFormatter.date( from: self )
    }
}

extension Date {
    func minutesFromNow() -> String {
        let interval = timeIntervalSinceNow
        if interval < 0 {
            return( "Past" )
        } else if interval < 60 {
            return "\(Int(interval + 0.5)) sec"
        }
        let minutes = Int( interval / 60 )
        return String( minutes )
    }
}
