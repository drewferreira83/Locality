//
//  Default.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/25/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation
import MapKit
import UIKit

public struct Default {
    public struct Map {
        public static let span = MKCoordinateSpanMake( 0.005, 0.005)
        public static let center = CLLocationCoordinate2DMake( 42.36, -71.06 )  // Boston
        public static let region = MKCoordinateRegionMake(Map.center, Map.span)
    }

}
