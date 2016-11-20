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

private func randomDummyViewController(_ count: Int) -> [UIViewController] {
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
        defaultVC.view.backgroundColor = UIColor.lightGray
        
        /// Tabs in the navigation bar
        let tabsInNavbarVC = TabsInNavbarPageViewWithButtonsViewController()
        tabsInNavbarVC.viewControllers = randomDummyViewController(8)
        
        viewControllers = [defaultVC, tabsInNavbarVC]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = titles[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = viewControllers[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class TabsInNavbarPageViewWithButtonsViewController : LXPageViewWithButtonsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsScrollView.appearance.button.height = 44
        buttonsScrollView.frame = CGRect(x: 100, y: 0, width: UIScreen.main.bounds.size.width - 100 , height: 44)
        navigationItem.titleView = buttonsScrollView
        self.edgesForExtendedLayout = .all
    }
    
    override func lx_LayoutViews() {
        let pageViewControllerView = pageViewController.view
        pageViewControllerView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: pageViewControllerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: pageViewControllerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
            ])
    }
}
