Pod::Spec.new do |s|
    s.name                  = 'PXGoogleDirections'
    s.version               = '1.2.3'

    s.homepage              = "https://github.com/poulpix/PXGoogleDirections"
    s.summary               = 'Google Directions API SDK for iOS, entirely written in Swift'
    #s.screenshot            = ""

    s.author                = { 'Romain L' => 'dev.romain@me.com' }
    s.license               = { :type => 'BSD', :file => 'LICENSE' }
    s.social_media_url      = "https://twitter.com/_RomainL"

    s.platforms             = { :ios => '8.0' }
    s.ios.deployment_target = '8.0'

    s.source_files          = 'PXGoogleDirections/*.{h,swift}'
    s.module_name           = 'PXGoogleDirections'
    s.source                = { :git => "https://github.com/poulpix/PXGoogleDirections.git", :tag => "1.2.3" }
    s.requires_arc          = true
    s.libraries             = "c++", "icucore", "z"
    s.frameworks            = "Accelerate", "AVFoundation", "CoreBluetooth", "CoreData", "CoreLocation", "CoreText", "Foundation", "GLKit", "ImageIO", "OpenGLES", "QuartzCore", "Security", "SystemConfiguration", "CoreGraphics", "GoogleMaps"
    s.resource_bundles      = { 'GoogleMaps' => ['Pods/GoogleMaps/Frameworks/GoogleMaps.framework/Resources/*.bundle'] }
    s.vendored_frameworks   = "Dependencies/GoogleMaps.framework"
    s.xcconfig              = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/PXGoogleDirections/Dependencies' }
end
