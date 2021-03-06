#
# Be sure to run `pod lib lint AMXSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMXSDK'
  s.version          = '0.2.1'
  s.summary          = 'Almulla SDK for Almulla Projects'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"Almulla SDK for Almulla Projects :::"
                       DESC

  s.homepage         = 'https://github.com/Pranjal7163/AMXSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pranjal' => 'pranjal.3vyas@gmail.com' }
  s.source           = { :git => 'https://github.com/Pranjal7163/AMXSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AMXSDK/Classes/**/*'
  s.swift_version = '5.0'
  
  s.static_framework = true
  
  # s.resource_bundles = {
  #   'AMXSDK' => ['AMXSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Firebase'
   s.dependency 'Firebase/Core'
   s.dependency 'Firebase/Messaging'
   s.dependency 'Firebase/Database'
end
