//
//  PXGoogleDirectionsRouteLeg.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

/// A single leg of the journey from the origin to the destination in the calculated route.
public struct PXGoogleDirectionsRouteLeg: PXGoogleDirectionsSteppable {
	/// Array of steps denoting information about each separate step of the leg of the journey
	public var steps: [PXGoogleDirectionsRouteLegStep] = [PXGoogleDirectionsRouteLegStep]()
	/// The total distance covered by this leg
	public var distance: PXGoogleDirectionsDistance?
	/// The total duration of this leg
	public var duration: PXGoogleDirectionsDuration?
	/// The total duration of this leg, taking into account current traffic conditions (the duration in traffic will only be returned if the directions request includes a departure_time parameter set to a value within a few minutes of the current time, traffic conditions are available for the requested route, and the directions request does not include stopover waypoints)
	public var durationInTraffic: PXGoogleDirectionsDuration?
	/// Estimated time of arrival for this leg (only available for transit directions)
	public var arrivalTime: PXGoogleDirectionsTime?
	/// Estimated time of departure for this leg (only available for transit directions)
	public var departureTime: PXGoogleDirectionsTime?
	/// Latitude/longitude coordinates of the origin of this leg (because the API calculates directions between locations by using the nearest transportation option - usually a road - at the start and end points, `startLocation` may be different than the provided origin of this leg if, for example, a road is not near the origin)
	public var startLocation: CLLocationCoordinate2D?
	/// Latitude/longitude coordinates of the origin of this leg (because the API calculates directions between locations by using the nearest transportation option - usually a road - at the start and end points, `endLocation` may be different than the provided destination of this leg if, for example, a road is not near the origin)
	public var endLocation: CLLocationCoordinate2D?
	/// Human-readable address (typically a street address) reflecting the `startLocation` of this leg
	public var startAddress: String?
	/// Human-readable address (typically a street address) reflecting the `endLocation` of this leg
	public var endAddress: String?
	/// Returns a detailed `GMSPath` object built from the legs and steps composing the route
	public var detailedPath: GMSPath? {
		let dp = GMSMutablePath()
		for s in steps {
			if let sl = s.startLocation {
				dp.add(sl)
			}
			if let spl = s.polyline, let subpath = GMSPath(fromEncodedPath: spl) {
				for i in 0 ..< subpath.count() {
					dp.add(subpath.coordinate(at: i))
				}
			}
			if let el = s.endLocation {
				dp.add(el)
			}
		}
		return (dp.count() > 0 ? dp : nil)
	}
}
