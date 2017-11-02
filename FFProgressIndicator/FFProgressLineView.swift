//
//  FFProgressLineView.swift
//  FFProgressBar
//
//  Created by Ujwal on 8/24/17.
//  Copyright © 2017 Fastfox. All rights reserved.
//

import UIKit

public class FFProgressLineView: UIView, FFProgressLineState {

    ///This is the current sub section that has been filled. Once this property is set, animation of the line starts by calling the draw line function.
    /// Defaults to 0
    var currentSubSection: Int = 0 {
        didSet {
            drawLine()
        }
    }
    
    /// Storing the previous sub section to draw the line starting from the previous subsection to the current sub section.
    /// Default value = 0
    private var previousSubSection = 0
    
    /// Animation duration to draw the line.
    var animationDuration = 0.5
    
    ///View Width: calculated from the assigned frame
    var viewWidth: CGFloat {
        return self.frame.size.width
    }
    
    ///View Height: calculated from the assigned frame.
    var viewHeight: CGFloat {
        return self.frame.size.height
    }
    
    ///Providing total number of subsection for a section.
    /// Defaults to 5
    var totalSubSections: Int = 5
    
    
    
    /** Current subsection and previous sub section is provided to draw a line from the previous sub section to the current one.
     - Parameters:
     - section: Provide the current sub section.
     - previousSubSection: provide the previous sub section.
     */
    public func setCurrent(subSection section: Int, previousSubSection: Int) {
        self.previousSubSection = previousSubSection
        currentSubSection = section
    }
    
    
    
    /// This method draws a line above the view from previous sub section to the current sub section.
    /// Line width is calculated based on the number of sub sections to the total width assigned to the sub section.
    private func drawLine() {
        
        let path = UIBezierPath()
        let origin = CGPoint(x: lineWidth * CGFloat(previousSubSection), y: 0)
        let addLinePoint = CGPoint(x: lineWidth * CGFloat(currentSubSection), y: origin.y)
        path.move(to: origin)
        path.addLine(to: addLinePoint)
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = viewHeight
        shapeLayer.miterLimit = 0.5
        shapeLayer.path = path.cgPath
        
        // animate it
        self.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = animationDuration
        shapeLayer.add(animation, forKey: "strokeAnimation")
        
    }
}
