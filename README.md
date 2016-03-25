# LXPageViewWithButtonsViewController

[![CI Status](http://img.shields.io/travis/Shell Xian/LXPageViewWithButtonsViewController.svg?style=flat)](https://travis-ci.org/Shell Xian/LXPageViewWithButtonsViewController)
[![Version](https://img.shields.io/cocoapods/v/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![License](https://img.shields.io/cocoapods/l/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![Platform](https://img.shields.io/cocoapods/p/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)

![screenshot](https://github.com/lxian/LXPageViewWithButtonsViewController/blob/master/screenshot.png)

LXPageViewWithButtonsViewController wraps the UIPageViewController and adds a row of page selection buttons on the top. It also provides a lot of customization options of the selection buttons to the user.

It's inspired by [RKSwipeBetweenViewControllers](https://github.com/cwRichardKim/RKSwipeBetweenViewControllers). While RKSwipeBetweenViewControllers fixes the buttons in the navigation bar, LXPageViewWithButtonsViewController chooses to leave the navigation for the user and put the buttons and page view controller inside one view controller.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LXPageViewWithButtonsViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "LXPageViewWithButtonsViewController"
```
or
```ruby
use_frameworks!
pod 'LXPageViewWithButtonsViewController', :git=> 'https://github.com/lxian/LXPageViewWithButtonsViewController.git'
```

or

If your prefer to not using CocoaPods, you can just add `LXPageViewWithButtonsViewController.swift` and `LXPageViewWithButtonsViewControllerDataSource.swift` to you project


## Author

Li Xian, lxian2shell@gmail.com

## License

LXPageViewWithButtonsViewController is available under the MIT license. See the LICENSE file for more info.
