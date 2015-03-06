//
//  RLGoogleDirectionsResponse.swift
//  RLGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// An enum describing response from the Google Directions API.
enum RLGoogleDirectionsResponse {
	/// When the API request succeeds, this enum case contains all data fetched from the Google Directions API
	case Success([RLGoogleDirectionsRoute])
	/// In case of an API request error, the `String` value will contain the reason of the error
	case Error(String)
	
	/// Returns `true` if this response indicates an error during the API request process, or `false` otherwise
	var failed: Bool {
		switch self {
		case .Error(let error):
			return true
		default:
			return false
		}
	}
}
