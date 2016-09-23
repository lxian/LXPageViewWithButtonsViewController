//
//  LXButtonsScrollViewAppearance.swift
//  Pods
//
//  Created by XianLi on 21/7/2016.
//
//

import UIKit

private let DEFAULT_FONT                                = UIFont.systemFont(ofSize: 14)
private let DEFAULT_FOREGROUND_COLOR                    = UIColor.gray
private let DEFAULT_FOREGROUND_COLOR_SELECTED           = UIColor.red
private let DEFAULT_BACKGROUND_COLOR                    = UIColor.clear
private let DEFAULT_BUTTON_WIDTH:CGFloat                = 70
private let DEFAULT_BUTTON_HEIGHT:CGFloat               = 30
private let DEFAULT_MARGIN                              = UIEdgeInsets.zero
private let DEFAULT_GAP:CGFloat                         = 0
private let DEFAULT_SELECTION_INDICATOR_COLOR           = UIColor.red
private let DEFAULT_SELECTION_INDICATOR_HEIGHT:CGFloat  = 2

/// The appreance settings of the selection buttons
extension LXButtonsScrollView {
    public struct Appearance {
        /// Buttons
        public struct Button {
            /// single button properties
            public struct Font {
                public var normal:UIFont              = DEFAULT_FONT
                public var selected:UIFont            = DEFAULT_FONT
            }
            public struct ForegroundColor {
                public var normal:UIColor             = DEFAULT_FOREGROUND_COLOR
                public var selected:UIColor           = DEFAULT_FOREGROUND_COLOR_SELECTED
            }
            public struct BackgroundColor {
                public var normal:UIColor              = DEFAULT_BACKGROUND_COLOR
                public var selected:UIColor            = DEFAULT_BACKGROUND_COLOR
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
    }
}
