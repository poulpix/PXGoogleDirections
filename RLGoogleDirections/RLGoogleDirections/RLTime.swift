//
//  RLTime.swift
//  RLGoogleDirections
//
//  Created by Romain on 02/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Specifies a departure or arrival time, either "now", or at a specific timestamp
enum RLTime {
	/// Indicates a departure time to the current time (correct to the nearest second)
	case Now
	/// Departure or arrival time, in seconds since midnight, January 1, 1970 UTC
	case Timestamp(NSTimeInterval)
	
	/**
	Creates an `RLTime` instance suitable for a departure or arrival time in a Google Directions API request.
	
	:param: date An `NSDate` to be used as a departure or arrival time
	:returns: the `RLTime` to be used directly in a Google Directions API request
	*/
	static func timeFromDate(date: NSDate) -> RLTime {
		return .Timestamp(date.timeIntervalSince1970)
	}
}

extension RLTime: Printable {
	var description: String {
		switch (self) {
		case .Now:
			return "now"
		case let .Timestamp(timestamp):
			return "\(UInt(timestamp))"
		}
	}
}

extension RLTime: Equatable {
}

func ==(lhs: RLTime, rhs: RLTime) -> Bool {
	switch (lhs, rhs) {
	case (.Now, .Now):
		return true
	case (.Timestamp(let ts1), .Timestamp(let ts2)):
		return ts1 == ts2
	default:
		return false
	}
}
