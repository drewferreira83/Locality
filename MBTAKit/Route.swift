//
//  Route.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import UIKit

public class Route: NSObject {
    public enum Mode: Int {
        case unknown = -1

        case lightRail = 0
        case heavyRail = 1
        case commuterRail = 2
        case bus = 3
        case ferry = 4
    }
    
    public static let Unknown = Route()
    
    public struct Attributes: Decodable {
        let color: String
        let description: String
        let direction_names: [String]
        let long_name: String
        let short_name: String
        let sort_order: Int
        let text_color: String
        let type: Int
    }
    
    public let id: String
    public let about: String
    public let type: Mode
    public let shortName: String
    public let longName: String
    public let color: UIColor
    public let textColor: UIColor
    public let directions: [String]
    
    // Full Name is a user readable string that completely declares the route.
    public var fullName: String {
        switch type {
        case .lightRail, .heavyRail:
            return( longName )
        case .bus, .commuterRail, .ferry:
            return( "\(shortName)-\(longName)")
        default:
            return "Invalid Route Type:\(type)"
        }
    }
    
    // Abbreviation is the shortest user readable string to identify this route.
    //  For bus, it is the id
    //  For heavyRail, it is the color, which currently is the ID.
    //  For lightRail, it is the shortName (B,C,D,E), except for Mattapan Trolley
    //  For Ferry, it is the first part of the long name
    //  For CR, it is the outer terminus, which currently is what follows the first "-"
    public var abbreviation: String {
        switch type {
        case .bus, .lightRail:
            if id == "Mattapan" {
                return "Mattapan"
            }
            return shortName
            
        case .heavyRail:
            return id
            
        case .commuterRail:
            if let dashIndex = id.index(of: "-") {
                let afterIndex = id.index(after: dashIndex)
                return String(id[afterIndex...])
            }

            print( ".commuterRail ID not in expected form. \(self)")
            return id

        case .ferry:
            if let index = longName.index(of: " ") {
                return String(longName[..<index])
            }
            print( ".ferry ID not in expected form. \(self)")
            return longName
            
        default:
            return "UNK"
        }
    }
    
    private var _isUnknown = false
    public var isUnknown: Bool {
        return _isUnknown
    }
    
    override private init() {
        id = "UnknownRoute"
        about = "Unknown Route"
        type = Mode.unknown
        shortName = "Route?"
        longName = "Unknown Route"
        color = UIColor.lightGray
        textColor = UIColor.red
        directions = ["Unknown Source", "Unknown Sink"]
        _isUnknown = true
        super.init()
    }
    
    init( source: JXObject ) {
        self.id = source.id
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Route could not get attributes from JXObject. \(source)")
        }
        
        self.about = attributes.description
        self.type = Mode( rawValue: attributes.type ) ?? .unknown
        self.color = UIColor( hex: attributes.color )
        self.textColor = UIColor( hex: attributes.text_color)
        self.shortName = attributes.short_name
        self.longName = attributes.long_name
        self.directions = attributes.direction_names
        
        super.init()
    }
}


extension UIColor {
    convenience init(hex: String) {
        guard let rgb = UInt(hex, radix: 16) else {
            fatalError( "Expected a hex value for a color.  Got \(hex)")
        }
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
