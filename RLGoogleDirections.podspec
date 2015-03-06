Pod::Spec.new do |s|
s.name     = 'RLGoogleDirections'
s.version  = '1.0.0'
s.summary  = 'Google Directions API SDK for iOS and Mac OS, entirely written in Swift'
s.platform     = :ios
s.ios.deployment_target = '8.0'
s.license      = { :type => 'BSD', :file => 'LICENSE' }
s.source_files = 'RLGoogleDirections/*.swift'
s.source       = { :git => "https://github.com/poulpix/RLGoogleDirections.git", :tag => "1.0.0" }
s.requires_arc = true
s.framework  = "Foundation"
s.author   = { 'Romain Larmet' => 'dev.romain@me.com' }
s.social_media_url   = "https://twitter.com/_RomainL"
s.homepage   = "https://github.com/poulpix/RLGoogleDirections"
end
