# RLGoogleDirections
Google Directions API SDK for iOS and Mac OS, entirely written in Swift.

## Features
- Supports all features from the Google Directions API as of March 2015 (see here for a full list: https://developers.google.com/maps/documentation/directions)
- Available both with modern, Swift-style completion blocks, or Objective-C-style delegation patterns
- Queries are made over HTTPS
- JSON is used behind the scenes to help reduce the size of the responses
- Available through CocoaPods

## Installation
(TODO)

## Usage
Quick-start in two lines of Swift code:
 1. `let directionsAPI = RLGoogleDirections(apiKey: "<insert your Google API key here>", from: RLLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)), to: RLLocation.NamedLocation("Googleplex", "Mountain View", "United States")`
 2. `directionsAPI.calculateDirections { (response) -> Void in { // Do your work here }`

See "Documentation" below for more information on the available properties and response data.

## Dependencies
The SDK depends on the Google Maps SDK for iOS (from Google).
More information here: https://developers.google.com/maps/documentation/ios/

## Documentation
(TODO)
