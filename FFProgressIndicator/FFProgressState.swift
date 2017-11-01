//
//  FFProgressState.swift
//  FFProgressBar
//
//  Created by Ujwal on 8/24/17.
//  Copyright © 2017 Fastfox. All rights reserved.
//

import Foundation

import CoreGraphics

protocol FFProgressIndicatorState {
    
    var viewWidth:CGFloat { get }
    var viewHeight: CGFloat { get }
    var totalCircles: CGFloat { get set }
}

extension FFProgressIndicatorState where Self: FFProgressBarView {
    
    
    /// Outer circle radius.
    var outerCircleRadius: CGFloat {
        return viewHeight
    }
    
    /// Circle Diameter.
    var circleDiameter: CGFloat {
        return viewHeight
    }
    
    
    /// Line Height. Defaults to 1
    var lineHeight: CGFloat {
        return 1
    }
    
    /// Total number of lines for the view. Calculated as number of circles - 1
    var totalLines: CGFloat {
        return totalCircles - 1
    }
    
    ///Width of the line
    var lineWidth: CGFloat {
        return (viewWidth -  (circleDiameter * totalCircles)) / totalLines
    }
    
    
    /// Tag multiplier used to add unique tag to the lines.
    var lineTagMultiplier: Int {
        return 100
    }
}


protocol FFProgressCircleState {
    
    var viewDiameter: CGFloat { get }
}

extension FFProgressCircleState where Self: FFProgressCircleView {
    
    ///To decide the start angle of the arc which here is 0
    var startAngle: CGFloat {
        return 0
    }
    
    ///π -> Generated using alt + p. Now apple supports unicode as variables.
    var π: CGFloat {
        return CGFloat(Double.pi)
    }
    
    ///To decide the end angle of the arc which is 2π as we need a complete circle
    var endAngle: CGFloat {
        return 2*π
    }
    
    ///Border radius of the circle. Defaults to 1
    var outerCircleStrokeWidth: CGFloat {
        return 1
    }
    
    
    /// Radius of the outer circle.
    var outerCircleRadius: CGFloat {
        return viewDiameter/2 - outerCircleStrokeWidth/2
    }
    
    
    /// Outer Circle Point
    var outerCircleCenterPoint: CGPoint {
        return CGPoint(x: viewDiameter/2, y: viewDiameter/2)
    }
    
    
    /// Inner circle point
    var innerCircleDiameterFactor: CGFloat {
        return  0.70
    }
    
    ///Diameter of the inner circle calculated on the basic of outerCircleDiameter and viewWidthFactor
    var innerCircleDiameter: CGFloat {
        return viewDiameter * innerCircleDiameterFactor
    }
    
    
    /// Inner circle radius.
    var innerCircleRadius: CGFloat {
        return innerCircleDiameter/2 - outerCircleStrokeWidth/2
    }
    
}


protocol FFProgressLineState {
    var viewWidth: CGFloat { get }
    var viewHeight: CGFloat { get }
    var currentSubSection: Int { get set }
    var totalSubSections: Int { get set }
}

extension FFProgressLineState where Self: FFProgressLineView {
    
    /// Width of the line calculated on the basis of total subsections and the total width assigned to the view.
    var lineWidth: CGFloat {
        return viewWidth/CGFloat(totalSubSections)
    }
}
