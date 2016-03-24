//
//  LXPageViewWithButtonsViewControllerDataSource.swift
//
//  Created by XianLi on 23/3/2016.
//  Copyright © 2016 LXIAN. All rights reserved.
//

import UIKit

public class LXPageViewWithButtonsViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
    var viewControllers: [UIViewController]?
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = viewControllers, let idx = viewControllers.indexOf(viewController)
            where idx > 0 else {
            return nil
        }
        return viewControllers[idx-1]
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = viewControllers, let idx = viewControllers.indexOf(viewController)
            where idx < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[idx+1]
    }
}
