//
//  RLGoogleDirectionsTime.swift
//  RLGoogleDirections
//
//  Created by Romain on 06/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Estimated time of departure or arrival for a specified route leg
struct RLGoogleDirectionsTime {
	/// The time specified as a string (displayed in the time zone of the transit stop)
	var description: String?
	/// The time zone of this station
	var timeZone: NSTimeZone?
	/// The time specified as a timestamp
	var timestamp: NSTimeInterval?
	/// The time as a regular `NSDate` object
	var date: NSDate? {
		if let ts = timestamp {
			return NSDate(timeIntervalSince1970: ts)
		} else {
			return nil
		}
	}
}
