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
    
    func randomColor() -> UIColor {
        let v = [0, 0, 0].map { (_) -> CGFloat in
            return CGFloat(arc4random_uniform(255)) / 255.0
        }
        return UIColor.init(red: v[0], green: v[1], blue: v[2], alpha: 1)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let pwbVC = LXPageViewWithButtonsViewController()
        
        // Add view controllers to LXPageViewWithButtonsViewController
        // view controller's title will be used as the button's title
        let vcArr = (0...8).map({ (idx) -> UIViewController in
            let vc = UIViewController()
            vc.title = "Page \(String(idx))"
            vc.view.backgroundColor = randomColor()
            let label = UILabel()
            label.text = vc.title
            label.sizeToFit()
            vc.view.addSubview(label)
            return vc
        })
        pwbVC.viewControllers = vcArr
        
        // Do customization with appreance property
        // For more information, please look into LXPageViewWithButtonsViewController.Appreance struct
        pwbVC.buttonsScrollView.appearance.button.width = 70
        
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

