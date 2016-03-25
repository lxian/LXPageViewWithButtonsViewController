#
# Be sure to run `pod lib lint LXPageViewWithButtonsViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LXPageViewWithButtonsViewController"
  s.version          = "0.0.2"
  s.summary          = "A view controller combines UIPageViewController and page selection buttons"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        This view controller wraps a UIPageViewController and adds a row a page selection buttons at the top. So you can either swipe or tap top buttons to navigate through the view controllers you added to it.
                       DESC

  s.homepage         = "https://github.com/lxian/LXPageViewWithButtonsViewController"
  s.screenshots      = "https://raw.githubusercontent.com/lxian/LXPageViewWithButtonsViewController/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Li Xian" => "lxian2shell@gmail.com" }
  s.source           = { :git => "https://github.com/lxian/LXPageViewWithButtonsViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LXPageViewWithButtonsViewController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
