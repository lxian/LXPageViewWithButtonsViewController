# LXPageViewWithButtonsViewController

[![CI Status](http://img.shields.io/travis/Shell Xian/LXPageViewWithButtonsViewController.svg?style=flat)](https://travis-ci.org/Shell Xian/LXPageViewWithButtonsViewController)
[![Version](https://img.shields.io/cocoapods/v/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![License](https://img.shields.io/cocoapods/l/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![Platform](https://img.shields.io/cocoapods/p/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)

![screenshot](https://github.com/lxian/LXPageViewWithButtonsViewController/blob/master/screenshot.png)

LXPageViewWithButtonsViewController wraps the UIPageViewController and adds a row of page selection buttons on the top. It also provides a lot of customization options of the selection buttons to the user.

It's inspired by [RKSwipeBetweenViewControllers](https://github.com/cwRichardKim/RKSwipeBetweenViewControllers). While RKSwipeBetweenViewControllers fixes the buttons in the navigation bar, LXPageViewWithButtonsViewController chooses to leave the navigation for the user and put the buttons and page view controller inside one view controller.

## Usage
#### Add view controllers. 
Button labels will be set to the corresponding view controller's title
```swift
import LXPageViewWithButtonsViewController // import is needed if it is installed by CocoaPods
...
let pwbVC = LXPageViewWithButtonsViewController()
pwbVC.viewControllers = [dummyViewController0, dummyViewController1, dummyViewController2]
```

#### Customize the appreance
Appreance customization is grouped under `LXPageViewWithButtonsViewController.appreance` property
```swift
let pwbVC = LXPageViewWithButtonsViewController()
pwbVC.viewControllers = [dummyViewController0, dummyViewController1, dummyViewController2]

// Do customization with appreance property
// For more information, please look into LXPageViewWithButtonsViewController.Appreance struct
pwbVC.appreance.buttonsGap = 5
pwbVC.appreance.buttonFontSize = 15
pwbVC.appreance.buttonBackgroundColor = UIColor(white: 0.95, alpha: 1)
```
List of supported customizations
```swift
// Buttons
// button width is calculated by the number of view controllers, screen width, buttonsXOffset and buttonsGap
buttonFontSize
buttonBackgroundColor
buttonTitleColor
buttonTitleSelectedColor
buttonsHeight
buttonsXOffset     // the distance between the screen left(right) border and the buttons group, 
                   // the buttons group is always centered at the screen horizontally 
buttonsGap         // The gap between buttons

// Selection Indicator
// the indicator will be of the same width as the button
selectionIndicatorColor
selectionIndicatorHeight

// Backgournd color of the whole view
viewBackgroundColor
```
For further customizations, users can subclass `LXPageViewWithButtonsViewController` and override `setupButtons` and `setupSelectionIndicator`

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

## Further Work
* Move the buttons group view out. So that users can have the flexibility to put it anywhere they want.
* Change how the button widths are calculated, allow users to set the button width. So that the button group view can be made scrollable and have any number of buttons

## Author

Li Xian, lxian2shell@gmail.com

## License

LXPageViewWithButtonsViewController is available under the MIT license. See the LICENSE file for more info.
