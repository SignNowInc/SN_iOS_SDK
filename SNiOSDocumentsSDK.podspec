
Pod::Spec.new do |spec|

  spec.name         = "SNiOSDocumentsSDK"
  spec.version      = "0.2.2"
  spec.summary      = "iOS SDK to integrate signing flow by SignNow into your product."

  spec.homepage     = "https://github.com/SignNowInc/SN_iOS_SDK"


  spec.license      = { :type => "MIT", :file => "License" }
  spec.author       = { "Mykola Avilov" => "avilov.mykola@pdffiller.team" }

  spec.platform = :ios

  spec.ios.deployment_target = '12.0'
  spec.ios.vendored_frameworks = '{spec.version.to_s}/SNiOSDocumentsSDK.xcframework'
  spec.source       = { :http => 'https://github.com/SignNowInc/SN_iOS_SDK/archive/refs/tags/{spec.version.to_s}.zip' }

end
