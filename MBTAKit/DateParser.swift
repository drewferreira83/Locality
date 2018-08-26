//
//  DateParser.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/26/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit

class DateFactory {
    // MBTA sends timestamps in this format: "2018-08-26T12:09:51-04:00",
    static let dateFormatter = ISO8601DateFormatter()
    
    static public func make( datetime: String ) -> Date? {
        return dateFormatter.date(from: datetime)
    }
}
