#  Validate Podspec by running 'pod spec lint <Framework>.podspec'
#  Podspec attributes : http://docs.cocoapods.org/specification.html
#  Podspecs examples : https://github.com/CocoaPods/Specs/

Pod::Spec.new do |s|

    s.name         = "LottieXtend"
    s.version      = "1.0.0"
    s.summary      = "Lottie + Texture (AsyncDisplayKit)"
    s.description  = <<-DESC
                        Use `LottieXtend` to integrate Lottie in your Texture based UI.
						`LottieNode` is the component of this framework, and offers the same capability and more as its counterpart `LottieAnimationView`.
                        DESC
    s.homepage     = "https://github.com/iDonJose/LottieXtend"
    s.source       = { :git => "https://github.com/iDonJose/LottieXtend.git", :tag => "#{s.version}" }

    s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

    s.author       = { "iDonJose" => "donor.develop@gmail.com" }


    s.ios.deployment_target = "9.0"

    s.source_files  = "Sources/**/*.{h,swift}"

    s.frameworks = "Foundation", "UIKit"

    s.dependency "ReactiveSwifty", "~> 1.1"
	s.dependency "lottie-ios", "~> 2.5"
	s.dependency "Texture/Core", "~> 2.7"

end
