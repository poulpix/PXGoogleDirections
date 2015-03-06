//
//  RLGoogleDirectionsRoute.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// A route computed by the Google Directions API, following a directions request. A route consists of nested legs and steps.
class RLGoogleDirectionsRoute: NSObject {
	/// Short textual description for the route, suitable for naming and disambiguating the route from alternatives
	var summary: String?
	/// Array which contains information about a leg of the route, between two locations within the given route (a separate leg will be present for each waypoint or destination specified: a route with no waypoints will contain exactly one leg within the legs array) ; each leg consists of a series of steps
	var legs: [RLGoogleDirectionsRouteLeg] = [RLGoogleDirectionsRouteLeg]()
	/// Array indicating the order of any waypoints in the calculated route (waypoints may be reordered if the request was passed optimize:true within its waypoints parameter)
	var waypointsOrder: [Int] = [Int]()
	/// Holds an encoded polyline representation of the route (this polyline is an approximate/smoothed path of the resulting directions)
	var overviewPolyline: String?
	/// Viewport bounding box of the `overviewPolyline`
	var bounds: GMSCoordinateBounds?
	/// Copyrights text to be displayed for this route
	var copyrights: String?
	/// Array of warnings to be displayed when showing these directions
	var warnings: [String] = [String]()
	/// Contains the total fare (that is, the total ticket costs) on this route (only valid for transit requests and routes where fare information is available for all transit legs)
	var fare: RLGoogleDirectionsRouteFare?
	/// Returns the corresponding `GMSPath` object associated with this route
	var path: GMSPath? {
		if let op = overviewPolyline {
			return GMSPath(fromEncodedPath: op)
		} else {
			return nil
		}
	}
}
