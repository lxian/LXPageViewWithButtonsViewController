//
//  LXPageViewWithButtonsViewController.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import Foundation
import UIKit

let LXPageViewWithButtonsViewControllerCurrentViewControllerDidChangeNotification = "LXPageViewWithButtonsViewControllerCurrentViewControllerDidChangeNotification"

public class LXPageViewWithButtonsViewController: UIViewController, UIPageViewControllerDelegate {
    // appearance configs
    // global appearance
    public static var appearance = Appearance()
    // copy global appearance settings as the inial setting
    public var appearance: Appearance = LXPageViewWithButtonsViewController.appearance
    
    
    // page view controller
    public let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    var pageViewScrollView : UIView?
    let pageViewControllerDataSource = LXPageViewWithButtonsViewControllerDataSource()
    var currentIdx = 0 {
        didSet {
            currentIdxUpdated()
        }
    }
    func currentIdxUpdated() {
        self.selectionButtons?.forEach { $0.selected = false }
        self.selectionButtons?[currentIdx].selected = true
        
        NSNotificationCenter.defaultCenter().postNotificationName(LXPageViewWithButtonsViewControllerCurrentViewControllerDidChangeNotification , object: self)
    }
    
    public var viewControllers : [UIViewController]? {
        didSet {
            pageViewControllerDataSource.viewControllers = self.viewControllers
            setupButtons()
        }
    }
    public var currentViewController: UIViewController? {
        return viewControllers?[currentIdx]
    }
    
    internal var selectionButtons : [UIButton]?
    internal let selectionButtonsContainerView = UIView()
    internal let selectionIndicatorView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = appearance.viewBackgroundColor
        
        setupPageViewController()
    }
    
    private var viewAppearedOnce = false
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !viewAppearedOnce {
            pageViewController.setViewControllers([viewControllers![0]], direction: .Forward, animated: false, completion: nil)
            viewAppearedOnce = true
        }
    }
    
    deinit {
        pageViewScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectionButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        let pageViewControllerView = pageViewController.view
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: selectionButtonsContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: appearance.button.buttonsHeight),
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
    public func setupButtons() {
        self.view.addSubview(selectionButtonsContainerView)
        
        guard let vcs = self.viewControllers else { return }
        
        appearance.button.buttonsCount = vcs.count
        
        self.selectionButtons = [UIButton]()
        for (idx, vc) in vcs.enumerate() {
            let btn = UIButton(frame: appearance.buttonFrame(idx))
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.setTitle(vc.title, forState: .Normal)
            btn.setTitleColor(appearance.button.buttonTitleColor, forState: .Normal)
            btn.setTitleColor(appearance.button.buttonTitleSelectedColor, forState: .Selected)
            btn.backgroundColor = appearance.button.buttonBackgroundColor
            btn.titleLabel?.font = UIFont.init(name: "SFUIText-Semibold", size: appearance.button.buttonFontSize)
            btn.titleLabel?.textAlignment = .Center
            
            btn.tag = idx
            btn.addTarget(self, action: #selector(LXPageViewWithButtonsViewController.selectionButtonTapped(_:)), forControlEvents: .TouchUpInside)
            
            self.selectionButtons?.append(btn)
            self.selectionButtonsContainerView.addSubview(btn)
        }
        self.selectionButtons?[currentIdx].selected = true
        
        setupSelectionIndicator()
    }
    
    public func setupPageViewController() {
        pageViewController.dataSource = pageViewControllerDataSource
        pageViewController.delegate = self
        
        self.view.addSubview(pageViewController.view)
        self.addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
    }
    
    var LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext : Int32 = 0
    
    public func setupSelectionIndicator() {
        selectionIndicatorView.translatesAutoresizingMaskIntoConstraints = true
        selectionIndicatorView.backgroundColor = appearance.selectionIndicator.selectionIndicatorColor
        selectionIndicatorView.frame = appearance.selectionIndicatorFrame(currentIdx)
        selectionButtonsContainerView.addSubview(selectionIndicatorView)
        selectionButtonsContainerView.bringSubviewToFront(selectionIndicatorView)
        
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
    
    public func updateSelectionIndicatorPosition(offsetX: CGFloat) {
        var frame = appearance.selectionIndicatorFrame(currentIdx)
        guard let pageViewScrollView = pageViewScrollView else { return }
        frame.origin.x += ((offsetX - pageViewScrollView.frame.size.width) / pageViewScrollView.frame.size.width) * appearance.button.buttonWidth
        selectionIndicatorView.frame = frame
    }
    
    // MARK: - Buttons
    public func selectionButtonTapped(btn: UIButton) {
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
                guard let wself = self else { return }
                wself.pageViewController.setViewControllers([vcs[nextIdx]], direction: dir, animated: true) { (finished) in
                    if finished {
                        wself.currentIdx = nextIdx
                    }
                }
                })
        }
    }
    
    // MARK: - Controls
    public func setIndex(idx: Int) {
        guard let viewControllers = viewControllers else { return }
        
        if idx >= viewControllers.count { return }
        
        self.pageViewController.setViewControllers([viewControllers[idx]], direction: .Forward , animated: false, completion: nil)
        currentIdx = idx
        
        guard let pageViewScrollView = pageViewScrollView else { return }
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let wself = self else { return }
            wself.updateSelectionIndicatorPosition(pageViewScrollView.frame.size.width)
        }
    }
    
    public func reset() {
        setIndex(0)
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
