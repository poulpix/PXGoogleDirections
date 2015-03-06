//
//  ViewController.swift
//  RLGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var directionsAPI: RLGoogleDirections!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// TODO: Remove personal API key!
		directionsAPI = RLGoogleDirections(apiKey: "AIzaSyAuRX0vPgqF0wIr7A2pgFIEPj5CfesPeRc", from: RLLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.331690, -122.030762)), to: RLLocation.NamedLocation("Googleplex", "Mountain View", "Etats-Unis"))
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
		directionsAPI.arrivalTime = RLTime.timeFromDate(NSDate())
		logDirections()
		directionsAPI.transitRoutingPreference = .FewerTransfers
		logDirections()
		directionsAPI.transitModes.insert(.Bus)
		directionsAPI.transitModes.insert(.Subway)
		logDirections()
		directionsAPI.mode = .Transit
		logDirections()
		let fb = RLLocation.NamedLocation("Hacker Way", "Menlo Park", "Etats-Unis")
		//directionsAPI.waypoints.append(fb)
		let tw = RLLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.782334, -122.400795))
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

extension ViewController: RLGoogleDirectionsDelegate {
	func googleDirectionsWillSendRequestToAPI(googleDirections: RLGoogleDirections, withURL requestURL: NSURL) -> Bool {
		NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
		return true
	}
	
	func googleDirectionsDidSendRequestToAPI(googleDirections: RLGoogleDirections, withURL requestURL: NSURL) {
		NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
	}
	
	func googleDirections(googleDirections: RLGoogleDirections, didReceiveRawDataFromAPI data: NSData) {
		NSLog("googleDirections:didReceiveRawDataFromAPI:")
		NSLog(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
	}
	
	func googleDirectionsRequestDidFail(googleDirections: RLGoogleDirections, withError error: NSError) {
		NSLog("googleDirectionsRequestDidFail:withError:")
		NSLog("\(error)")
	}
	
	func googleDirections(googleDirections: RLGoogleDirections, didReceiveResponseFromAPI apiResponse: [RLGoogleDirectionsRoute]) {
		NSLog("googleDirections:didReceiveResponseFromAPI:")
		NSLog("Got \(apiResponse.count) routes")
		for i in 0 ..< apiResponse.count {
			NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
		}
	}
}
