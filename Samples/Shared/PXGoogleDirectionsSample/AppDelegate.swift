//
//  AppDelegate.swift
//  PXGoogleDirectionsSample
//
//  Created by Romain on 08/03/2015.
//  Copyright (c) 2015 Poulpix. All rights reserved.
//

import UIKit
import PXGoogleDirections
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var directionsAPI: PXGoogleDirections!

	internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 15.0)!], for: UIControl.State())
		// TODO: For you fellow developer: replace `getGoogleAPI{Client|Server}Key()` in the line below with a string containing your own Google Maps API key!
		directionsAPI = PXGoogleDirections(apiKey: getGoogleAPIServerKey()) // A valid server-side API key is required here
		
		return true
	}
}
