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
    public let type: Int
    public let shortName: String
    public let longName: String
    public let color: UIColor
    public let textColor: UIColor
    public let directions: [String]
    
    init( source: JXObject ) {
        self.id = source.id
        guard let attributes = source.attributes as? Attributes else {
            fatalError( "Route could not get attributes from JXObject. \(source)")
        }
        
        self.about = attributes.description
        self.type = attributes.type
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
