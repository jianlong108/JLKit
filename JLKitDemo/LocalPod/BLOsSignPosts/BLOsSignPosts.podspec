#
# Be sure to run `pod lib lint BLSwiftUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLOsSignPosts'
  s.version          = '0.0.1'
  s.summary          = 'A short description of BLOsSignPosts.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://git.sysop.bigo.sg/bigolive-ios/BLSwiftUtil'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jianlong Wang' => 'wangjianlong@bigo.sg' }
  s.source           = { :git => 'https://git.sysop.bigo.sg/bigolive-ios/blswiftbase.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.public_header_files = 'BLOsSignPosts/Classes/*.h'
  s.source_files = 'BLOsSignPosts/Classes/*'
end
