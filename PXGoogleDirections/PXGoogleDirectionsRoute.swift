//
//  PXGoogleDirectionsRoute.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import GoogleMaps

/// A route computed by the Google Directions API, following a directions request. A route consists of nested legs and steps.
public class PXGoogleDirectionsRoute: NSObject {
	/// Short textual description for the route, suitable for naming and disambiguating the route from alternatives
	public var summary: String?
	/// Array which contains information about a leg of the route, between two locations within the given route (a separate leg will be present for each waypoint or destination specified: a route with no waypoints will contain exactly one leg within the legs array) ; each leg consists of a series of steps
	public var legs: [PXGoogleDirectionsRouteLeg] = [PXGoogleDirectionsRouteLeg]()
	/// Array indicating the order of any waypoints in the calculated route (waypoints may be reordered if the request was passed optimize:true within its waypoints parameter)
	public var waypointsOrder: [Int] = [Int]()
	/// Holds an encoded polyline representation of the route (this polyline is an approximate/smoothed path of the resulting directions)
	public var overviewPolyline: String?
	/// Viewport bounding box of the `overviewPolyline`
	public var bounds: GMSCoordinateBounds?
	/// Copyrights text to be displayed for this route
	public var copyrights: String?
	/// Array of warnings to be displayed when showing these directions
	public var warnings: [String] = [String]()
	/// Contains the total fare (that is, the total ticket costs) on this route (only valid for transit requests and routes where fare information is available for all transit legs)
	public var fare: PXGoogleDirectionsRouteFare?
	/// Returns the corresponding `GMSPath` object associated with this route
	public var path: GMSPath? {
		if let op = overviewPolyline {
			return GMSPath(fromEncodedPath: op)
		} else {
			return nil
		}
	}
}
