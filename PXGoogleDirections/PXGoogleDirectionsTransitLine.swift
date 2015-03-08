//
//  PXGoogleDirectionsTransitLine.swift
//  PXGoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Vontains information about the transit line used in a route step
public struct PXGoogleDirectionsTransitLine {
	/// The full name of this transit line. eg. "7 Avenue Express"
	public var name: String?
	/// The short name of this transit line (normally a line number, such as "M7" or "355")
	public var shortName: String?
	/// The color commonly used in signage for this transit line
	public var color: UIColor?
	/// An array of `PXGoogleDirectionsTransitAgency` objects that each provide information about the operator of the line
	public var agencies: [PXGoogleDirectionsTransitAgency] = [PXGoogleDirectionsTransitAgency]()
	/// The URL for this transit line as provided by the transit agency
	public var url: NSURL?
	/// The icon associated with this line
	public var icon: UIImage?
	/// The color of text commonly used for signage of this line
	public var textColor: UIColor?
	/// The type of vehicle used on this line
	public var vehicle: PXGoogleDirectionsTransitLineVehicle?
}
