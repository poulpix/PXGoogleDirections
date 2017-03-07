//
//  PXGoogleDirectionsRouteFare.swift
//  PXGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// The total fare (that is, the total ticket costs) of a transit route
public struct PXGoogleDirectionsRouteFare {
	/// An ISO 4217 currency code indicating the currency that the amount is expressed in
	public var currency: String?
	/// The total fare amount, in the currency specified above
	public var value: Double?
}

extension PXGoogleDirectionsRouteFare: CustomStringConvertible {
	public var description: String {
		return "\(currency) \(value)"
	}
}
