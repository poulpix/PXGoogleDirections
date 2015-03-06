//
//  RLLocation.swift
//  RLGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Specifies a location, either by coordinates or by name
enum RLLocation {
	/// Specifies a location by latitude and longitude coordinates
	case CoordinateLocation(CLLocationCoordinate2D)
	/// Specifies a location by name, city and/or country
	case NamedLocation(String?, String?, String?)
}

extension RLLocation: Printable {
	var description: String {
		switch (self) {
		case let .CoordinateLocation(coords):
			return "\(coords.latitude),\(coords.longitude)"
		case let .NamedLocation(name, city, country):
			var locationFullName = ""
			if let n = name {
				locationFullName = n
			}
			if let c = city {
				let separator = (locationFullName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) ? "," : ""
				locationFullName += "\(separator)\(c)"
			}
			if let c = country {
				let separator = (locationFullName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) ? "," : ""
				locationFullName += "\(separator)\(c)"
			}
			return locationFullName
		}
	}
}
