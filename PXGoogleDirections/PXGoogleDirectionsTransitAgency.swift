//
//  PXGoogleDirectionsTransitAgency.swift
//  PXGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Contains information about the operator of a transit line
public struct PXGoogleDirectionsTransitAgency {
	/// The name of the transit agency
	public var name: String?
	/// The URL for the transit agency
	public var url: URL?
	/// The phone number of the transit agency
	public var phone: String?
}
