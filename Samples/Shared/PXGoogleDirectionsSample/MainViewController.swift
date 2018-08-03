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
	func didAddWaypoint(_ waypoint: PXLocation)
}

class MainViewController: UIViewController {
	@IBOutlet weak var originField: UITextField!
	@IBOutlet weak var destinationField: UITextField!
	@IBOutlet weak var modeField: UISegmentedControl!
	@IBOutlet weak var advancedSwitch: UISwitch!
	@IBOutlet weak var advancedView: UIView!
	@IBOutlet weak var unitField: UISegmentedControl!
	@IBOutlet weak var transitRoutingField: UISegmentedControl!
	@IBOutlet weak var trafficModelField: UISegmentedControl!
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
	var startArriveDate: Date?
	var waypoints: [PXLocation] = [PXLocation]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		updateStartArriveDateField(nil)
		updateWaypointsField()
		let datePicker = UIDatePicker()
		datePicker.sizeToFit()
		datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		datePicker.datePickerMode = .dateAndTime
		datePicker.minuteInterval = 5
		startArriveDateField.inputView = datePicker
		let keyboardDoneButtonView = UIToolbar()
		keyboardDoneButtonView.barStyle = .black
		keyboardDoneButtonView.isTranslucent = true
		keyboardDoneButtonView.tintColor = nil
		keyboardDoneButtonView.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MainViewController.doneButtonTouched(_:)))
		let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(MainViewController.clearButtonTouched(_:)))
		keyboardDoneButtonView.setItems([doneButton, clearButton], animated: false)
		startArriveDateField.inputAccessoryView = keyboardDoneButtonView
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	fileprivate var directionsAPI: PXGoogleDirections {
		return (UIApplication.shared.delegate as! AppDelegate).directionsAPI
	}
	
	fileprivate func modeFromField() -> PXGoogleDirectionsMode {
		return PXGoogleDirectionsMode(rawValue: modeField.selectedSegmentIndex)!
	}
	
	fileprivate func unitFromField() -> PXGoogleDirectionsUnit {
		return PXGoogleDirectionsUnit(rawValue: unitField.selectedSegmentIndex)!
	}
	
	fileprivate func transitRoutingPreferenceFromField() -> PXGoogleDirectionsTransitRoutingPreference? {
		return PXGoogleDirectionsTransitRoutingPreference(rawValue: transitRoutingField.selectedSegmentIndex)
	}
	
	fileprivate func trafficModelFromField() -> PXGoogleDirectionsTrafficModel? {
		return PXGoogleDirectionsTrafficModel(rawValue: trafficModelField.selectedSegmentIndex)
	}
	
	fileprivate func languageFromField() -> String {
		return languageField.titleForSegment(at: languageField.selectedSegmentIndex)!
		// There are quite a few other languages available, see here for more information: https://developers.google.com/maps/faq#languagesupport
	}
	
	fileprivate func updateStartArriveDateField(_ newDate: Date?) {
		startArriveDate = newDate
		if let saDate = startArriveDate {
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .short
			startArriveDateField.text = dateFormatter.string(from: saDate)
		} else {
			startArriveDateField.text = ""
		}
	}
	
	fileprivate func updateWaypointsField() {
		switch (waypoints).count {
		case 0:
			waypointsLabel.text = "No waypoints"
		case 1:
			waypointsLabel.text = "1 waypoint"
		default:
			waypointsLabel.text = "\((waypoints).count) waypoints"
		}
	}
	
	@IBAction func advancedOptionsChanged(_ sender: UISwitch) {
		UIView.animate(withDuration: 0.5, animations: {
			self.advancedView.alpha =  (self.advancedSwitch.isOn ? 1.0 : 0.0)
		})
	}
	
	@IBAction func selectDateButtonTouched(_ sender: UIButton) {
		startArriveDateField.isEnabled = true
		startArriveDateField.becomeFirstResponder()
	}
	
	@objc func doneButtonTouched(_ sender: UIBarButtonItem) {
		updateStartArriveDateField((startArriveDateField.inputView as! UIDatePicker).date)
		startArriveDateField.resignFirstResponder()
		startArriveDateField.isEnabled = false
	}
	
	@objc func clearButtonTouched(_ sender: UIBarButtonItem) {
		updateStartArriveDateField(nil)
		startArriveDateField.resignFirstResponder()
		startArriveDateField.isEnabled = false
	}
	
	@IBAction func addWaypointButtonTouched(_ sender: UIButton) {
		if let wpvc = self.storyboard?.instantiateViewController(withIdentifier: "Waypoint") as? WaypointViewController {
			wpvc.delegate = self
			self.present(wpvc, animated: true, completion: nil)
		}
	}
	
	@IBAction func clearWaypointsButtonTouched(_ sender: UIButton) {
		waypoints.removeAll(keepingCapacity: false)
		updateWaypointsField()
	}
	
	@IBAction func goButtonTouched(_ sender: UIButton) {
		directionsAPI.delegate = self
		directionsAPI.from = PXLocation.namedLocation(originField.text!)
		directionsAPI.to = PXLocation.namedLocation(destinationField.text!)
		directionsAPI.mode = modeFromField()
		if advancedSwitch.isOn {
			directionsAPI.transitRoutingPreference = transitRoutingPreferenceFromField()
			directionsAPI.trafficModel = trafficModelFromField()
			directionsAPI.units = unitFromField()
			directionsAPI.alternatives = alternativeSwitch.isOn
			directionsAPI.transitModes = Set()
			if busSwitch.isOn {
				directionsAPI.transitModes.insert(.bus)
			}
			if subwaySwitch.isOn {
				directionsAPI.transitModes.insert(.subway)
			}
			if trainSwitch.isOn {
				directionsAPI.transitModes.insert(.train)
			}
			if tramSwitch.isOn {
				directionsAPI.transitModes.insert(.tram)
			}
			if railSwitch.isOn {
				directionsAPI.transitModes.insert(.rail)
			}
			directionsAPI.featuresToAvoid = Set()
			if avoidTollsSwitch.isOn {
				directionsAPI.featuresToAvoid.insert(.tolls)
			}
			if avoidHighwaysSwitch.isOn {
				directionsAPI.featuresToAvoid.insert(.highways)
			}
			if avoidFerriesSwitch.isOn {
				directionsAPI.featuresToAvoid.insert(.ferries)
			}
			switch startArriveField.selectedSegmentIndex {
			case 0:
				directionsAPI.departureTime = .now
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
			directionsAPI.optimizeWaypoints = optimizeWaypointsSwitch.isOn
			directionsAPI.language = languageFromField()
		} else {
			directionsAPI.transitRoutingPreference = nil
			directionsAPI.trafficModel = nil
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
			DispatchQueue.main.async(execute: { () -> Void in
				switch response {
				case let .error(_, error):
					let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.present(alert, animated: true, completion: nil)
				case let .success(request, routes):
					if let rvc = self.storyboard?.instantiateViewController(withIdentifier: "Results") as? ResultsViewController {
						rvc.request = request
						rvc.results = routes
						self.present(rvc, animated: true, completion: nil)
					}
				}
			})
		}
	}
}

extension MainViewController: PXGoogleDirectionsDelegate {
	func googleDirectionsWillSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) -> Bool {
		NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
		return true
	}
	
	func googleDirectionsDidSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) {
		NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
		NSLog("\(requestURL.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
	}
	
	func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: Data) {
		NSLog("googleDirections:didReceiveRawDataFromAPI:")
		NSLog(String(data: data, encoding: .utf8)!)
	}
	
	func googleDirectionsRequestDidFail(_ googleDirections: PXGoogleDirections, withError error: NSError) {
		NSLog("googleDirectionsRequestDidFail:withError:")
		NSLog("\(error)")
	}
	
	func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
		NSLog("googleDirections:didReceiveResponseFromAPI:")
		NSLog("Got \(apiResponse.count) routes")
		for i in 0 ..< apiResponse.count {
			NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
		}
	}
}

extension MainViewController: MainViewControllerDelegate {
	func didAddWaypoint(_ waypoint: PXLocation) {
		waypoints.append(waypoint)
		updateWaypointsField()
	}
}
