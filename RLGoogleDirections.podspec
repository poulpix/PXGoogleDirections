Pod::Spec.new do |s|
s.name                  = 'RLGoogleDirections'
s.version               = '1.0.0'
s.summary               = 'Google Directions API SDK for iOS and Mac OS, entirely written in Swift'
s.platforms             = { :ios => '8.0', :osx => '10.10' }
s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'
s.license               = { :type => 'BSD', :file => 'LICENSE' }
s.source_files          = 'RLGoogleDirections/*.{h,swift}', '$(PODS_ROOT)/Goole-Maps-iOS-SDK/*.framework'
s.source                = { :git => "https://github.com/poulpix/RLGoogleDirections.git", :tag => "1.0.0" }
s.requires_arc          = true
s.frameworks            = "Foundation", "CoreLocation"
s.author                = { 'Romain L' => 'dev.romain@me.com' }
s.social_media_url      = "https://twitter.com/_RomainL"
s.homepage              = "https://github.com/poulpix/RLGoogleDirections"
s.xcconfig              = { 'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/Google-Maps-iOS-SDK' }
#s.dependency              'Google-Maps-iOS-SDK'
end
