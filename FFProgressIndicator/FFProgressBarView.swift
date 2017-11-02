//
//  FFProgressBarView.swift
//  FFProgressBar
//
//  Created by Ujwal on 8/24/17.
//  Copyright © 2017 Fastfox. All rights reserved.
//

import UIKit

public class FFProgressBarView: UIView, FFProgressIndicatorState {
    
    /// Total circles required in the view. Default value is set to 5 circles
    public var totalCircles: CGFloat = 5
    
    
    
    /// Subsections for the sections in the form of array. Number of elements should always be one less than the total circle count.
    /// Default value for the subsection is [5,5,5,5]
    public var subSections = [5,5,5,5]
    
    
    /// Since the user can create views with storyboard, and simulator screen size can be different than the device screen size. Hence we need to re layout the view to adjust according to the screen size. So in this case we have drawn the progress view after the controller has finished loading its views.
    override public func layoutSubviews() {
        super.layoutSubviews()
        createView()
    }
    /// Width of the view extracted from the frame set by user.
    var viewWidth: CGFloat {
        return self.frame.size.width
    }
    
    
    /// Height of the view extracted from the frame set by user.
    var viewHeight: CGFloat {
        return self.frame.size.height
    }
    
    
    /// Animation time for which fading of circle would occur
    var circleFadeAnimationDuration: TimeInterval = 0.5
    
    ///Time after which the animation of circle should start once the last line segment of the section has began drawing.
    var circleFadeAfterDuration: TimeInterval = 0.5
    
    ///Animation duration for which the line segment should animate
    var lineAnimationDuration: TimeInterval = 0.5
    
    
    /// Storing the state i.e **section** and **subsection** of the user to be used for the progress animation and flow.
    /// Default value being (section: 1, subsection: 0)
    private var previousState:(section: Int, subSection: Int) = (1,0)
    
    
    /// Creates all the subviews based on the total circles and lines provided by the user.
    private func createView() {
        
        var originX:CGFloat = 0
        let circles = Int(totalCircles)
        
        assert(subSections.count + 1 == circles, "Number of Elements in sub section array must always be one less than the total circle count")
        
        //We need to create circles and lines based on the requirement
        for i in 1...circles {
            //add circle
            createCircle(originX: originX, index: i)
            originX += circleDiameter
            
            if i != circles {
                //add line
                createLine(originX: originX, index: i)
                originX += lineWidth
            }
        }
    }
    
    
    /** Draws circle with provided origin, diamete. diameter is taken to be same as that of the progress view height.
     
     - Parameters:
     - originX: current position from where the view needs to be created.
     - index: current index to add tag to the circle view.
     - Remark:
     1. Circle view tag is added based on current index
     2. Example: lineView with current index = 1 will have tag = 1
     */
    private func createCircle(originX: CGFloat, index: Int) {
        let circleFrame = CGRect(x: originX, y: 0, width: circleDiameter, height: circleDiameter)
        let circularView = FFProgressCircleView(frame: circleFrame)
        circularView.tag = index
        circularView.backgroundColor = UIColor.clear
        self.addSubview(circularView)
    }
    
    
    /** Draws line with provided origin, width and height. height is taken to be 1 by default whereas width is calculated on the basis of number of circles present
     
     - Parameters:
     - originX: current position from where the view needs to be created.
     - index: current index to add tag to the line view.
     - Remark:
     1. Line view tag is added based on current index times **lineTagMultiplier** which has a default value of 100.
     2. Example: lineView with current index = 1 will have tag = 1 * 100 = 100
     */
    
    private func createLine(originX: CGFloat, index: Int) {
        let lineFrame = CGRect(x: originX, y: viewHeight/2 - lineHeight/2, width: lineWidth, height: lineHeight)
        let lineView = FFProgressLineView(frame: lineFrame)
        lineView.totalSubSections = subSections[index - 1]
        lineView.tag = index * lineTagMultiplier
        lineView.backgroundColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 0.4)
        self.addSubview(lineView)
    }
    
    
    
    
    /** This method takes in current section and subsection and accordingly animates the progress view to the current position.
     
     - Parameters:
     - section: current section of the screen
     - subSection: current subsection of the section.
     
     - Notes:
     1. Progress view will animate the view from previous state to current state.
     2. Previous state is stored to avoid animation from the start
     3. Line View and Circle View are identified based on the tag they carry.
     4. Line Views have tags in multiplicative factor of lineTagMultiplier with current index.
     5. Circle Views have tags equal to current index.
     6. Circle fade animation is performed after circleFadeAnimationDuration is complete.
     */
    
    public func currentState(section: Int, subSection: Int) {
        
        //previously stored section should always be less than or equal to the current section. It cannot be greater than the current section.
        assert(section >= previousState.section, "Modifying previous section is not allowed. Its a one way Progress Indicator.")
        
        //Running loop from previous state to current state section both inclusive
        for index in previousState.section...section {
            
            //Fetching line view based on the tag of the view.
            if let lineView = viewWithTag(index * lineTagMultiplier) as? FFProgressLineView {
                
                /*
                 Completed state of a line view depends upon current section and previous stored section.
                 
                 There are few situations here.
                 1. if the current section is same as the current index then we set the subsection to current subsection. i.e. this situation comes when the user has same previous and current section hence we set the current subsection to the setCompleted subsection.
                 2. If the current section is not same as the current index then we set the subsection to the maximum value of the subsection provided in the form of array by the user. i.e this situation arises when the user moves from one section to the other.
                 
                 */
                
                lineView.setCurrent(subSection:index == section ? subSection: subSections[index - 1], previousSubSection: index == previousState.section ? previousState.subSection : 0)
                lineView.animationDuration = lineAnimationDuration
            }
            
            //Fetching circle View based on the tag of the view.
            if let circleView = self.viewWithTag(index) as? FFProgressCircleView {
                
                //Previous section data is stored separately as the value of previousState.section was getting affected due to the usage of DispatchQueue.
                let previousSection = previousState.section
                
                DispatchQueue.main.asyncAfter(deadline: .now() + circleFadeAfterDuration) {
                    //If the previous section was not changed, only the subsection changed then we need not animate the circle view.
                    if previousSection != section  {
                        circleView.fadeAnim(duration: self.circleFadeAnimationDuration)
                    }
                    //If the current section is same as the index then we set the current section to be of type current and all the previous section would be set as type completed.
                    circleView.setCircleState(type: index == section ? .Current : .Completed)
                }
            }
        }
        //Storing the current state of the user for the future usage.
        previousState = (section,subSection)
    }
}
