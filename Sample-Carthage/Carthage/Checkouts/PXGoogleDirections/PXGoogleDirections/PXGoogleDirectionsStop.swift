//
//  PXGoogleDirectionsStop.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation

/// Information about a start/stop station for a part of a trip
public struct PXGoogleDirectionsStop {
	/// The name of the transit station/stop. eg. "Union Square"
	public var description: String?
	/// The location of the transit station/stop
	public var location: CLLocationCoordinate2D?
}
