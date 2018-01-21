//
//  PXGoogleDirectionsDistance.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation

/// The total distance covered by a route leg
public struct PXGoogleDirectionsDistance {
	/// Indicates the distance in meters
	public var distance: CLLocationDistance?
	/// Human-readable representation of the distance, displayed in units as used at the origin (or as overridden within the units parameter in the request)
	public var description: String?
}
