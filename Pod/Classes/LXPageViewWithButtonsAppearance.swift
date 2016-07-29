//
//  LXPageViewWithButtonsAppearance.swift
//  Pods
//
//  Created by XianLi on 21/7/2016.
//
//

import UIKit

private let DEFAULT_FONT                                = UIFont.systemFontOfSize(14)
private let DEFAULT_FOREGROUND_COLOR                    = UIColor.grayColor()
private let DEFAULT_FOREGROUND_COLOR_SELECTED           = UIColor.redColor()
private let DEFAULT_BACKGROUND_COLOR                    = UIColor.clearColor()
private let DEFAULT_BUTTON_WIDTH:CGFloat                = 70
private let DEFAULT_BUTTON_HEIGHT:CGFloat               = 70
private let DEFAULT_MARGIN                              = UIEdgeInsetsZero
private let DEFAULT_GAP:CGFloat                         = 0
private let DEFAULT_SELECTION_INDICATOR_COLOR           = UIColor.redColor()
private let DEFAULT_SELECTION_INDICATOR_HEIGHT:CGFloat  = 2

extension LXPageViewWithButtonsViewController {
    public struct Appearance {
        /// Buttons
        public struct Button {
            /// single button properties
            public struct Font {
                var normal:UIFont              = DEFAULT_FONT
                var selected:UIFont            = DEFAULT_FONT
            }
            public struct ForegroundColor {
                var normal:UIColor             = DEFAULT_FOREGROUND_COLOR
                var selected:UIColor           = DEFAULT_FOREGROUND_COLOR_SELECTED
            }
            public struct BackgroundColor {
                var normal:UIColor              = DEFAULT_BACKGROUND_COLOR
                var selected:UIColor            = DEFAULT_BACKGROUND_COLOR
            }
            
            public var font:Font                                   = Font()
            public var foregroundColor:ForegroundColor             = ForegroundColor()
            public var backgroundColor:BackgroundColor             = BackgroundColor()
            public var width:CGFloat                               = DEFAULT_BUTTON_WIDTH
            public var height:CGFloat                              = DEFAULT_BUTTON_HEIGHT
            
            /// button group properties
            public var margin : UIEdgeInsets       = DEFAULT_MARGIN
            public var gap : CGFloat               = DEFAULT_GAP
            public var count : Int                 = 0
        }
        public var button = Button()
        
        /// Selection Indicator
        public struct SelectionIndicator {
            public var color:UIColor               = DEFAULT_SELECTION_INDICATOR_COLOR
            public var height:CGFloat              = DEFAULT_SELECTION_INDICATOR_HEIGHT
        }
        public var selectionIndicator = SelectionIndicator()
       
        
        /// whole view
        public var viewBackgroundColor: UIColor = UIColor.whiteColor()
        
        /// frame calculation functions
        func buttonViewSize() -> CGSize {
            let width  = CGFloat(button.count) * button.width + CGFloat(button.count - 1) * button.gap + button.margin.left + button.margin.right
            let height = button.height + button.margin.top + button.margin.bottom
            return CGSizeMake(width, height)
        }
        func buttonFrame(idx: Int) -> CGRect {
            let idx = CGFloat(idx)
            return CGRectMake(button.margin.left + (button.width + button.gap) * idx,
                              button.margin.top,
                              button.width,
                              button.height)
        }
        func selectionIndicatorFrame(idx: Int) -> CGRect {
            let btnframe = buttonFrame(idx)
            return CGRect(x: btnframe.origin.x , y: button.margin.top + button.height - selectionIndicator.height, width: btnframe.size.width, height: selectionIndicator.height)
        }
        
    }
}