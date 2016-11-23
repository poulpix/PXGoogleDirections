//
//  PXGoogleDirectionsRouteLegStep.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

/// A single step of the calculated directions. A step is the most atomic unit of a direction's route, containing a single step describing a specific, single instruction on the journey (e.g. "Turn left at W. 4th St."). The step not only describes the instruction but also contains distance and duration information relating to how this step relates to the following step. For example, a step denoted as "Merge onto I-80 West" may contain a duration of "37 miles" and "40 minutes," indicating that the next step is 37 miles/40 minutes from this step.
public class PXGoogleDirectionsRouteLegStep: NSObject, PXGoogleDirectionsSteppable {
	/// Formatted instructions for this step, presented as an HTML text string
	public var htmlInstructions: String?
	/// Coded instructions for this step, for use in GPS or navigation-based applications
	public var maneuver: String?
	/// Distance covered by this step until the next step
	public var distance: PXGoogleDirectionsDistance?
	/// Typical time required to perform the step, until the next step
	public var duration: PXGoogleDirectionsDuration?
	/// Location of the starting point of this step
	public var startLocation: CLLocationCoordinate2D?
	/// Location of the last point of this step,
	public var endLocation: CLLocationCoordinate2D?
	/// Holds an encoded polyline representation of the route (this polyline is an approximate/smoothed path of the resulting directions)
	public var polyline: String?
	/// Detailed directions for walking or driving steps in transit directions (only available for transit mode directions)
	public var steps: [PXGoogleDirectionsRouteLegStep] = [PXGoogleDirectionsRouteLegStep]()
	/// Travel mode for this step (e.g. walking, transit, etc.)
	public var travelMode: PXGoogleDirectionsMode?
	/// Transit-specific information (only returned with transit mode directions)
	public var transitDetails: PXGoogleDirectionsRouteLegStepTransitDetails?
	/// Returns the corresponding `GMSPath` object associated with this route step
	public var path: GMSPath? {
		if let p = polyline {
			return GMSPath(fromEncodedPath: p)
		} else {
			return nil
		}
	}
	/// Returns the coordinate bounds for this step
	public var bounds: GMSCoordinateBounds? {
		var b: GMSCoordinateBounds?
		if let p = path {
			b = GMSCoordinateBounds(path: p)
		}
		return b
	}
	/// Raw instructions for this step, derived from the HTML instructions
	public var rawInstructions: String? {
		var result = htmlInstructions
		if result != nil {
			while let r = result!.range(of: "<[^>]+>", options: .regularExpression) {
				result = result!.replacingCharacters(in: r, with: "")
			}
		}
		return result
	}
}
