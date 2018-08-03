# PXGoogleDirections
Google Directions API SDK for iOS, entirely written in Swift.

[![Cocoapods](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg?style=plastic)](https://img.shields.io/cocoapods/p/PXGoogleDirections.svg)
[![Cocoapods](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg?style=plastic)](https://img.shields.io/cocoapods/l/PXGoogleDirections.svg)
![Swift](https://img.shields.io/badge/%20in-swift%204.2-orange.svg?style=plastic)

[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=plastic)](https://cocoapods.org)
[![Cocoapods](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg?style=plastic)](https://img.shields.io/cocoapods/v/PXGoogleDirections.svg)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/PXGoogleDirections.svg?style=plastic)]()
[![CocoaPods](https://img.shields.io/cocoapods/dt/PXGoogleDirections.svg?style=plastic)]()
[![CocoaPods](https://img.shields.io/cocoapods/at/PXGoogleDirections.svg?style=plastic)]()
[![CocoaPods](https://img.shields.io/cocoapods/aw/PXGoogleDirections.svg?style=plastic)]()

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=plastic)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compabible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=plastic)](https://swift.org/package-manager/)

[![GitHub stars](https://img.shields.io/github/stars/poulpix/PXGoogleDirections.svg?style=social&label=Star&style=plastic)]()
[![GitHub forks](https://img.shields.io/github/forks/poulpix/PXGoogleDirections.svg?style=social&label=Fork&style=plastic)]()
[![GitHub watchers](https://img.shields.io/github/watchers/poulpix/PXGoogleDirections.svg?style=social&label=Watch&style=plastic)]()
[![Twitter Follow](https://img.shields.io/twitter/follow/_RomainL.svg?style=social&label=Follow&style=plastic)]()

## 🗺 Features
- Supports all features from the Google Directions API as of January 2018 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Supports "open in Google Maps app", both for specific locations and directions request
  * also supports the callback feature to get the user back to your app when he's done in Google Maps
  * in case the Google Maps app is not installed, also supports fallback to the built-in Apple Maps app
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods and Carthage

## 🆕 New in V1.6
- Compatibility with Google Places IDs (usage: `PXLocation.googlePlaceId("gplaceid")`, or `PXLocation.googlePlaceId(gmsPlace.placeID)` if you're already using Google's Places SDK for iOS)
- Compatibility with Swift 4.2
- Updated to Google Maps iOS SDK 2.7
- Availability through Swift Package Manager

## 🆕 New in V1.5.1
- Updated to Google Maps iOS SDK 2.5
- The PXGoogleDirections Pod is now released as a static library (requires Cocoapods 1.4.0) 
- Other bug fixes

## 🆕 New in V1.4
- Compatibility with Swift 4
- Availability through Carthage
- Slight improvements to projects mixing this pod with Google Maps and/or Google Places pods (but mixing Google Maps iOS SDK with other Pods is still terrible...)

## 🆕 New in V1.3
- Full Swift 3 support
- Full Google Maps iOS SDK 2.0+ support
- Added a `trafficModel` property on the `PXGoogleDirections` class to match Google's one in the API (recently added); it works only for driving routes, and when a departure date is specified
- Fixed a bug where drawing a route would only draw a basic, rough representation of it taken from the route object; now there is an option for drawing a detailed route in the `drawOnMap` method of the `PXGoogleDirectionsRoute` class
- Other small bug fixes

## ⚠️ Requirements
- Runs on iOS 9.3 and later.
- Compatible with Swift 4 / Xcode 9 and later.
  - Please use v1.3 if you are on Swift 3 and/or Xcode 8.
  - Please use v1.2.3 if you need compatibility with a previous version of Swift.
- The SDK depends on the official Google Maps SDK for iOS (more information here: [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios/))

## 💻 Installation
### From Carthage
To use PXGoogleDirections in your project add the following line to your `Cartfile`:

```
github "Poulpix/PXGoogleDirections"
```

___
> Alternatively, if you wish to target a specific version of the library, simply append it at the end of the line in the `Carttfile`, e.g.: `github "Poulpix/PXGoogleDirections" ~> 1.5`.

___

Then run the following command from the Terminal:

```bash
carthage update
```

Finally, back to Xcode, drag & drop the generated framework in the "Embedded Binaries" section of your target's General tab. The framework should be located in the `Carthage/Build/iOS` subfolder of your Xcode project.

![Dropping a Carthage-generated framework in Xcode](CarthageXcode.png)

___
> **Important**: Carthage is only supported starting from version 1.4 of this library. Previous versions of this library will not work.

___

### From Cocoapods
To use PXGoogleDirections in your project add the following `Podfile` to your project:

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.3'
use_frameworks!

pod 'PXGoogleDirections'
```

Then run the following command from the Terminal:

```bash
pod install
```

___
> **Important**: If your project needs both PXGoogleDirections and Google Maps and/or Google Places iOS SDK, you **_will_** run into problems. Please see the "Compatibility with Google pods" paragraph below, and do not hesitate to contact me and describe your issue if you require assistance!

___

### From source
Building from raw source code is the preferred method if you wish to avoid known issues with the Google Maps iOS SDK conflicts with the library. However, you'll be lacking the automation and version updates the Cocoapods and Carthage frameworks provide.

To build from source, follow these simple steps:

- Clone the repository
- Add the whole `PXGoogleDirections` project to your own Xcode project
- Add a dependency between the two projects and build
- Do not forget to add the output of the `PXGoogleDirections` project (`PXGoogleDirections.framework`) to the "Embedded Binaries" section of your Xcode project's main target

![Adding the PXGoogleDirections framework as an embedded binary in Xcode](EmbeddedBinariesXcode.png)

## ⌨️ Usage
Quick-start in two lines of Swift code:

1) Reference the library like this:

```swift
import PXGoogleDirections
```

2) Create an API object:
```swift
let directionsAPI = PXGoogleDirections(apiKey: "<insert your Google API key here>",
    from: PXLocation.coordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)),
    to: PXLocation.specificLocation("Googleplex", "Mountain View", "United States"))
```
3) Run the Directions request:
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
___
> **Important**: You normally don't need to call `GMSServices.provideAPIKey()` yourself: it will be called by PXGoogleDirections when initializing the SDK.

___

See "Documentation" below for more information on the available properties and response data.

## 📚 Documentation
The SDK provides an integrated documentation within Xcode, with full autocomplete support.

To help getting you started, a sample project is also available in the "Sample" subfolder of this repository.

It is designed to demo the main features of both the API and the SDK.

![Sample app screenshot 1](Mockup1.png) ![Sample app screenshot 2](Mockup2.png)

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
   
___
> **Important**: You may also request a specific version of the framework by adding the `-b <branch>` switch to the `git submodule` command, like this:
> 
> `git submodule add -b <branch> https://github.com/poulpix/PXGoogleDirections.git Frameworks/External/PXGoogleDirections`
> 
> To find out the appropriate branch name, check out all the available branches on [Github](https://github.com/poulpix/PXGoogleDirections/branches/all)

___

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
      platform :ios, '9.3'
   
      pod 'GoogleMaps'
   end
   ```
5. Now you need to do a `pod install` in two locations:
  * your project's root directory,
  * the PXGoogleDirections submodule's root directory (e.g. `Frameworks/External/PXGoogleDirections`).
6. Open Xcode with your project.xcworkspace and build the PXGoogleDirections target, then your app's target. Everything should build properly.

## 💣 Known issues
Depending on your setup, you might see one or several of these known issues:

- Lots of messages like these at runtime (usually application startup): `Class GMSxxx_whatever is implemented in both (name of your app) and (reference to PXGoogleDirections framework). One of the two will be used. Which one is undefined.`
  This is because with Carthage or Cocoapods you usually have two versions of the Google Maps iOS SDK : the one that has been linked with the PXGoogleDirections library, and the one you will be forced to link against in your own application if you wish to use it explicitly. From what I've seen, there is no real impact to these warnings as long as both versions are equivalent. They only pollute your output console at runtime.
- Messages like these at runtime (usually when showing a Google Maps view): `Main Thread Checker: UI API called on a background thread: -[UIApplication setNetworkActivityIndicatorVisible:]`
  This behavior is new to Xcode 9, and it seems like the culprit is the Google Maps iOS SDK itself, not the sample app provided with the library. These messages are not really harmful, but they are not sane either. If you find a solution, please PM me!

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
