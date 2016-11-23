# PXGoogleDirections
Google Directions API SDK for iOS, entirely written in Swift.

[![Cocoapods](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg)
[![Cocoapods](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg)
[![Cocoapods](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg)](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg)
![Swift](https://img.shields.io/badge/%20in-swift%203-orange.svg)

[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/PXGoogleDirections.svg?style=plastic)]()
[![CocoaPods](https://img.shields.io/cocoapods/at/PXGoogleDirections.svg?style=plastic)]()
[![CocoaPods](https://img.shields.io/cocoapods/aw/PXGoogleDirections.svg?style=plastic)]()

[![GitHub stars](https://img.shields.io/github/stars/poulpix/PXGoogleDirections.svg?style=social&label=Star&style=plastic)]()
[![GitHub forks](https://img.shields.io/github/forks/poulpix/PXGoogleDirections.svg?style=social&label=Fork&style=plastic)]()
[![GitHub watchers](https://img.shields.io/github/watchers/poulpix/PXGoogleDirections.svg?style=social&label=Watch&style=plastic)]()
[![Twitter Follow](https://img.shields.io/twitter/follow/_RomainL.svg?style=social&label=Follow&style=plastic)]()

## Features
- Supports all features from the Google Directions API as of November 2016 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Supports "open in Google Maps app", both for specific locations and directions request
  * also supports the callback feature to get the user back to your app when he's done in Google Maps
  * in case the Google Maps app is not installed, also supports fallback to the built-in Apple Maps app
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods
- V1.3 is fully compatible with Swift 3 and Google Maps iOS SDK V2+

## New in V1.3
- Full Swift 3 support
- Full Google Maps iOS SDK 2.0+ support
- Added a `trafficModel` property on the `PXGoogleDirections` class to match Google's one in the API (recently added); it works only for driving routes, and when a departure date is specified
- Fixed a bug where drawing a route would only draw a basic, rough representation of it taken from the route object; now there is an option for drawing a detailed route in the `drawOnMap` method of the `PXGoogleDirectionsRoute` class
- Other small bug fixes

## Installation
### From Cocoapods
To use PXGoogleDirections in your project add the following 'Podfile' to your project:

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.1'

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
  case let .error(_, error):
   // Oops, something bad happened, see the error object for more information
   break
  case let .success(request, routes):
   // Do your work with the routes object array here
   break
 }
})
```

See "Documentation" below for more information on the available properties and response data.

## Requirements
- Runs on iOS 8.1 at least, or above.
- Compatible with Swift 3 / Xcode 8 and later.
  - Please use v1.2.3 if you need compatibility with a previous version of Swift.
- The SDK depends on the official Google Maps SDK for iOS (more information here: [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios/))

## Documentation
The SDK provides an integrated documentation within Xcode, with full autocomplete support.

To help getting you started, a sample project is also available in the "Sample" subfolder of this repository.

It is designed to demo the main features of both the API and the SDK.

<img src="https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/Sample/Mockup1.png" width="400px"/><img src="https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/Sample/Mockup2.png" width="400px"/>

## In case of problems
Since V1.3, PXGoogleDirections uses Google's latest branch of Google Maps iOS SDK, which has now been split into smaller, more modular frameworks. PXGoogleDirections has a dependency with three of them:
- `GoogleMapsCore`
- `GoogleMapsBase`
- `GoogleMaps`
The Google Places iOS SDK is not required.

If your app *also* requires the Google Maps iOS SDK, you might run into troubles because of conflicts with the bundled Google Maps iOS SDK in the Cocoapod. Providing Cocoapods frameworks with static framework dependencies like Google Maps is a real pain and there is no simple, straightforward solution I'm aware of, unfortunately.

If you happen to face these problems, please try to do the following:
- Add `-framework "GoogleMapsBase" -framework "GoogleMapsCore" -framework "GoogleMaps"` to the "Other Linker Flags" of your Xcode project.
- Make sure you are linking your app with all the libraries and frameworks required by the Google Maps iOS SDK. For a full list, see here: https://github.com/CocoaPods/Specs/blob/master/Specs/a/d/d/GoogleMaps/2.1.1/GoogleMaps.podspec.json

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
