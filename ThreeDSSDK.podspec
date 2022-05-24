Pod::Spec.new do |spec|
  spec.name = "ThreeDSSDK"
  spec.version = "0.0.21"
  spec.summary = "ThreeDSSDK."
  spec.homepage = "https://github.com/Radarpayments/ios-sdk"
  spec.license = "MIT"
  spec.author = { "RBS" => "rbssupport2@bpcbt.com" }
  spec.source = {
    :http => "https://github.com/Radarpayments/ios-sdk/releases/download/0.0.21/ThreeDSSDK.zip"
  }
  spec.ios.deployment_target = '10.0'
  spec.ios.vendored_frameworks = "ThreeDSSDK.xcframework"
end
