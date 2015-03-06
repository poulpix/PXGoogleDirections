//
//  RLGoogleDirectionsTransitLineVehicle.swift
//  RLGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// A type of vehicle used on a specific line
struct RLGoogleDirectionsTransitLineVehicle {
	/// The name of the vehicle on a specific line, eg. "Subway."
	var name: String?
	/// The type of vehicle that runs on a specific line
	var type: RLGoogleDirectionsVehicleType?
	/// An icon associated with this vehicle type
	var icon: UIImage?
}
