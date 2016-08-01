//
//  LXPageViewWithButtonsViewController.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import Foundation
import UIKit

public protocol LXPageViewWithButtonsViewDelegate {
    func pageViewWithButtonsView(pageViewController: UIPageViewController, buttonsScrollView: LXButtonsScrollView, currentIndexUpdated index: Int)
}

public class LXPageViewWithButtonsViewController: UIViewController, UIPageViewControllerDelegate {
    /// delegate
    var pageViewWithButtonsViewDelegate: LXPageViewWithButtonsViewDelegate?
    
    /// page view controller
    public let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    /// the scrollView inside the pageViewController
    private var _pageViewScrollView: UIView?
    var pageViewScrollView : UIView? {
        if _pageViewScrollView == nil {
            var views : [UIView] = [pageViewController.view]
            while views.count > 0 {
                let view = views[0]
                if view.isKindOfClass(UIScrollView) {
                    _pageViewScrollView = view
                    break
                }
                views.appendContentsOf(view.subviews)
                views.removeAtIndex(0)
            }
        }
        return _pageViewScrollView
    }
    /// buttons
    public let buttonsScrollView: LXButtonsScrollView = LXButtonsScrollView()
    /// data source required by UIpageViewController
    let pageViewControllerDataSource = LXPageViewWithButtonsViewControllerDataSource()
    
    /// page index
    var targetIndex: Int?
    var currentIdx = 0 {
        didSet {
            currentIdxUpdated()
        }
    }
    func currentIdxUpdated() {
        buttonsScrollView.buttons.forEach { $0.selected = false }
        buttonsScrollView.buttons[currentIdx].selected = true
        
        /// scroll the scroll view if needed
        /// if the target button is already visible, then no need to scorll the view
        if !(targetIndex != nil && buttonsScrollView.isButtonVisible(targetIndex!)) {
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                self?.scrollButtonsViewToCurrentIndex()
                })
        }
        
        if currentIdx == targetIndex {
            targetIndex = nil
        }
        
        pageViewWithButtonsViewDelegate?.pageViewWithButtonsView(pageViewController, buttonsScrollView: buttonsScrollView, currentIndexUpdated: currentIdx)
    }
    
    public var viewControllers : [UIViewController]? {
        didSet {
            pageViewControllerDataSource.viewControllers = self.viewControllers
        }
    }
    public var currentViewController: UIViewController? {
        return viewControllers?[currentIdx]
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupButtons()
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
        
        lx_LayoutViews()
    }
    
    /// layout buttonsScrollView and page view controller's view 
    /// override this function if you want other layout
    func lx_LayoutViews() {
        /// layout the buttons scroll view
        buttonsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: buttonsScrollView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
            ])
        
        /// layout page view controllers' view
        let pageViewControllerView = pageViewController.view
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: pageViewControllerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Top, relatedBy: .Equal, toItem: buttonsScrollView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
            ])
    }
    
    // MARK: - Setups
    public func setupButtons() {
        guard let viewControllers = viewControllers else { return }
        buttonsScrollView.setButtonTitles( viewControllers.map{ return $0.title ?? "" })
        view.addSubview(buttonsScrollView)
        
        for (idx, btn) in buttonsScrollView.buttons.enumerate() {
            btn.tag = idx
            btn.addTarget(self, action: #selector(LXPageViewWithButtonsViewController.selectionButtonTapped(_:)), forControlEvents: .TouchUpInside)
        }
        
        buttonsScrollView.buttons[currentIdx].selected = true
        buttonsScrollView.selectionIndicator.frame = buttonsScrollView.selectionIndicatorFrame(currentIdx)
    }
    
    public func setupPageViewController() {
        pageViewController.dataSource = pageViewControllerDataSource
        pageViewController.delegate = self
        
        self.view.addSubview(pageViewController.view)
        self.addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        
        pageViewScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext)
    }
    
    var LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext : Int32 = 0
    
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
        var frame = buttonsScrollView.selectionIndicatorFrame(currentIdx)
        guard let pageViewScrollView = pageViewScrollView else { return }
        frame.origin.x += ((offsetX - pageViewScrollView.frame.size.width) / pageViewScrollView.frame.size.width) * buttonsScrollView.appearance.button.width
        buttonsScrollView.selectionIndicator.frame = frame
    }
    
    func scrollButtonsViewToCurrentIndex() {
        let targetRect = buttonsScrollView.calButtonFrame(currentIdx)
        buttonsScrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    // MARK: - Buttons
    public func selectionButtonTapped(btn: UIButton) {
        let idx = btn.tag
        /// set the target index for scrolling buttons view purpose
        targetIndex = idx
        
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
                guard let bself = self else { return }
                /// set the view controllers to be displayed
                bself.pageViewController.setViewControllers([vcs[nextIdx]], direction: dir, animated: true) { (finished) in
                    if finished {
                        bself.currentIdx = nextIdx
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
            guard let bself = self else { return }
            bself.updateSelectionIndicatorPosition(pageViewScrollView.frame.size.width)
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
