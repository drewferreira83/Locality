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
    public let id: String
    public let descr: String
    public let type: Int
    public let shortName: String
    public let longName: String
    public let color: UIColor
    public let textColor: UIColor
    public let directions: [String]
    
    init( id: String, attributes: JXRoute.Attributes ) {
        self.id = id
        descr = attributes.description
        type = attributes.type
        color = UIColor( hex: attributes.color )
        textColor = UIColor( hex: attributes.text_color)
        shortName = attributes.short_name
        longName = attributes.long_name
        directions = attributes.direction_names
        
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
