#
# Be sure to run `pod lib lint LXPageViewWithButtonsViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LXPageViewWithButtonsViewController"
  s.version          = "0.1.5"
  s.summary          = "combines UIPageViewController and highly customisable page selection tabs"

  s.description      = <<-DESC
                        LXPageViewWithButtonsViewController wraps the UIPageViewController and provides a scrollabel page selections tab buttons. It aims to provide a highly customizable UI component. It allows the user to layout the selection tabs and pageViewController view freely.
                       DESC

  s.homepage         = "https://github.com/lxian/LXPageViewWithButtonsViewController"
  s.screenshots      = "https://raw.githubusercontent.com/lxian/LXPageViewWithButtonsViewController/master/screenshot0.png"
  s.license          = 'MIT'
  s.author           = { "Li Xian" => "lxian2shell@gmail.com" }
  s.source           = { :git => "https://github.com/lxian/LXPageViewWithButtonsViewController.git", :tag => s.version.to_s, :branch => 'swift3' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
