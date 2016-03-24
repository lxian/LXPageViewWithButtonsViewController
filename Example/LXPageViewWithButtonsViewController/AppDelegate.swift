//
//  AppDelegate.swift
//  LXPageViewWithButtonsViewController
//
//  Created by Shell Xian on 03/24/2016.
//  Copyright (c) 2016 Shell Xian. All rights reserved.
//

import UIKit
import LXPageViewWithButtonsViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let page0VC = UIViewController()
        page0VC.title = "Page 0"
        page0VC.view.backgroundColor = UIColor.grayColor()
        
        let page1VC = UIViewController()
        page1VC.title = "Page 1"
        page1VC.view.backgroundColor = UIColor.yellowColor()
        
        let page2VC = UIViewController()
        page2VC.title = "Page 2"
        page2VC.view.backgroundColor = UIColor.cyanColor()
        
        let page3VC = UIViewController()
        page3VC.title = "Page 3"
        page3VC.view.backgroundColor = UIColor.redColor()
        
        let pwbVC = LXPageViewWithButtonsViewController()
        
        // Add view controllers to LXPageViewWithButtonsViewController
        // view controller's title will be used as the button's title
        pwbVC.viewControllers = [page0VC, page1VC, page2VC, page3VC]
        
        // Do customization with appreance property
        // For more information, please look into LXPageViewWithButtonsViewController.Appreance struct
        pwbVC.appreance.buttonsGap = 5
        pwbVC.appreance.buttonFontSize = 15
        pwbVC.appreance.buttonBackgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.window?.makeKeyWindow()
        self.window?.rootViewController = UINavigationController(rootViewController: pwbVC)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

