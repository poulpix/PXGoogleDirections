//
//  ViewController.swift
//  RLGoogleDirectionsSample
//
//  Created by Romain on 07/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import UIKit
import CoreLocation
import PXGoogleDirections

class ViewController: UIViewController {
	var directionsAPI: PXGoogleDirections!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// TODO: Replace `getGoogleAPIKey()` with your own Google Maps API key!
		directionsAPI = PXGoogleDirections(apiKey: getGoogleAPIKey(), from: PXLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)), to: PXLocation.NamedLocation("Googleplex", "Mountain View", "Etats-Unis"))
		directionsAPI.delegate = self
		logDirections()
		directionsAPI.mode = .Bicycling
		logDirections()
		directionsAPI.alternatives = true
		logDirections()
		directionsAPI.featuresToAvoid.insert(.Ferries)
		directionsAPI.featuresToAvoid.insert(.Highways)
		logDirections()
		directionsAPI.units = .Metric
		logDirections()
		directionsAPI.departureTime = .Now
		logDirections()
		directionsAPI.departureTime = nil
		directionsAPI.arrivalTime = PXTime.timeFromDate(NSDate())
		logDirections()
		directionsAPI.transitRoutingPreference = .FewerTransfers
		logDirections()
		directionsAPI.transitModes.insert(.Bus)
		directionsAPI.transitModes.insert(.Subway)
		logDirections()
		directionsAPI.mode = .Transit
		logDirections()
		let fb = PXLocation.NamedLocation("Hacker Way", "Menlo Park", "Etats-Unis")
		//directionsAPI.waypoints.append(fb)
		let tw = PXLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.782334, -122.400795))
		//directionsAPI.waypoints.append(tw)
		logDirections()
		directionsAPI.optimizeWaypoints = false
		logDirections()
		directionsAPI.optimizeWaypoints = true
		logDirections()
		directionsAPI.language = "fr"
		logDirections()
		directionsAPI.region = "fr"
		logDirections()
		directionsAPI.calculateDirections { (response) -> Void in
		}
	}
	
	private func logDirections() {
		if let u = directionsAPI.directionsAPIRequestURL {
			NSLog("\(u.absoluteString!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
		} else {
			NSLog("Invalid URL")
		}
	}
}

extension ViewController: PXGoogleDirectionsDelegate {
	func googleDirectionsWillSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) -> Bool {
		NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
		return true
	}
	
	func googleDirectionsDidSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) {
		NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
	}
	
	func googleDirections(googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: NSData) {
		NSLog("googleDirections:didReceiveRawDataFromAPI:")
		NSLog(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
	}
	
	func googleDirectionsRequestDidFail(googleDirections: PXGoogleDirections, withError error: NSError) {
		NSLog("googleDirectionsRequestDidFail:withError:")
		NSLog("\(error)")
	}
	
	func googleDirections(googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
		NSLog("googleDirections:didReceiveResponseFromAPI:")
		NSLog("Got \(apiResponse.count) routes")
		for i in 0 ..< apiResponse.count {
			NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
		}
	}
}
