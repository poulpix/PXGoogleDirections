# RLGoogleDirections
Google Directions API SDK for iOS and Mac OS, entirely written in Swift.

## Features
- Supports all features from the Google Directions API as of March 2015 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods

## Installation
### From Cocoapods
At this time, Cocoapods support for Swift frameworks is still in Beta: http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/.

To use RLGoogleDirections in your project add the following 'Podfile' to your project:

```
source 'https://github.com/CocoaPods/Specs.git'
pod 'RLGoogleDirections'
```

And run the following command from the Terminal:

```bash
pod install
```

Now, from your code, you can simply import the module like this:

```swift
import RLGoogleDirections
```

### From source
 - Clone the repository
 - Add the whole `RLGoogleDirections` project to your own Xcode project
 - Add a dependency between the two projects and build

## Usage
Quick-start in two lines of Swift code:
 1. `let directionsAPI = RLGoogleDirections(apiKey: "<insert your Google API key here>", from: RLLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)), to: RLLocation.NamedLocation("Googleplex", "Mountain View", "United States")`
 2. `directionsAPI.calculateDirections { (response) -> Void in { // Do your work here }`

See "Documentation" below for more information on the available properties and response data.

## Requirements
This SDK requires iOS 8 at least, or above.

It also depends on the Google Maps SDK for iOS (from Google).
More information here: https://developers.google.com/maps/documentation/ios/

## Documentation
(TODO)

## License
The RLGoogleDirections SDK is licensed under the New BSD license.

## Contact
Don't hesitate to drop me a line on Github, Twitter, Stack Overflow, or by email:
 - https://github.com/poulpix
 - https://twitter.com/_RomainL
 - http://stackoverflow.com/users/145997/romain
 - dev (dot) romain (at) me.com
