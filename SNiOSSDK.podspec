
Pod::Spec.new do |spec|

  spec.name         = "SNiOSSDK"
  spec.version      = "0.1.1"
  spec.summary      = "iOS SDK to integrate signing flow by SignNow into your product."

  spec.homepage     = "https://github.com/SignNowInc/SN_iOS_SDK"


  spec.license      = { :type => "MIT", :file => "SNiOSDocumentsSDK/License" }
  spec.author       = { "Mykola Avilov" => "avilov.mykola@pdffiller.team" }

  spec.ios.deployment_target = '12.0'
  spec.ios.vendored_frameworks = 'SNiOSDocumentsSDK/SNiOSDocumentSDK.xcframework'
  spec.source       = { :http => 'https://github.com/SignNowInc/SN_iOS_SDK/raw/0.1.1/SNiOSDocumentsSDK.zip' }

end
