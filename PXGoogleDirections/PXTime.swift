//
//  PXTime.swift
//  PXGoogleDirections
//
//  Created by Romain on 02/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Specifies a departure or arrival time, either "now", or at a specific timestamp
public enum PXTime {
	/// Indicates a departure time to the current time (correct to the nearest second)
	case now
	/// Departure or arrival time, in seconds since midnight, January 1, 1970 UTC
	case timestamp(TimeInterval)
	
	/**
	Creates an `PXTime` instance suitable for a departure or arrival time in a Google Directions API request.
	
	- parameter date: An `NSDate` to be used as a departure or arrival time
	- returns: the `PXTime` to be used directly in a Google Directions API request
	*/
	public static func timeFromDate(_ date: Date) -> PXTime {
		return .timestamp(date.timeIntervalSince1970)
	}
}

extension PXTime: CustomStringConvertible {
	public var description: String {
		switch (self) {
		case .now:
			return "now"
		case let .timestamp(timestamp):
			return "\(UInt(timestamp))"
		}
	}
}

extension PXTime: Equatable {
}

public func ==(lhs: PXTime, rhs: PXTime) -> Bool {
	switch (lhs, rhs) {
	case (.now, .now):
		return true
	case (.timestamp(let ts1), .timestamp(let ts2)):
		return ts1 == ts2
	default:
		return false
	}
}
