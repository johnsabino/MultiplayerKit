#
# Be sure to run `pod lib lint MultiplayerKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MultiplayerKit'
  s.version          = '0.1.2'
  s.summary          = 'A framework to improve Multiplayer Games development in iOS.'
  s.swift_version = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Framework that facilitates Multiplayer Games development in iOS Devices.
                       DESC

  s.homepage         = 'https://github.com/jonhpol/MultiplayerKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jonhpol' => 'j.paulo_os@hotmail.com' }
  s.source           = { :git => 'https://github.com/jonhpol/MultiplayerKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MultiplayerKit/**/*'
  s.exclude_files = "MultiplayerKit/*.plist"
  # s.resource_bundles = {
  #   'MultiplayerKit' => ['MultiplayerKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
