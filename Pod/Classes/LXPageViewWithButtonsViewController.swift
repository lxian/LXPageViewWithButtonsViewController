//
//  LXPageViewWithButtonsViewController.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import Foundation
import UIKit

public protocol LXPageViewWithButtonsViewDelegate: class {
    func pageViewWithButtonsView(_ pageViewController: UIPageViewController, buttonsScrollView: LXButtonsScrollView, currentIndexUpdated index: Int)
}

open class LXPageViewWithButtonsViewController: UIViewController, UIPageViewControllerDelegate {
    /// delegate
    open weak var pageViewWithButtonsViewDelegate: LXPageViewWithButtonsViewDelegate?
    
    /// page view controller
    open let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    /// the scrollView inside the pageViewController
    fileprivate var _pageViewScrollView: UIView?
    var pageViewScrollView : UIView? {
        if _pageViewScrollView == nil {
            var views : [UIView] = [pageViewController.view]
            while views.count > 0 {
                let view = views[0]
                if view.isKind(of: UIScrollView.self) {
                    _pageViewScrollView = view
                    break
                }
                views.append(contentsOf: view.subviews)
                views.remove(at: 0)
            }
        }
        return _pageViewScrollView
    }
    /// buttons
    open let buttonsScrollView: LXButtonsScrollView = LXButtonsScrollView()
    /// data source required by UIpageViewController
    let pageViewControllerDataSource = LXPageViewWithButtonsViewControllerDataSource()
    
    /// page index
    var targetIndex: Int?
    open var currentIdx = 0 {
        didSet {
            currentIdxUpdated()
        }
    }
    open func currentIdxUpdated() {
        buttonsScrollView.buttons.forEach { $0.isSelected = false }
        buttonsScrollView.buttons[currentIdx].isSelected = true
        
        /// scroll the scroll view if needed
        /// if the target button is already visible, then no need to scorll the view
        if !(targetIndex != nil && buttonsScrollView.isButtonVisible(targetIndex!)) {
            DispatchQueue.main.async(execute: { [weak self] in
                self?.scrollButtonsViewToCurrentIndex()
                })
        }
        
        if currentIdx == targetIndex {
            targetIndex = nil
        }
        
        pageViewWithButtonsViewDelegate?.pageViewWithButtonsView(pageViewController, buttonsScrollView: buttonsScrollView, currentIndexUpdated: currentIdx)
    }
    
    open var viewControllers : [UIViewController]? {
        didSet {
            pageViewControllerDataSource.viewControllers = self.viewControllers
        }
    }
    open var currentViewController: UIViewController? {
        return viewControllers?[currentIdx]
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupButtons()
    }
    
    fileprivate var viewAppearedOnce = false
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewAppearedOnce {
            setupButtons()
            pageViewController.setViewControllers([viewControllers![0]], direction: .forward, animated: false, completion: nil)
            viewAppearedOnce = true
        }
    }
    
    deinit {
        if isViewLoaded {
            pageViewScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        lx_LayoutViews()
    }
    
    /// layout buttonsScrollView and page view controller's view 
    /// override this function if you want other layout
    open func lx_LayoutViews() {
        /// layout the buttons scroll view
        view.addSubview(buttonsScrollView)
        buttonsScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: buttonsScrollView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: buttonsScrollView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
            ])
        
        /// layout page view controllers' view
        let pageViewControllerView = pageViewController.view
        pageViewControllerView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: pageViewControllerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .top, relatedBy: .equal, toItem: buttonsScrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
            ])
    }
    
    // MARK: - Setups
    open func setupButtons() {
        guard let viewControllers = viewControllers else { return }
        buttonsScrollView.setButtonTitles( viewControllers.map{ return $0.title ?? "" })
        
        for (idx, btn) in buttonsScrollView.buttons.enumerated() {
            btn.tag = idx
            btn.addTarget(self, action: #selector(LXPageViewWithButtonsViewController.selectionButtonTapped(_:)), for: .touchUpInside)
        }
        
        buttonsScrollView.buttons[currentIdx].isSelected = true
        buttonsScrollView.selectionIndicator.frame = buttonsScrollView.selectionIndicatorFrame(currentIdx)
    }
    
    open func setupPageViewController() {
        if viewControllers == nil { return }
        
        pageViewController.dataSource = pageViewControllerDataSource
        pageViewController.delegate = self
        
        self.view.addSubview(pageViewController.view)
        self.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext)
    }
    
    var LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext : Int32 = 0
    
    // MARK: - Selection Indicator
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &LXPageViewWithButtonsViewControllerScrollingViewContentOffsetXContext {
            guard let offset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue else {
                return
            }
            updateSelectionIndicatorPosition(offset.x)
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    open func updateSelectionIndicatorPosition(_ offsetX: CGFloat) {
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
    open func selectionButtonTapped(_ btn: UIButton) {
        let idx = btn.tag
        /// set the target index for scrolling buttons view purpose
        targetIndex = idx
        
        guard let vcs = viewControllers , idx >= 0 && idx < vcs.count else {
            return
        }
        
        if idx == currentIdx {
            return
        }
        
        let dir : UIPageViewControllerNavigationDirection = currentIdx < idx ? .forward :  .reverse
        var nextIdx = currentIdx
        while nextIdx != idx  {
            nextIdx  += ((dir == .forward) ? 1 : -1)
            DispatchQueue.main.async(execute: { [weak self, nextIdx, vcs, dir] in
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
    open func setIndex(_ idx: Int) {
        guard let viewControllers = viewControllers else { return }
        
        if idx >= viewControllers.count { return }
        
        self.pageViewController.setViewControllers([viewControllers[idx]], direction: .forward , animated: false, completion: nil)
        currentIdx = idx
        
        guard let pageViewScrollView = pageViewScrollView else { return }
        DispatchQueue.main.async { [weak self] in
            guard let bself = self else { return }
            bself.updateSelectionIndicatorPosition(pageViewScrollView.frame.size.width)
        }
    }
    
    open func reset() {
        setIndex(0)
    }
    
    // MARK: - UIPageViewControllerDelegate
    open func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let curVC = pageViewController.viewControllers?.last,
                let newCurIdx = viewControllers?.index(of: curVC) else { return }
            self.currentIdx = newCurIdx
        }
    }
    
}
