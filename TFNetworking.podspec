Pod::Spec.new do |s|
  s.name         = "TFNetworking"
  s.version      = "0.0.3"
  s.summary      = "A framework for iOS networking"
  s.description  = <<-DESC
                   Dabay tech : A framework for iOS networking
                   DESC
  s.homepage     = "https://github.com/Donkey-Tao/TFNetworking"
  s.license      = "MIT"
  s.author       = { "Tao Fei" => "taofei0610@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Donkey-Tao/TFNetworking.git", :tag => "#{s.version}" }
  s.source_files = "TFNetworking/**/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.1.0"
end
