#
#  Be sure to run `pod spec lint CardKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CardKitCore"
  spec.version      = "0.0.19"
  spec.summary      = "CardKitCore SDK."
  spec.homepage     = "https://github.com/Runet-Business-Systems/CardKit"
  spec.license      = "MIT"
  spec.author       = { "RBS" => "rbssupport@bpc.ru" }
  spec.source       = { :git => "https://github.com/Runet-Business-Systems/CardKit.git" }

  spec.exclude_files = "CardKit/Carthage/*.{h,m}", "CardKit/Carthage/**/**/*.lproj/*.strings"

  spec.source_files = 'CardKit/CardKitCore/*.{h,m}'

  spec.ios.deployment_target  = '10.0'
end
