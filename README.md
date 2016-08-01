# LXPageViewWithButtonsViewController

[![CI Status](http://img.shields.io/travis/Shell Xian/LXPageViewWithButtonsViewController.svg?style=flat)](https://travis-ci.org/Shell Xian/LXPageViewWithButtonsViewController)
[![Version](https://img.shields.io/cocoapods/v/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![License](https://img.shields.io/cocoapods/l/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)
[![Platform](https://img.shields.io/cocoapods/p/LXPageViewWithButtonsViewController.svg?style=flat)](http://cocoapods.org/pods/LXPageViewWithButtonsViewController)

<img src="https://github.com/lxian/LXPageViewWithButtonsViewController/blob/master/screenshot0.png" width="300">
<img src="https://github.com/lxian/LXPageViewWithButtonsViewController/blob/master/screenshot1.png" width="300">

LXPageViewWithButtonsViewController wraps the UIPageViewController and provides a scrollabel page selections buttons. It aims to provide a highly customizable UI component. 

It's inspired by [RKSwipeBetweenViewControllers](https://github.com/cwRichardKim/RKSwipeBetweenViewControllers). While RKSwipeBetweenViewControllers fixes the buttons in the navigation bar, LXPageViewWithButtonsViewController allows you to put the selections buttons anywhere you like.

## Usage
#### Add view controllers. 
Button labels will be set to the corresponding view controller's title
```swift
import LXPageViewWithButtonsViewController // import is needed if it is installed by CocoaPods
...
let pwbVC = LXPageViewWithButtonsViewController()
pwbVC.viewControllers = [someViewController0, someViewController1, someViewController2]
```

#### Customize the appreance
Appreance customization is grouped under `LXButtonsScrollView.appearance` property
```swift
/// set appreance globally
LXButtonsScrollView.appearance.button.foregroundColor.normal = UIColor.Presets.TapLightGray.color
LXButtonsScrollView.appearance.button.foregroundColor.selected = UIColor.Presets.TextBlack.color
LXButtonsScrollView.appearance.selectionIndicator.color = UIColor.Presets.TextBlack.color

/// set appearance for a particular view controller
let pwbVC = LXPageViewWithButtonsViewController()
pwbVC.buttonsScrollView.appearance.button.width = 70
pwbVC.buttonsScrollView.appearance.button.height = 40
```
List of supported customizations could be found in `LXButtonsScrollViewAppearance.swift`
```swift
  appearance.button.font.normal
  appearance.button.font.selected
  appearance.button.foregroundColor.normal
  appearance.button.foregroundColor.selected
  appearance.button.backgroundColor.normal
  appearance.button.backgroundColor.selected
  appearance.button.width
  appearance.button.height
  appearance.button.margin
  appearance.button.gap
  appearance.selectionIndicator.color
  appearance.selectionIndicator.height
```
For further customizations, buttons are accessable via `LXButtonsScrollViewAppearance.buttonsScrollView.buttons`.

#### The position of the selection buttons
By default, the selection buttons are positioned at the top of the page view controller. You can change the layout by override `LXPageViewWithButtonsViewController.lx_LayoutViews`
```swift
override func lx_LayoutViews() {
  /// do layout you want here
  /// the container view for selection buttons can be accessed by self.buttonsScrollView
  /// the view for the page view controller is self.pageViewController.view
}
```

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

## Author

Li Xian, lxian2shell@gmail.com

## License

LXPageViewWithButtonsViewController is available under the MIT license. See the LICENSE file for more info.
