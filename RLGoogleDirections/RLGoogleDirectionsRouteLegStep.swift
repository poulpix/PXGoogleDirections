//
//  RLGoogleDirectionsRouteLegStep.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// A single step of the calculated directions. A step is the most atomic unit of a direction's route, containing a single step describing a specific, single instruction on the journey (e.g. "Turn left at W. 4th St."). The step not only describes the instruction but also contains distance and duration information relating to how this step relates to the following step. For example, a step denoted as "Merge onto I-80 West" may contain a duration of "37 miles" and "40 minutes," indicating that the next step is 37 miles/40 minutes from this step.
class RLGoogleDirectionsRouteLegStep: NSObject, RLGoogleDirectionsSteppable {
	/// Formatted instructions for this step, presented as an HTML text string
	var htmlInstructions: String?
	/// Coded instructions for this step, for use in GPS or navigation-based applications
	var maneuver: String?
	/// Distance covered by this step until the next step
	var distance: RLGoogleDirectionsDistance?
	/// Typical time required to perform the step, until the next step
	var duration: RLGoogleDirectionsDuration?
	/// Location of the starting point of this step
	var startLocation: CLLocationCoordinate2D?
	/// Location of the last point of this step,
	var endLocation: CLLocationCoordinate2D?
	/// Holds an encoded polyline representation of the route (this polyline is an approximate/smoothed path of the resulting directions)
	var polyline: String?
	/// Detailed directions for walking or driving steps in transit directions (only available for transit mode directions)
	var steps: [RLGoogleDirectionsRouteLegStep] = [RLGoogleDirectionsRouteLegStep]()
	/// Travel mode for this step (e.g. walking, transit, etc.)
	var travelMode: RLGoogleDirectionsMode?
	/// Transit-specific information (only returned with transit mode directions)
	var transitDetails: RLGoogleDirectionsRouteLegStepTransitDetails?
	/// Returns the corresponding `GMSPath` object associated with this route step
	var path: GMSPath? {
		if let p = polyline {
			return GMSPath(fromEncodedPath: p)
		} else {
			return nil
		}
	}
}
