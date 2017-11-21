#
# Be sure to run `pod lib lint GMSimplePlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GMSimplePlayer'
  s.version          = '1.1.3'
  s.summary          = 'GMSimplePlayer is a simple and customizable player.'
  s.description      = 'GMSimplePlayer is a simple and customizable player. You can customize via code or interface builder Its icons, colors, labels, fonts, etc.' 
  s.homepage         = 'https://github.com/GastonMontes/GMSimplePlayer'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Gaston Montes' => 'gastonmontes@hotmail.com' }
  s.source           = { :git => 'https://github.com/GastonMontes/GMSimplePlayer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ElgatitoMontes'
  s.ios.deployment_target = '10.0'
  s.source_files = 'GMSimplePlayer/Classes/**/*'
  s.resource_bundles = { 'GMSimplePlayer' => ['GMSimplePlayer/Assets/Assets.xcassets'] }
  s.dependency 'Kingfisher', '~> 4.1.1'
end
