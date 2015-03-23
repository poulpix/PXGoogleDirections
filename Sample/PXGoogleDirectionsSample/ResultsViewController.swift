//
//  ResultsViewController.swift
//  PXGoogleDirectionsSample
//
//  Created by Romain on 21/03/2015.
//  Copyright (c) 2015 Poulpix. All rights reserved.
//

import GoogleMaps
import UIKit
import PXGoogleDirections

class ResultsViewController: UIViewController {
	@IBOutlet weak var prevButton: UIButton!
	@IBOutlet weak var routesLabel: UILabel!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var directions: UITableView!
	var results: [PXGoogleDirectionsRoute]!
	var routeIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		updateRoute()
	}
	
	@IBAction func previousButtonTouched(sender: UIButton) {
		routeIndex -= 1
		updateRoute()
	}

	@IBAction func nextButtonTouched(sender: UIButton) {
		routeIndex += 1
		updateRoute()
	}
	
	@IBAction func closeButtonTouched(sender: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func updateRoute() {
		prevButton.enabled = (routeIndex > 0)
		nextButton.enabled = (routeIndex < count(results) - 1)
		routesLabel.text = "\(routeIndex + 1) of \(count(results))"
		mapView.clear()
		for i in 0 ..< count(results) {
			if i != routeIndex {
				results[i].drawOnMap(mapView, strokeColor: UIColor.lightGrayColor(), strokeWidth: 3.0)
			}
		}
		mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(results[routeIndex].bounds, withPadding: 40.0))
		results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.purpleColor(), strokeWidth: 4.0)
		results[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.greenColor(), opacity: 1.0, flat: true)
		results[routeIndex].drawDestinationMarkerOnMap(mapView, title: "Destination", color: UIColor.redColor(), opacity: 1.0, flat: true)
		directions.reloadData()
	}
}

extension ResultsViewController: GMSMapViewDelegate {
}

extension ResultsViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return count(results[routeIndex].legs)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return count(results[routeIndex].legs[section].steps)
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let leg = results[routeIndex].legs[section]
		if let dist = leg.distance?.description, dur = leg.duration?.description {
			return "Step \(section + 1) (\(dist), \(dur))"
		} else {
			return "Step \(section + 1)"
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("RouteStep") as? UITableViewCell
		if (cell == nil) {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "RouteStep")
		}
		let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
		if let instr = step.rawInstructions {
			cell!.textLabel!.text = instr
		}
		if let dist = step.distance?.description, dur = step.duration?.description {
			cell!.detailTextLabel?.text = "\(dist), \(dur)"
		}
		return cell!
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
		mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(step.bounds, withPadding: 40.0))
	}
	
	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
		let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
		var msg: String
		if let m = step.maneuver {
			msg = "\(step.rawInstructions!)\nGPS instruction: \(m)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
		} else {
			msg = "\(step.rawInstructions!)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
		}
		var alert = UIAlertController(title: "PXGoogleDirectionsSample", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
	}
}

extension ResultsViewController: UITableViewDelegate {
}
