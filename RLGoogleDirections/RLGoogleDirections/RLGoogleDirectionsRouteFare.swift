//
//  RLGoogleDirectionsRouteFare.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// The total fare (that is, the total ticket costs) of a transit route
struct RLGoogleDirectionsRouteFare {
	/// An ISO 4217 currency code indicating the currency that the amount is expressed in
	var currency: String?
	/// The total fare amount, in the currency specified above
	var value: Double?
}

extension RLGoogleDirectionsRouteFare: Printable {
	var description: String {
		return "\(currency) \(value)"
	}
}
