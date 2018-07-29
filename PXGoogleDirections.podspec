Pod::Spec.new do |s|
    s.name                  = 'PXGoogleDirections'
    s.version               = '1.5.1'

    s.homepage              = "https://github.com/poulpix/PXGoogleDirections"
    s.summary               = 'Google Directions API SDK for iOS, entirely written in Swift'
    s.screenshots           = [ 'https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/SampleScreen1.png', 'https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/SampleScreen2.png' ]

    s.author                = { 'Romain L' => 'dev.romain@me.com' }
    s.license               = { :type => 'BSD', :file => 'LICENSE' }
    s.social_media_url      = "https://twitter.com/_RomainL"

    s.platforms             = { :ios => '9.3' }
    s.ios.deployment_target = '9.3'
    s.swift_version         = '4.0'

    s.source_files          = 'PXGoogleDirections/*.{h,swift}'
    s.module_name           = 'PXGoogleDirections'
    s.source                = { :git => "https://github.com/poulpix/PXGoogleDirections.git", :tag => "1.5.1" }
    s.requires_arc          = true
    s.libraries             = "c++", "icucore", "z"
    s.frameworks            = "Accelerate", "AVFoundation", "CoreBluetooth", "CoreData", "CoreLocation", "CoreText", "Foundation", "GLKit", "ImageIO", "OpenGLES", "QuartzCore", "Security", "SystemConfiguration", "CoreGraphics", "GoogleMapsCore", "GoogleMapsBase", "GoogleMaps"
    #s.dependency            'GoogleMaps', '~> 2.5'
    s.resource              = 'Dependencies/GoogleMaps.framework/Resources/GoogleMaps.bundle'
    s.vendored_frameworks   = "Dependencies/GoogleMaps.framework", "Dependencies/GoogleMapsBase.framework", "Dependencies/GoogleMapsCore.framework"
    s.static_framework      = true
    #s.xcconfig              = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/PXGoogleDirections/Dependencies' }
end
