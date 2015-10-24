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
import GoogleMaps

protocol MainViewControllerDelegate {
	func didAddWaypoint(waypoint: PXLocation)
}

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
	@IBOutlet weak var avoidTollsSwitch: UISwitch!
	@IBOutlet weak var avoidHighwaysSwitch: UISwitch!
	@IBOutlet weak var avoidFerriesSwitch: UISwitch!
	@IBOutlet weak var startArriveField: UISegmentedControl!
	@IBOutlet weak var startArriveDateField: UITextField!
	@IBOutlet weak var waypointsLabel: UILabel!
	@IBOutlet weak var optimizeWaypointsSwitch: UISwitch!
	@IBOutlet weak var languageField: UISegmentedControl!
	var startArriveDate: NSDate?
	var waypoints: [PXLocation] = [PXLocation]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		updateStartArriveDateField(nil)
		updateWaypointsField()
		let datePicker = UIDatePicker()
		datePicker.sizeToFit()
		datePicker.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		datePicker.datePickerMode = .DateAndTime
		datePicker.minuteInterval = 5
		startArriveDateField.inputView = datePicker
		let keyboardDoneButtonView = UIToolbar()
		keyboardDoneButtonView.barStyle = .Black
		keyboardDoneButtonView.translucent = true
		keyboardDoneButtonView.tintColor = nil
		keyboardDoneButtonView.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("doneButtonTouched:"))
		let clearButton = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: Selector("clearButtonTouched:"))
		keyboardDoneButtonView.setItems([doneButton, clearButton], animated: false)
		startArriveDateField.inputAccessoryView = keyboardDoneButtonView
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
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
	
	private func transitRoutingPreferenceFromField() -> PXGoogleDirectionsTransitRoutingPreference? {
		return PXGoogleDirectionsTransitRoutingPreference(rawValue: transitRoutingField.selectedSegmentIndex)
	}
	
	private func languageFromField() -> String {
		return languageField.titleForSegmentAtIndex(languageField.selectedSegmentIndex)!
		// There are quite a few other languages available, see here for more information: https://developers.google.com/maps/faq#languagesupport
	}
	
	private func updateStartArriveDateField(newDate: NSDate?) {
		startArriveDate = newDate
		if let saDate = startArriveDate {
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .MediumStyle
			dateFormatter.timeStyle = .ShortStyle
			startArriveDateField.text = dateFormatter.stringFromDate(saDate)
		} else {
			startArriveDateField.text = ""
		}
	}
	
	private func updateWaypointsField() {
		switch (waypoints).count {
		case 0:
			waypointsLabel.text = "No waypoints"
		case 1:
			waypointsLabel.text = "1 waypoint"
		default:
			waypointsLabel.text = "\((waypoints).count) waypoints"
		}
	}
	
	@IBAction func advancedOptionsChanged(sender: UISwitch) {
		UIView.animateWithDuration(0.5, animations: {
			self.advancedView.alpha =  (self.advancedSwitch.on ? 1.0 : 0.0)
		})
	}
	
	@IBAction func selectDateButtonTouched(sender: UIButton) {
		startArriveDateField.enabled = true
		startArriveDateField.becomeFirstResponder()
	}
	
	func doneButtonTouched(sender: UIBarButtonItem) {
		updateStartArriveDateField((startArriveDateField.inputView as! UIDatePicker).date)
		startArriveDateField.resignFirstResponder()
		startArriveDateField.enabled = false
	}
	
	func clearButtonTouched(sender: UIBarButtonItem) {
		updateStartArriveDateField(nil)
		startArriveDateField.resignFirstResponder()
		startArriveDateField.enabled = false
	}
	
	@IBAction func addWaypointButtonTouched(sender: UIButton) {
		if let wpvc = self.storyboard?.instantiateViewControllerWithIdentifier("Waypoint") as? WaypointViewController {
			wpvc.delegate = self
			self.presentViewController(wpvc, animated: true, completion: nil)
		}
	}
	
	@IBAction func clearWaypointsButtonTouched(sender: UIButton) {
		waypoints.removeAll(keepCapacity: false)
		updateWaypointsField()
	}
	
	@IBAction func goButtonTouched(sender: UIButton) {
		directionsAPI.delegate = self
		directionsAPI.from = PXLocation.NamedLocation(originField.text!)
		directionsAPI.to = PXLocation.NamedLocation(destinationField.text!)
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
			directionsAPI.featuresToAvoid = Set()
			if avoidTollsSwitch.on {
				directionsAPI.featuresToAvoid.insert(.Tolls)
			}
			if avoidHighwaysSwitch.on {
				directionsAPI.featuresToAvoid.insert(.Highways)
			}
			if avoidFerriesSwitch.on {
				directionsAPI.featuresToAvoid.insert(.Ferries)
			}
			switch startArriveField.selectedSegmentIndex {
			case 0:
				directionsAPI.departureTime = .Now
				directionsAPI.arrivalTime = nil
			case 1:
				if let saDate = startArriveDate {
					directionsAPI.departureTime = PXTime.timeFromDate(saDate)
					directionsAPI.arrivalTime = nil
				} else {
					return
				}
			case 2:
				if let saDate = startArriveDate {
					directionsAPI.departureTime = nil
					directionsAPI.arrivalTime = PXTime.timeFromDate(saDate)
				} else {
					return
				}
			default:
				break
			}
			directionsAPI.waypoints = waypoints
			directionsAPI.optimizeWaypoints = optimizeWaypointsSwitch.on
			directionsAPI.language = languageFromField()
		} else {
			directionsAPI.transitRoutingPreference = nil
			directionsAPI.units = nil
			directionsAPI.alternatives = nil
			directionsAPI.transitModes = Set()
			directionsAPI.featuresToAvoid = Set()
			directionsAPI.departureTime = nil
			directionsAPI.arrivalTime = nil
			directionsAPI.waypoints = [PXLocation]()
			directionsAPI.optimizeWaypoints = nil
			directionsAPI.language = nil
		}
		// directionsAPI.region = "fr" // Feature not demonstrated in this sample app
		directionsAPI.calculateDirections { (response) -> Void in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				switch response {
				case let .Error(_, error):
					let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
					alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
					self.presentViewController(alert, animated: true, completion: nil)
				case let .Success(request, routes):
					if let rvc = self.storyboard?.instantiateViewControllerWithIdentifier("Results") as? ResultsViewController {
						rvc.request = request
						rvc.results = routes
						self.presentViewController(rvc, animated: true, completion: nil)
					}
				}
			})
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
		NSLog("\(requestURL.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)")
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

extension MainViewController: MainViewControllerDelegate {
	func didAddWaypoint(waypoint: PXLocation) {
		waypoints.append(waypoint)
		updateWaypointsField()
	}
}
