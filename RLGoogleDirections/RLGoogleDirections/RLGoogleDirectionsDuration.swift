//
//  RLGoogleDirectionsDuration.swift
//  RLGoogleDirections
//
//  Created by Romain on 04/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// The total duration of a route leg
struct RLGoogleDirectionsDuration {
	/// The duration in seconds
	var duration: NSTimeInterval?
	/// A human-readable representation of the duration
	var description: String?
}
