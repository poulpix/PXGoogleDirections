//
//  RLGoogleDirectionsTransitAgency.swift
//  RLGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Contains information about the operator of a transit line
struct RLGoogleDirectionsTransitAgency {
	/// The name of the transit agency
	var name: String?
	/// The URL for the transit agency
	var url: NSURL?
	/// The phone number of the transit agency
	var phone: String?
}
