#
#  Be sure to run `pod spec lint CardKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CardKit"
  spec.version      = "0.0.21"
  spec.summary      = "CardKit SDK."
  spec.homepage     = "https://github.com/Radarpayments/ios-sdk"
  spec.license      = "MIT"
  spec.author       = { "RBS" => "rbssupport2@bpcbt.com" }
  spec.source       = { :git => "https://github.com/Radarpayments/ios-sdk.git" }

  spec.resources =  "CardKit/banks-info", "CardKit/**/*.lproj/*.strings", "CardKit/CardKit/Images.xcassets"

  spec.exclude_files = "CardKit/Carthage/*.{h,m}", "CardKit/Carthage/**/**/*.lproj/*.strings"
  spec.source_files = 'CardKit/CardKit/*.{h,m}'

  spec.subspec 'CardKitCore' do |subspec|
    subspec.exclude_files = 'CardKit/CardKitCore/CardKitCore.{h,m}'
    subspec.source_files = 'CardKit/CardKitCore/*.{h,m}'
  end

  spec.subspec 'CardKitPayment' do |subspec|
    subspec.exclude_files = 'CardKit/CardKitPayment/CardKitPayment.{h,m}'
    subspec.source_files = 'CardKit/CardKitPayment/*.{h,m,swift}'
  end
  
  spec.ios.deployment_target  = '10.0'
end
