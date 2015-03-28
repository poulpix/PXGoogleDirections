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

> Swift frameworks in CocoaPods 0.36 being still somewhat shaky, Swift not being finished yet and myself not being quite a Cocoapods expert yet, please come back to me if you face any problem using this SDK in your project...

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
to: PXLocation.NamedLocation("Googleplex", "Mountain View", "United States"))
```
2) Run the Directions request:
```swift
directionsAPI.calculateDirections( (response) -> Void in {
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