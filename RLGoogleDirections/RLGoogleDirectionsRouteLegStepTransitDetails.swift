//
//  RLGoogleDirectionsRouteLegStepTransitDetails.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Transit directions return additional information that is not relevant for other modes of transportation. From a `RLGoogleDirectionsRouteLegStepTransitDetails` object it is possible to access additional information about the transit stop, transit line and transit agency.
struct RLGoogleDirectionsRouteLegStepTransitDetails {
	/// Information about the starting station for this part of the trip
	var arrivalStop: RLGoogleDirectionsStop?
	/// Information about the stop station for this part of the trip
	var departureStop: RLGoogleDirectionsStop?
	/// Arrival time for this leg of the journey
	var arrivalTime: RLGoogleDirectionsTime?
	/// Departure time for this leg of the journey
	var departureTime: RLGoogleDirectionsTime?
	/// Direction in which to travel on this line, as it is marked on the vehicle or at the departure stop (will often be the terminus station)
	var headsign: String?
	/// Expected number of seconds between departures from the same stop at this time (with a headway value of 600, a ten minute wait would be expected for someone missing his bus)
	var headway: NSTimeInterval?
	/// Number of stops in this step, counting the arrival stop, but not the departure stop (leaving from stop A, passing through stops B and C, and arriving at stop D, `nbStops` will return 3)
	var nbStops: UInt?
	/// Information about the transit line used in this step
	var line: RLGoogleDirectionsTransitLine?
}
