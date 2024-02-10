#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_scan_v2.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_scan_v2'
  s.version          = '0.0.1'
  s.summary          = 'QR & other code scanner'
  s.description      = <<-DESC
QR & other code scanner
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.ios.platform = :ios, '11.0'
  s.ios.dependency 'Flutter'
  s.ios.deployment_target = '11.0'

  s.osx.platform = :osx, '10.15'
  s.osx.dependency 'FlutterMacOS'
  s.osx.deployment_target = '10.15'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
