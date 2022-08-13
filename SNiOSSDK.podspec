
Pod::Spec.new do |spec|

  spec.name         = "SNiOSSDK"
  spec.version      = "0.1.0"
  spec.summary      = "iOS SDK to integrate signing flow by SignNow into your product."

  spec.homepage     = "https://github.com/SignNowInc/SN_iOS_SDK"


  spec.license      = { :type => "MIT", :file => "License" }
  spec.author             = { "Mykola Avilov" => "avilov.mykola@pdffiller.team" }

  spec.platform     = :ios, "12.0"
  spec.vendored_frameworks = 'SNiOSSDK.xcframework'
  spec.source       = { :http => 'https://github.com/SignNowInc/SN_iOS_SDK/raw/master/SNiOSSDK.zip' }

  #spec.source_files  = "Classes", "Classes/**/*.{h,m}"

end
