//
//  CustomAnnotation.swift
//  TQuery
//
//  Created by Andrew Ferreira on 12/27/15.
//  Copyright © 2015 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

enum MarkType: String {
    case stop, vehicle
}

open class Mark: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    
    public var stop: Stop?
    //public var vehicle: Vehicle?
    
    var image: UIImage?
    var imageName: String?
    var type: MarkType
    var degrees: Int?
    var forced = false

    init( stop: Stop ) {
        self.coordinate = stop.coordinate
        self.type = .stop
        self.degrees = nil
        self.title = stop.name
        self.subtitle = stop.id
        super.init()
    }

    
    deinit {
        image = nil
    }
    
    override open var description: String {
        return( "(Mark:\(type) \"\(title ?? "No title")\" super[\(super.description)])")
    }
}


//ImageRotation.swift


extension UIImage {
    public func imageRotatedByDegrees(_ degrees: Int, flip: Bool) -> UIImage {
        /*  TODO:  Need to return a COPY
         if degrees == 0 {
         return( UIImage(ciImage: self.ciImage!))
         }
         */
        let rads = CGFloat(degrees) / 180.0 * CGFloat(Double.pi)
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: rads)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap?.rotate(by: rads)
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        bitmap?.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

