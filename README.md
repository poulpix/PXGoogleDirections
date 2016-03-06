# PXGoogleDirections
Google Directions API SDK for iOS, entirely written in Swift.

[![Cocoapods](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg)
[![Cocoapods](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg)
[![Cocoapods](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg)

## Features
- Supports all features from the Google Directions API as of March 2015 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Supports "open in Google Maps app", both for specific locations and directions request
  * also supports the callback feature to get the user back to your app when he's done in Google Maps
  * in case the Google Maps app is not installed, also supports fallback to the built-in Apple Maps app
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods

## Installation
### From Cocoapods
To use PXGoogleDirections in your project add the following 'Podfile' to your project:

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

pod 'PXGoogleDirections'

use_frameworks!
```

Then run the following command from the Terminal:

```bash
pod install
```

Now, from your code, you should be able to simply import the module like this:

```swift
import PXGoogleDirections
```

> You might run into issues if you mix up PXGoogleDirections with the Google Maps iOS SDK in your app. If you do so, please check the "In case of problems" paragraph below, and do not hesitate to contact me and describe your issue if you require assistance!

### From source
- Clone the repository
- Add the whole `PXGoogleDirections` project to your own Xcode project
- Add a dependency between the two projects and build

## In case of problems
If your app also requires the Google Maps iOS SDK, you might run into troubles because of conflicts with the bundled Google Maps iOS SDK in the Cocoapod.
If you happen to face these problems, please try to do the following:
- Add `-framework "GoogleMaps"` to the "Other Linker Flags" of your Xcode project.
- Make sure you are linking your app with all the libraries and frameworks required by the Google Maps iOS SDK. For a full list, see here: https://github.com/CocoaPods/Specs/blob/master/Specs/GoogleMaps/1.12.3/GoogleMaps.podspec.json
- Also make sure that your app contains the `GoogleMaps.bundle` in the "Copy Bundle Resources" phase of the build process. If it doesn't, you can manually add it to Xcode by browsing to the following directory in the Finder: `/Pods/PXGoogleDirections/Dependencies/GoogleMaps.framework/Resources/GoogleMaps.bundle`. Drop it in the "Frameworks" group of your project and uncheck the "Copy" checkbox.

## Usage
Quick-start in two lines of Swift code:

1) Create an API object:
```swift
let directionsAPI = PXGoogleDirections(apiKey: "<insert your Google API key here>",
    from: PXLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)),
    to: PXLocation.SpecificLocation("Googleplex", "Mountain View", "United States"))
```
2) Run the Directions request:
```swift
directionsAPI.calculateDirections({ response in
 switch response {
  case let .Error(_, error):
   // Oops, something bad happened, see the error object for more information
   break
  case let .Success(request, routes):
   // Do your work with the routes object array here
   break
 }
})
```

See "Documentation" below for more information on the available properties and response data.

## Requirements
- Runs on iOS 8 at least, or above.
- Compatible with Swift 1.2 / Xcode 6.3 and later.
- The SDK depends on the official Google Maps SDK for iOS (more information here: [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios/))

## Documentation
A sample project is available in the "Sample" subfolder of this repository to help getting you started with the SDK.

<img src="https://github.com/poulpix/PXGoogleDirections/blob/master/Sample/Mockup1.png" width="400px"/><img src="https://github.com/poulpix/PXGoogleDirections/blob/master/Sample/Mockup2.png" width="400px"/>

## Credit
- Some portions of code inspired by OpenInGoogleMaps-iOS (https://github.com/googlemaps/OpenInGoogleMaps-iOS) from the Google Maps team.

## License
The PXGoogleDirections SDK is licensed under the New BSD license. (see LICENSE for more information.)

## Contact
Don't hesitate to drop me a line on Github, Twitter, Stack Overflow, or by email:
- https://github.com/poulpix
- https://twitter.com/_RomainL
- http://stackoverflow.com/users/145997/romain
- dev (dot) romain (at) me.com
