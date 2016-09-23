//
//  LXButtonsScrollView.swift
//  Pods
//
//  Created by XianLi on 29/7/2016.
//
//

import UIKit

open class LXButtonsScrollView: UIScrollView {
    /// config global appearce settings via LXButtonsScrollView.appreance
    open static var appearance:Appearance = Appearance()
    /// local appearance settings
    open var appearance:Appearance = LXButtonsScrollView.appearance
    
    open var selectionIndicator: UIView
    open var buttons: [UIButton]
    fileprivate var buttonTitles: [String]
    
    override public init(frame: CGRect) {
        buttons = []
        buttonTitles = []
        selectionIndicator = UIView()
        super.init(frame: frame)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator   = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// setup buttons with a list of button titles
    /// expected to be executed on the main thread
    open func setButtonTitles(_ titles: [String]) {
        buttonTitles = titles
        
        /// remove (if) any previous added buttons
        buttons.forEach { $0.removeFromSuperview() }
        
        /// create buttons
        buttons = titles.map { (title) -> UIButton in
            let attrTitle = NSAttributedString.init(string: title,
                attributes: [
                    NSFontAttributeName: appearance.button.font.normal,
                    NSForegroundColorAttributeName: appearance.button.foregroundColor.normal
                ])
            let attrTitleSelected = NSAttributedString.init(string: title,
                attributes: [
                    NSFontAttributeName: appearance.button.font.selected,
                    NSForegroundColorAttributeName: appearance.button.foregroundColor.selected
                ])
            let btn = UIButton()
            btn.titleLabel?.textAlignment = .center
            btn.setAttributedTitle(attrTitle, for: UIControlState())
            btn.setAttributedTitle(attrTitleSelected, for: .selected)
            return btn
        }
        
        /// set up size and frames
        appearance.button.count = titles.count
        self.contentSize = calContentSize()
        for (idx, btn) in buttons.enumerated() {
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.frame = calButtonFrame(idx)
        }
        
        /// add buttons to view
        buttons.forEach { self.addSubview($0) }
        
        /// selection indicator
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = true
        selectionIndicator.backgroundColor = appearance.selectionIndicator.color
        self.addSubview(selectionIndicator)
        self.bringSubview(toFront: selectionIndicator)
    }
    
    /// frame calculation functions
    open func calContentSize() -> CGSize {
        let width  = CGFloat(appearance.button.count) * appearance.button.width + CGFloat(appearance.button.count - 1) * appearance.button.gap + appearance.button.margin.left + appearance.button.margin.right
        let height = appearance.button.height + appearance.button.margin.top + appearance.button.margin.bottom
        return CGSize(width: width, height: height)
    }
    
    open func calButtonFrame(_ idx: Int) -> CGRect {
        let idx = CGFloat(idx)
        return CGRect(x: appearance.button.margin.left + (appearance.button.width + appearance.button.gap) * idx,
                          y: appearance.button.margin.top,
                          width: appearance.button.width,
                          height: appearance.button.height)
    }
    open func selectionIndicatorFrame(_ idx: Int) -> CGRect {
        let btnframe = calButtonFrame(idx)
        return CGRect(x: btnframe.origin.x , y: appearance.button.margin.top + appearance.button.height - appearance.selectionIndicator.height, width: btnframe.size.width, height: appearance.selectionIndicator.height)
    }
    
    /// visibility checking function
    open func isButtonVisible(_ idx: Int) -> Bool {
        let btnFrame = calButtonFrame(idx)
        return self.bounds.minX <= btnFrame.minX &&
                self.bounds.maxX >= btnFrame.maxX &&
                self.bounds.minY <= btnFrame.minY &&
                self.bounds.maxY >= btnFrame.maxY
    }
}
