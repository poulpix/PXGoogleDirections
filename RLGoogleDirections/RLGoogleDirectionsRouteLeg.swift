//
//  RLGoogleDirectionsRouteLeg.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation

/// A single leg of the journey from the origin to the destination in the calculated route.
struct RLGoogleDirectionsRouteLeg: RLGoogleDirectionsSteppable {
	/// Array of steps denoting information about each separate step of the leg of the journey
	var steps: [RLGoogleDirectionsRouteLegStep] = [RLGoogleDirectionsRouteLegStep]()
	/// The total distance covered by this leg
	var distance: RLGoogleDirectionsDistance?
	/// The total duration of this leg
	var duration: RLGoogleDirectionsDuration?
	/// The total duration of this leg, taking into account current traffic conditions (the duration in traffic will only be returned if the directions request includes a departure_time parameter set to a value within a few minutes of the current time, traffic conditions are available for the requested route, and the directions request does not include stopover waypoints)
	var durationInTraffic: RLGoogleDirectionsDuration?
	/// Estimated time of arrival for this leg (only available for transit directions)
	var arrivalTime: RLGoogleDirectionsTime?
	/// Estimated time of departure for this leg (only available for transit directions)
	var departureTime: RLGoogleDirectionsTime?
	/// Latitude/longitude coordinates of the origin of this leg (because the API calculates directions between locations by using the nearest transportation option - usually a road - at the start and end points, `startLocation` may be different than the provided origin of this leg if, for example, a road is not near the origin)
	var startLocation: CLLocationCoordinate2D?
	/// Latitude/longitude coordinates of the origin of this leg (because the API calculates directions between locations by using the nearest transportation option - usually a road - at the start and end points, `endLocation` may be different than the provided destination of this leg if, for example, a road is not near the origin)
	var endLocation: CLLocationCoordinate2D?
	/// Human-readable address (typically a street address) reflecting the `startLocation` of this leg
	var startAddress: String?
	/// Human-readable address (typically a street address) reflecting the `endLocation` of this leg
	var endAddress: String?
}
