//
//  RLGoogleDirectionsTransitLine.swift
//  RLGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Vontains information about the transit line used in a route step
struct RLGoogleDirectionsTransitLine {
	/// The full name of this transit line. eg. "7 Avenue Express"
	var name: String?
	/// The short name of this transit line (normally a line number, such as "M7" or "355")
	var shortName: String?
	/// The color commonly used in signage for this transit line
	var color: UIColor?
	/// An array of `RLGoogleDirectionsTransitAgency` objects that each provide information about the operator of the line
	var agencies: [RLGoogleDirectionsTransitAgency] = [RLGoogleDirectionsTransitAgency]()
	/// The URL for this transit line as provided by the transit agency
	var url: NSURL?
	/// The icon associated with this line
	var icon: UIImage?
	/// The color of text commonly used for signage of this line
	var textColor: UIColor?
	/// The type of vehicle used on this line
	var vehicle: RLGoogleDirectionsTransitLineVehicle?
}
