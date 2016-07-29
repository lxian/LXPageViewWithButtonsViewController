//
//  LXPageViewWithButtonsAppearance.swift
//  Pods
//
//  Created by XianLi on 21/7/2016.
//
//

import UIKit

extension LXPageViewWithButtonsViewController {
    public struct Appearance {
        // Buttons
        public struct Button {
            public var buttonFontSize              = CGFloat(15)
            public var buttonBackgroundColor       = UIColor.whiteColor()
            public var buttonTitleColor            = UIColor.grayColor()
            public var buttonTitleSelectedColor    = UIColor.redColor()
            public var buttonsHeight               = CGFloat(30)
            public var buttonsXOffset              = CGFloat(50)
            public var buttonsGap                  = CGFloat(0)
            public var buttonWidth                 = CGFloat(0)
            public var buttonsCount : Int = 0 {
                didSet {
                    buttonWidth = (CGRectGetWidth(UIScreen.mainScreen().bounds) - buttonsXOffset * 2 - buttonsGap * CGFloat(buttonsCount - 1)) / CGFloat(buttonsCount)
                }
            }
            
            
        }
        public var button = Button()
        
        
        // Selection Indicator
        public struct SelectionIndicator {
            public var selectionIndicatorColor    = UIColor.redColor()
            public var selectionIndicatorHeight   = CGFloat(2)
        }
        public var selectionIndicator = SelectionIndicator()
       
        
        // whole view
        public var viewBackgroundColor: UIColor = UIColor.whiteColor()
        
        
        // frame calculation functions
        func buttonFrame(idx: Int) -> CGRect {
            return CGRect(x: button.buttonsXOffset + button.buttonWidth * CGFloat(idx) + button.buttonsGap * CGFloat(idx - 1), y: 0, width: button.buttonWidth, height: button.buttonsHeight)
        }
        func selectionIndicatorFrame(idx: Int) -> CGRect {
            let btnframe = buttonFrame(idx)
            return CGRect(x: btnframe.origin.x , y: button.buttonsHeight - selectionIndicator.selectionIndicatorHeight, width: btnframe.size.width, height: selectionIndicator.selectionIndicatorHeight)
        }
        
    }
}