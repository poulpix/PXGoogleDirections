//
//  PXGoogleDirectionsResponse.swift
//  PXGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// An enum describing response from the Google Directions API.
public enum PXGoogleDirectionsResponse {
	/// When the API request succeeds, this enum case contains all data fetched from the Google Directions API
	case success(PXGoogleDirections, [PXGoogleDirectionsRoute])
	/// In case of an API request error, the additionnal parameter will contain the reason of the error
	case error(PXGoogleDirections, NSError)
	
	/// Returns `true` if this response indicates an error during the API request process, or `false` otherwise
	public var failed: Bool {
		switch self {
		case .error(_, _):
			return true
		default:
			return false
		}
	}
}
