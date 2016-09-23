//
//  LXPageViewWithButtonsViewControllerDataSource.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import UIKit

open class LXPageViewWithButtonsViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    var viewControllers: [UIViewController]?
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = viewControllers, let idx = viewControllers.index(of: viewController)
            , idx > 0 else {
            return nil
        }
        return viewControllers[idx-1]
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = viewControllers, let idx = viewControllers.index(of: viewController)
            , idx < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[idx+1]
    }
}
