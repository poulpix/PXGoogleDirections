//
//  PXGoogleDirectionsTime.swift
//  PXGoogleDirections
//
//  Created by Romain on 06/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Estimated time of departure or arrival for a specified route leg
public struct PXGoogleDirectionsTime {
	/// The time specified as a string (displayed in the time zone of the transit stop)
	public var description: String?
	/// The time zone of this station
	public var timeZone: TimeZone?
	/// The time specified as a timestamp
	public var timestamp: TimeInterval?
	/// The time as a regular `NSDate` object
	public var date: Date? {
		if let ts = timestamp {
			return Date(timeIntervalSince1970: ts)
		} else {
			return nil
		}
	}
}
