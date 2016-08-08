//
//  DemosTableViewController.swift
//  LXPageViewWithButtonsViewController
//
//  Created by XianLi on 1/8/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import LXPageViewWithButtonsViewController

private func randomColor() -> UIColor {
    let v = [0, 0, 0].map { (_) -> CGFloat in
        return CGFloat(arc4random_uniform(255)) / 255.0
    }
    return UIColor.init(red: v[0], green: v[1], blue: v[2], alpha: 1)
}

private func randomDummyViewController(count: Int) -> [UIViewController] {
    return (0..<count).map({ (idx) -> UIViewController in
            let vc = UIViewController()
            vc.title = "Page \(String(idx))"
            vc.view.backgroundColor = randomColor()
            let label = UILabel()
            label.text = vc.title
            label.sizeToFit()
            vc.view.addSubview(label)
            return vc
        })
}

class DemosTableViewController: UITableViewController {
    var titles: [String] = []
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titles = [
            "Default (Tabs at the top)",
            "Tabs in the navigation bar"
        ]
        
        /// Default (Tabs at the top)
        let defaultVC = LXPageViewWithButtonsViewController()
        defaultVC.viewControllers = randomDummyViewController(8)
        defaultVC.view.backgroundColor = UIColor.lightGrayColor()
        
        /// Tabs in the navigation bar
        let tabsInNavbarVC = TabsInNavbarPageViewWithButtonsViewController()
        tabsInNavbarVC.viewControllers = randomDummyViewController(8)
        
        viewControllers = [defaultVC, tabsInNavbarVC]
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = viewControllers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class TabsInNavbarPageViewWithButtonsViewController : LXPageViewWithButtonsViewController {
    override func viewDidLoad() {
        buttonsScrollView.appearance.button.height = 44
        buttonsScrollView.frame = CGRectMake(100, 0, UIScreen.mainScreen().bounds.size.width - 100 , 44)
        navigationItem.titleView = buttonsScrollView
        super.viewDidLoad()
    }
    
    override func lx_LayoutViews() {
        let pageViewControllerView = pageViewController.view
        pageViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)
            ])
    }
}
