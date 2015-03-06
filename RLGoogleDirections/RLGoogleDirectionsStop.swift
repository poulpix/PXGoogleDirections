//
//  RLGoogleDirectionsStop.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Information about a start/stop station for a part of a trip
struct RLGoogleDirectionsStop {
	/// The name of the transit station/stop. eg. "Union Square"
	var description: String?
	/// The location of the transit station/stop
	var location: CLLocationCoordinate2D?
}
