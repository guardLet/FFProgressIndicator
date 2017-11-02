//
//  FFProgressCircleView.swift
//  FFProgressBar
//
//  Created by Ujwal on 8/24/17.
//  Copyright © 2017 Fastfox. All rights reserved.
//

import UIKit

class FFProgressCircleView: UIView, FFProgressCircleState {

    /// Diameter of the circle calculated on the basis of the screen frame.
    var viewDiameter: CGFloat {
        return self.frame.size.height
    }
    
    ///Circle can be of three typed based on the wizard completion state.
    ///Completed, Current and Initial
    public enum CircleType: Int {
        
        case Completed, Current, Initial
        
        ///Line color when the line is drawn
        var strokeColor: UIColor {
            switch self {
            case .Initial: return UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 0.4)
            case .Current,.Completed: return UIColor.white
            }
        }
        
        ///Circle fill color when the circle is drawn
        var fillColor: UIColor {
            switch self {
            case .Initial,.Current: return UIColor.clear
            case .Completed: return UIColor.white
            }
        }
    }
    
    ///It defines the type of the circle that is to be displayed to the user upfront. Default being initial state.
    private var circleType: CircleType = .Initial {
        didSet {
            //If circleType changes,the circle needs to be re-drawn and that's what setneedsDisplay func would do.
            setNeedsDisplay()
        }
    }
    
    /** Circle State is specified after which the circleType is set which in term re draws the circle according to the mentioned circle type.
     - Parameter type: circle type is provided. i.e Current, Completed or Initial
     - Remark: If the type mentioned is same as the stored circle type then the circle re draw would not take place.
     */
    public func setCircleState(type: CircleType = .Initial) {
        //This is to avoid re drawing the same circle again and again.
        guard circleType != type else { return }
        circleType = type
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        //Creating outer circle with the background color as white for completed state and clear for the rest of the states.
        let path = UIBezierPath(arcCenter: outerCircleCenterPoint, radius: outerCircleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleType.fillColor.setFill()
        path.lineWidth = outerCircleStrokeWidth
        circleType.strokeColor.setStroke()
        path.fill()
        path.stroke()
        
        //Iff the circle type is current we draw the inner circle else we would not require it.
        guard circleType == .Current else { return }
        
        //Creating inner circle with the radius lesser than the radius of the outer circle.
        let circlePath = UIBezierPath(arcCenter: outerCircleCenterPoint, radius: innerCircleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        UIColor.white.setFill()
        circlePath.fill()
    }
    
    
    /// Fading animation for the view with given time interval.
    ///
    /// - Parameter duration: time interval for which the animation needs to be performed.
    
    public func fadeAnim(duration: TimeInterval = 0.5) {
        // Create a CATransition animation
        let fadeTransition = CATransition()
        
        // Customize the animation's properties
        fadeTransition.type = kCATransitionFade
        fadeTransition.subtype = kCATransitionFromLeft
        fadeTransition.duration = duration
        fadeTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fadeTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(fadeTransition, forKey: "fadeTransition")
    }
}
