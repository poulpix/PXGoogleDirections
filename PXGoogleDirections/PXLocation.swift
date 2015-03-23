//
//  PXLocation.swift
//  PXGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation

/// Specifies a location, either by coordinates or by name
public enum PXLocation {
	/// Specifies a location by latitude and longitude coordinates
	case CoordinateLocation(CLLocationCoordinate2D)
	/// Specifies a location by name, city and/or country
	case SpecificLocation(String?, String?, String?)
	/// Specifies a location by a single string address
	case NamedLocation(String)
	
	/**
	Returns `true` if a location is indeed specifically defined.
	
	:returns: `true` if the object holds a specific location, `false` otherwise
	*/
	public func isSpecified() -> Bool {
		switch self {
		case let .SpecificLocation(address, city, country):
			return count(address ?? "") > 0 || count(city ?? "") > 0 || count(country ?? "") > 0
		case let .NamedLocation(address):
			return count(address.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) > 0
		default:
			return true
		}
	}
}

extension PXLocation: Printable {
	public var description: String {
		switch (self) {
		case let .CoordinateLocation(coords):
			return "\(coords.latitude),\(coords.longitude)"
		case let .SpecificLocation(name, city, country):
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
		case let .NamedLocation(address):
			return address
		}
	}
}
