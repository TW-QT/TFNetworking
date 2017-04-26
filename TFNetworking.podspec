Pod::Spec.new do |s|

  s.name         = "TFNetworking"
  s.version      = "1.0.1"
  s.summary      = "Dabay tech : TFNetworking is a high level request util based on AFNetworking."
  s.homepage     = "https://github.com/Donkey-Tao/TFNetworking"
  s.license      = "MIT"
  s.author       = { "Tao Fei" => "taofei0610@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Donkey-Tao/TFNetworking.git", :tag => s.version.to_s}
  s.source_files = "TFNetworking/**/*.{h,m}"
  s.frameworks   = "CFNetwork",'Security'
  s.requires_arc = true
  s.dependency  "AFNetworking", "~> 3.1.0"
  s.dependency  "MBProgressHUD-TFExtension", "~> 1.1.0"

end
