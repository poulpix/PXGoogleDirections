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

## 🗺 Features
- Supports all features from the Google Directions API as of November 2016 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Supports "open in Google Maps app", both for specific locations and directions request
  * also supports the callback feature to get the user back to your app when he's done in Google Maps
  * in case the Google Maps app is not installed, also supports fallback to the built-in Apple Maps app
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods

## 🆕 New in V1.4
- Compatibility with Swift 3.1
- Improvements to projects mixing this pod with Google Maps and/or Google Places pods

## 🆕 New in V1.3
- Full Swift 3 support
- Full Google Maps iOS SDK 2.0+ support
- Added a `trafficModel` property on the `PXGoogleDirections` class to match Google's one in the API (recently added); it works only for driving routes, and when a departure date is specified
- Fixed a bug where drawing a route would only draw a basic, rough representation of it taken from the route object; now there is an option for drawing a detailed route in the `drawOnMap` method of the `PXGoogleDirectionsRoute` class
- Other small bug fixes

## ⚠️ Requirements
- Runs on iOS 8.1 and later.
- Compatible with Swift 3 / Xcode 8 and later.
  - Please use v1.2.3 if you need compatibility with a previous version of Swift.
- The SDK depends on the official Google Maps SDK for iOS (more information here: [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios/))

## 💻 Installation
### From Cocoapods
To use PXGoogleDirections in your project add the following Podfile to your project:

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

___
> **Important**: If your project needs both PXGoogleDirections and Google Maps and/or Google Places iOS SDK, you **_will_** run into problems. Please see the "Compatibility with Google pods" paragraph below, and do not hesitate to contact me and describe your issue if you require assistance!

___

### From source
- Clone the repository
- Add the whole `PXGoogleDirections` project to your own Xcode project
- Add a dependency between the two projects and build

## ⌨️ Usage
Quick-start in two lines of Swift code:

1) Create an API object:
```swift
let directionsAPI = PXGoogleDirections(apiKey: "<insert your Google API key here>",
    from: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)),
    to: PXLocation.specificLocation("Googleplex", "Mountain View", "United States"))
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

## 📚 Documentation
The SDK provides an integrated documentation within Xcode, with full autocomplete support.

To help getting you started, a sample project is also available in the "Sample" subfolder of this repository.

It is designed to demo the main features of both the API and the SDK.

<img src="https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/Sample/Mockup1.png" width="400px"/><img src="https://raw.githubusercontent.com/poulpix/PXGoogleDirections/master/Sample/Mockup2.png" width="400px"/>

## 😱 Compatibility with Google pods
Since V1.3, PXGoogleDirections uses Google's latest branch of Google Maps iOS SDK, which has now been split into smaller, more modular frameworks. PXGoogleDirections has a dependency with three of them:
- `GoogleMapsCore`
- `GoogleMapsBase`
- `GoogleMaps`

> The Google Places iOS SDK is not required.

If your app also requires the Google Maps iOS SDK (for drawing on a map, for example), you **_will_** run into troubles because of conflicts with the bundled Google Maps iOS SDK in the pod. This is because of Google's way of releasing its pods as static frameworks, and not dynamic ones.

Here is the only workaround known to date:

1. Remove PXGoogleDirections from your Podfile and issue a `pod update`.
2. Add all the Google dependencies to your Podfile (e.g.: `pod GoogleMaps`, `pod GooglePlaces`) and issue a `pod update`.
3. Open a Terminal in your folder's root folder, and reference PXGoogleDirections as a git submodule, like this:

   ```
git submodule add https://github.com/poulpix/PXGoogleDirections.git Frameworks/External/PXGoogleDirections
   ```
   This will download all of the PXGoogleDirections project in a subfolder of your own project (`Frameworks/External/PXGoogleDirections`). Of course you can change this path if you like.

4. Update your Podfile to give instructions on how to build both your project and the PXGoogleDirections submodule:

   ```
   source 'https://github.com/CocoaPods/Specs.git'
   
   workspace 'test.xcworkspace' # Your project's workspace
   project 'test.xcodeproj' # Your project's Xcode project
   project 'Frameworks/External/PXGoogleDirections/PXGoogleDirections.xcodeproj' # Update folder structure if needed
   
   target 'test' do
      project 'test.xcodeproj'
      platform :ios, '10.0' # Update for your needs
   
      use_frameworks!
   
      # Update these lines depending on which Google pods you need
      pod 'GoogleMaps'
      pod 'GooglePlaces'
      # Other pods...
   end
   
   # This tells Cocoapods how to build the subproject
   target 'PXGoogleDirections' do
      project 'Frameworks/External/PXGoogleDirections/PXGoogleDirections.xcodeproj'
      platform :ios, '8.1'
   
      pod 'GoogleMaps'
   end
   ```
5. Now you need to do a `pod install` in two locations:
  * your project's root directory,
  * the PXGoogleDirections submodule's root directory (e.g. `Frameworks/External/PXGoogleDirections`).
6. Open Xcode with your project.xcworkspace and build the PXGoogleDirections target, then your app's target. Everything should build properly.

## 🙏🏻 Credit
- Some portions of code inspired by [OpenInGoogleMaps-iOS](https://github.com/googlemaps/OpenInGoogleMaps-iOS), from the Google Maps team.
- Kudos to [@embasssem](https://github.com/embassem) for providing a workaround with Google SDKs ([#28](https://github.com/poulpix/PXGoogleDirections/issues/28)).

## 📜 License
The PXGoogleDirections SDK is licensed under the New BSD license. (see LICENSE for more information.)

## 📮 Contact
Don't hesitate to drop me a line on Github, Twitter, Stack Overflow, or by email:
- https://github.com/poulpix
- https://twitter.com/_RomainL
- http://stackoverflow.com/users/145997/romain
- dev (dot) romain (at) me.com
