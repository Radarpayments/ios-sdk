Pod::Spec.new do |spec|
  spec.name = "ThreeDSSDK"
  spec.version = "2.0.4"
  spec.summary = "ThreeDSSDK."
  spec.homepage = "https://github.com/Radarpayments/ios-sdk"
  spec.license = "MIT"
  spec.author = { "RBS" => "rbssupport2@bpcbt.com" }
  spec.source = {
    :http => "https://github.com/Radarpayments/ios-sdk/releases/download/#{spec.version}/ThreeDSSDK.zip"
  }
  spec.ios.deployment_target = '10.0'
  spec.ios.vendored_frameworks = "ThreeDSSDK.xcframework"
end
