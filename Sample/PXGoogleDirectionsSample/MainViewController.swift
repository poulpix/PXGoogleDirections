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

class MainViewController: UIViewController {
	@IBOutlet weak var originField: UITextField!
	@IBOutlet weak var destinationField: UITextField!
	@IBOutlet weak var modeField: UISegmentedControl!
	@IBOutlet weak var advancedSwitch: UISwitch!
	@IBOutlet weak var advancedView: UIView!
	@IBOutlet weak var unitField: UISegmentedControl!
	@IBOutlet weak var transitRoutingField: UISegmentedControl!
	@IBOutlet weak var alternativeSwitch: UISwitch!
	@IBOutlet weak var busSwitch: UISwitch!
	@IBOutlet weak var subwaySwitch: UISwitch!
	@IBOutlet weak var trainSwitch: UISwitch!
	@IBOutlet weak var tramSwitch: UISwitch!
	@IBOutlet weak var railSwitch: UISwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	private var directionsAPI: PXGoogleDirections {
		return (UIApplication.sharedApplication().delegate as! AppDelegate).directionsAPI
	}
	
	private func modeFromField() -> PXGoogleDirectionsMode {
		return PXGoogleDirectionsMode(rawValue: modeField.selectedSegmentIndex)!
	}
	
	private func unitFromField() -> PXGoogleDirectionsUnit {
		return PXGoogleDirectionsUnit(rawValue: unitField.selectedSegmentIndex)!
	}
	
	@IBAction func advancedOptionsChanged(sender: UISwitch) {
		UIView.animateWithDuration(0.5, animations: {
			self.advancedView.alpha =  (self.advancedSwitch.on ? 1.0 : 0.0)
		})
	}
	
	private func transitRoutingPreferenceFromField() -> PXGoogleDirectionsTransitRoutingPreference? {
		return PXGoogleDirectionsTransitRoutingPreference(rawValue: transitRoutingField.selectedSegmentIndex)
	}
	
	@IBAction func goButtonTouched(sender: UIButton) {
		directionsAPI.delegate = self
		directionsAPI.from = PXLocation.NamedLocation(originField.text)
		directionsAPI.to = PXLocation.NamedLocation(destinationField.text)
		directionsAPI.mode = modeFromField()
		if advancedSwitch.on {
			directionsAPI.transitRoutingPreference = transitRoutingPreferenceFromField()
			directionsAPI.units = unitFromField()
			directionsAPI.alternatives = alternativeSwitch.on
			directionsAPI.transitModes = Set()
			if busSwitch.on {
				directionsAPI.transitModes.insert(.Bus)
			}
			if subwaySwitch.on {
				directionsAPI.transitModes.insert(.Subway)
			}
			if trainSwitch.on {
				directionsAPI.transitModes.insert(.Train)
			}
			if tramSwitch.on {
				directionsAPI.transitModes.insert(.Tram)
			}
			if railSwitch.on {
				directionsAPI.transitModes.insert(.Rail)
			}
		} else {
			directionsAPI.transitRoutingPreference = nil
			directionsAPI.units = nil
			directionsAPI.alternatives = nil
			directionsAPI.transitModes = Set()
		}
		/*
		directionsAPI.featuresToAvoid.insert(.Ferries)
		directionsAPI.featuresToAvoid.insert(.Highways)
		directionsAPI.departureTime = .Now
		directionsAPI.departureTime = nil
		directionsAPI.arrivalTime = PXTime.timeFromDate(NSDate())
		directionsAPI.transitModes.insert(.Bus)
		directionsAPI.transitModes.insert(.Subway)
		directionsAPI.mode = .Transit
		let fb = PXLocation.SpecificLocation("Hacker Way", "Menlo Park", "Etats-Unis")
		directionsAPI.waypoints.append(fb)
		let tw = PXLocation.CoordinateLocation(CLLocationCoordinate2DMake(37.782334, -122.400795))
		directionsAPI.waypoints.append(tw)
		directionsAPI.optimizeWaypoints = false
		directionsAPI.optimizeWaypoints = true
		directionsAPI.language = "fr"
		directionsAPI.region = "fr"
		*/
		directionsAPI.calculateDirections { (response) -> Void in
			switch response {
			case .Error(let error):
				var alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			case .Success(let routes):
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					if let rvc = self.storyboard?.instantiateViewControllerWithIdentifier("Results") as? ResultsViewController {
						rvc.results = routes
						self.presentViewController(rvc, animated: true, completion: nil)
					}
				})
			}
		}
	}
}

extension MainViewController: PXGoogleDirectionsDelegate {
	func googleDirectionsWillSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) -> Bool {
		NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
		return true
	}
	
	func googleDirectionsDidSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) {
		NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
		NSLog("\(requestURL.absoluteString?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
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
