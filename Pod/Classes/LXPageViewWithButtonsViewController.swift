//
//  LXPageViewWithButtonsViewController.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import Foundation
import UIKit

public class LXPageViewWithButtonsViewController: UIViewController, UIPageViewControllerDelegate {
    // Appreance settings
    public struct Appreance {
        
        // Buttons
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
        func buttonFrame(idx: Int) -> CGRect {
            return CGRect(x: buttonsXOffset + buttonWidth * CGFloat(idx) + buttonsGap * CGFloat(idx - 1), y: 0, width: buttonWidth, height: buttonsHeight)
        }
        
        // Selection Indicator
        public var selectionIndicatorColor    = UIColor.redColor()
        public var selectionIndicatorHeight   = CGFloat(2)
        public func selectionIndicatorFrame(idx: Int) -> CGRect {
            return CGRect(x: buttonsXOffset + buttonWidth * CGFloat(idx) + buttonsGap * CGFloat(idx - 1), y: buttonsHeight - selectionIndicatorHeight, width: buttonWidth, height: selectionIndicatorHeight)
        }
        
        // whole view
        public var viewBackgroundColor: UIColor = UIColor.whiteColor()
    }
    public var appreance = Appreance()
    
    // page view controller
    internal let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    internal var pageViewScrollView : UIView?
    internal let pageViewControllerDataSource = LXPageViewWithButtonsViewControllerDataSource()
    internal var currentIdx = 0 {
        didSet {
            self.selectionButtons?.forEach { $0.selected = false }
            self.selectionButtons?[currentIdx].selected = true
        }
    }
    public var viewControllers : [UIViewController]? {
        didSet {
            pageViewControllerDataSource.viewControllers = self.viewControllers
        }
    }
    
    // selection buttons
    internal var selectionButtons : [UIButton]?
    internal let selectionButtonsContainerView = UIView()
    internal let selectionIndicatorView = UIView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appreance.viewBackgroundColor
        
        setupPageViewController()
        setupButtons()
    }
    
    deinit {
        pageViewScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectionButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        let pageViewControllerView = pageViewController.view
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        // layout buttons view
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: appreance.buttonsHeight),
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
            ])
        
        // layout pageViewController
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: pageViewControllerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Top, relatedBy: .Equal, toItem: selectionButtonsContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
            ])
    }
    
    // MARK: - Setups
    
    func setupButtons() {
        self.view.addSubview(selectionButtonsContainerView)
        
        guard let vcs = self.viewControllers else { return }
        
        appreance.buttonsCount = vcs.count
        
        self.selectionButtons = [UIButton]()
        for (idx, vc) in vcs.enumerate() {
            let btn = UIButton(frame: appreance.buttonFrame(idx))
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.setTitle(vc.title, forState: .Normal)
            btn.setTitleColor(appreance.buttonTitleColor, forState: .Normal)
            btn.setTitleColor(appreance.buttonTitleSelectedColor, forState: .Selected)
            btn.backgroundColor = appreance.buttonBackgroundColor
            btn.titleLabel?.font = UIFont.systemFontOfSize(appreance.buttonFontSize)
            btn.titleLabel?.textAlignment = .Center
            
            btn.tag = idx
            btn.addTarget(self, action: #selector(LXPageViewWithButtonsViewController.selectionButtonTapped(_:)), forControlEvents: .TouchUpInside)
            
            self.selectionButtons?.append(btn)
            self.selectionButtonsContainerView.addSubview(btn)
        }
        self.selectionButtons?[currentIdx].selected = true
        
        setupSelectionIndicator()
    }
    
    func setupPageViewController() {
        pageViewController.dataSource = pageViewControllerDataSource
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers![0]], direction: .Forward, animated: false, completion: nil)
        
        self.view.addSubview(pageViewController.view)
        self.addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
    }
    
    var LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext : Int32 = 0
    
    func setupSelectionIndicator() {
        selectionIndicatorView.translatesAutoresizingMaskIntoConstraints = true
        selectionIndicatorView.backgroundColor = appreance.selectionIndicatorColor
        selectionIndicatorView.frame = appreance.selectionIndicatorFrame(currentIdx)
        selectionButtonsContainerView.addSubview(selectionIndicatorView)
        selectionButtonsContainerView.bringSubviewToFront(selectionButtonsContainerView)
        
        var views : [UIView] = [pageViewController.view]
        while views.count > 0 {
            let view = views[0]
            if view.isKindOfClass(UIScrollView) {
                self.pageViewScrollView = view
                break
            }
            views.appendContentsOf(view.subviews)
            views.removeAtIndex(0)
        }
        pageViewScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext)
    }
    
    // MARK: - Selection Indicator
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext {
            guard let offset = change?[NSKeyValueChangeNewKey]?.CGPointValue else {
                return
            }
            updateSelectionIndicatorPosition(offset.x)
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    func updateSelectionIndicatorPosition(offsetX: CGFloat) {
        var frame = appreance.selectionIndicatorFrame(currentIdx)
        guard let pageViewScrollView = pageViewScrollView else { return }
        frame.origin.x += ((offsetX - pageViewScrollView.frame.size.width) / pageViewScrollView.frame.size.width) * appreance.buttonWidth
        selectionIndicatorView.frame = frame
    }
    
    // MARK: - Buttons
    func selectionButtonTapped(btn: UIButton) {
        let idx = btn.tag
        guard let vcs = viewControllers where idx >= 0 && idx < vcs.count else {
            return
        }
        
        if idx == currentIdx {
            return
        }
        
        let dir : UIPageViewControllerNavigationDirection = currentIdx < idx ? .Forward :  .Reverse
        var nextIdx = currentIdx
        while nextIdx != idx  {
            nextIdx  += ((dir == .Forward) ? 1 : -1)
            dispatch_async(dispatch_get_main_queue(), { [weak self, nextIdx, vcs, dir] in
                self?.pageViewController.setViewControllers([vcs[nextIdx]], direction: dir, animated: true) { (finished) in
                    if finished {
                        self?.currentIdx = nextIdx
                    }
                }
            })
        }
    }
    
    // MARK: - UIPageViewControllerDelegate
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let curVC = pageViewController.viewControllers?.last,
                    let newCurIdx = viewControllers?.indexOf(curVC) else { return }
            self.currentIdx = newCurIdx
        }
    }

}
