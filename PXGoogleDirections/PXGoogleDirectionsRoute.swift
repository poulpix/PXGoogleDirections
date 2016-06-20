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
	/// Returns the route's total duration, in seconds
	public var totalDuration: NSTimeInterval {
		get {
			var td = 0 as NSTimeInterval
			for l in legs {
				guard let ld = l.duration, d = ld.duration else {
					break
				}
				td += d
			}
			return td
		}
	}
	/// Returns the route's total distance, in meters
	public var totalDistance: CLLocationDistance {
		get {
			var td = 0 as CLLocationDistance
			for l in legs {
				guard let ld = l.distance, d = ld.distance else {
					break
				}
				td += d
			}
			return td
		}
	}
	
	/**
	Draws the route on the specified Google Maps map view.
	
	- parameter map: A `GMSMapView` object on which the route should be drawn
	- parameter strokeColor: The optional route stroke color
	- parameter strokeWidth: The optional route stroke width
	- returns: The resulting `GMSPolyline` object that was drawn to the map
	*/
	public func drawOnMap(map: GMSMapView, strokeColor: UIColor = UIColor.redColor(), strokeWidth: Float = 2.0) -> GMSPolyline? {
		let polyline: GMSPolyline? = nil
		if let p = path {
			let polyline = GMSPolyline(path: p)
			polyline.strokeColor = strokeColor
			polyline.strokeWidth = CGFloat(strokeWidth)
			polyline.map = map
		}
		return polyline
	}
	
	/**
	Draws a marker representing the origin of the route on the specified Google Maps map view.
	
	- parameter map: A `GMSMapView` object on which the marker should be drawn
	- parameter title: An optional marker title
	- parameter color: An optional marker color
	- parameter opacity: An optional marker specific opacity
	- parameter flat: An optional indicator to flatten the marker
	- returns: The resulting `GMSMarker` object that was drawn to the map
	*/
	public func drawOriginMarkerOnMap(map: GMSMapView, title: String = "", color: UIColor = UIColor.redColor(), opacity: Float = 1.0, flat: Bool = false) -> GMSMarker? {
		var marker: GMSMarker?
		if let p = path {
			if p.count() > 1 {
				marker = drawMarkerWithCoordinates(p.coordinateAtIndex(0), onMap: map, title: title, color: color, opacity: opacity, flat: flat)
			}
		}
		return marker
	}
	
	/**
	Draws a marker representing the destination of the route on the specified Google Maps map view.
	
	- parameter map: A `GMSMapView` object on which the marker should be drawn
	- parameter title: An optional marker title
	- parameter color: An optional marker color
	- parameter opacity: An optional marker specific opacity
	- parameter flat: An optional indicator to flatten the marker
	- returns: The resulting `GMSMarker` object that was drawn to the map
	*/
	public func drawDestinationMarkerOnMap(map: GMSMapView, title: String = "", color: UIColor = UIColor.redColor(), opacity: Float = 1.0, flat: Bool = false) -> GMSMarker? {
		var marker: GMSMarker?
		if let p = path {
			if p.count() > 1 {
				marker = drawMarkerWithCoordinates(p.coordinateAtIndex(p.count() - 1), onMap: map, title: title, color: color, opacity: opacity, flat: flat)
			}
		}
		return marker
	}
	
	// MARK: Private functions

	private func drawMarkerWithCoordinates(coordinates: CLLocationCoordinate2D, onMap map: GMSMapView, title: String = "", color: UIColor = UIColor.redColor(), opacity: Float = 1.0, flat: Bool = false) -> GMSMarker {
		let marker = GMSMarker(position: coordinates)
		marker.title = title
		marker.icon = GMSMarker.markerImageWithColor(color)
		marker.opacity = opacity
		marker.flat = flat
		marker.map = map
		return marker
	}
}
