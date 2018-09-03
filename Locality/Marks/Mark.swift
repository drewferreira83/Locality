//
//  CustomAnnotation.swift
//  TQuery
//
//  Created by Andrew Ferreira on 12/27/15.
//  Copyright © 2015 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit


open class Mark: NSObject, MKAnnotation {
    enum Kind: String {
        case stop, vehicle, all
    }

    public let coordinate: CLLocationCoordinate2D
    public let title: String?
    public let subtitle: String?
    
    public let stop: Stop?
    public let vehicle: Vehicle?
    
    var image: UIImage?
    var kind: Kind
    var rotation: Int = 0

    init( stop: Stop ) {
        self.coordinate = stop.coordinate
        self.kind = .stop
        self.title = stop.name
        self.subtitle = stop.id
        self.stop = stop
        self.vehicle = nil
        
        super.init()
    }

    init( vehicle: Vehicle ) {
        self.coordinate = vehicle.coordinate
        self.kind = .vehicle
        self.title = vehicle.id
        self.subtitle = vehicle.status
        self.vehicle = vehicle
        self.rotation = vehicle.bearing ?? 0
        self.stop = nil

        super.init()
        
    }
    
    deinit {
        image = nil
    }
    
    override open var description: String {
        return( "(Mark:\(kind) \"\(title ?? "No title")\" super[\(super.description)])")
    }
}


//ImageRotation.swift


extension UIImage {
    public func rotate(byDegrees: Int, flip: Bool = false) -> UIImage {
        /*  TODO:  Need to return a COPY
         if degrees == 0 {
         return( UIImage(ciImage: self.ciImage!))
         }
         */
        
        if byDegrees == 0 {
            return self
        }
        
        let rads = CGFloat(byDegrees) / 180.0 * CGFloat(Double.pi)
        
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

