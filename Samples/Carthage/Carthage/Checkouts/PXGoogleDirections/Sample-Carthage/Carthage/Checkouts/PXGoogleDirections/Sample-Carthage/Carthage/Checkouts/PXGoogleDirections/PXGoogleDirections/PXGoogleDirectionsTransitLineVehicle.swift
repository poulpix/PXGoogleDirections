//
//  PXGoogleDirectionsTransitLineVehicle.swift
//  PXGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// A type of vehicle used on a specific line
public struct PXGoogleDirectionsTransitLineVehicle {
	/// The name of the vehicle on a specific line, eg. "Subway."
	public var name: String?
	/// The type of vehicle that runs on a specific line
	public var type: PXGoogleDirectionsVehicleType?
	/// An icon associated with this vehicle type
	public var icon: UIImage?
}
