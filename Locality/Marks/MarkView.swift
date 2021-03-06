//
//  CustomAnnotationView.swift
//  GoBOS
//
//  Created by Andrew Ferreira on 5/5/16.
//  Copyright © 2016 Andrew Ferreira. All rights reserved.
//

import UIKit
import MapKit

// These objects may be reused by the mapViewController.  When the underlying customAnnotation is updated, the image of the 
// view will be updated to correct type and rotation (if applicable)
class MarkView: MKAnnotationView {
    static let Identifier = "MarkView"
    let routeLabel = UILabel()

    var mark: Mark? {
        return annotation as? Mark
    }
    
    init( mark: Mark ) {
        super.init(annotation: mark, reuseIdentifier: MarkView.Identifier)
        
        isOpaque = false
        canShowCallout = true
        
        
        // Make an info button and place it on the right side of the callout bubble.
        //let infoButton = UIButton(type: .infoLight)
        //rightCalloutAccessoryView = infoButton
        routeLabel.font = .preferredFont(forTextStyle: .caption1)
        routeLabel.text = "Getting routes..."
        routeLabel.numberOfLines = 0
        routeLabel.lineBreakMode = .byWordWrapping
        let minWidthConstraint = NSLayoutConstraint(item: routeLabel,
                                                    attribute: .width,
                                                    relatedBy: .greaterThanOrEqual,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 180)
        routeLabel.addConstraint(minWidthConstraint)
        
        detailCalloutAccessoryView = routeLabel
        updateImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("MarkView.init(coder:) has not been implemented")
    }
    
    override public var description: String {
        return( "[MarkView: isEnabled=\(isEnabled);isDraggable:\(isDraggable);super:\(super.description)]" )
    }
    
    func updateImage() {
        // Probably won't happen, and it's not a bad thing if it does.  Just ignore it.
        guard let mark = mark else {
            print( "Annotation not a Mark: \(String(describing: annotation))")
            return
        }
        
        var newImage : UIImage!
        
        switch (mark.kind) {
        case .stop:
            newImage = (mark.stop!.locationType == .station) ? #imageLiteral(resourceName: "station") : #imageLiteral(resourceName: "stop")
            
        case .vehicle:
            newImage = #imageLiteral(resourceName: "chevron")
            newImage = newImage.rotate( byDegrees: mark.rotation)
        default:
            break
        }
        self.image = newImage
    }
    
    open func dismiss() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }


    /*  // For custom annotation
     // DOESN'T WORK WITH VEHICLES?!?!?!
     // Not sure why I overrode thse functions in first place.  Might
     // have been following someone else's code example.  
     
     override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil) {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    // Responsible for all touches on the custom annotation.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        if (!isInside) {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if (isInside) {
                    print( "Is inside \(self)" )
                    return true
                }
            }
        }
        
        if isInside {
            print( "tap is inside \(self)" )
        }
        return isInside
    }
*/

/*
    // Handle selection and deselection.  
    // This function is called by MKMapView and should not be called directly- call MKMapView.selectAnnotation()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            // This is now the open annotationView.
            Core.id.current.openAV = self
        } else {
            // This annoView is to be deselected.  Update the Core if it thinks this av is still open.
            if ( Core.id.current.openAV == self ) {
                Core.id.current.openAV = nil
            }
        }
    }
  */

}
