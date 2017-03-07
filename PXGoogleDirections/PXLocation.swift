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
	case coordinateLocation(CLLocationCoordinate2D)
	/// Specifies a location by name, city and/or country
	case specificLocation(String?, String?, String?)
	/// Specifies a location by a single string address
	case namedLocation(String)
	
	fileprivate var centerCoordinate: CLLocationCoordinate2D? {
		switch self {
		case let .coordinateLocation(loc):
			return loc
		default:
			return nil
		}
	}
	
	/**
	Returns `true` if a location is indeed specifically defined.
	
	- returns: `true` if the object holds a specific location, `false` otherwise
	*/
	public func isSpecified() -> Bool {
		switch self {
		case let .specificLocation(address, city, country):
			return (address ?? "").characters.count > 0 || (city ?? "").characters.count > 0 || (country ?? "").characters.count > 0
		case let .namedLocation(address):
			return address.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0
		default:
			return true
		}
	}
	
	/**
	Tries to open the selected location in the Google Maps app.
	
	- parameter mapMode: the kind of map shown (if not specified, the current application settings will be used)
	- parameter view: turns specific views on/off, multiple values can be set using a comma-separator (if the parameter is specified with no value, then it will clear all views)
	- parameter zoom: specifies the zoom level of the map
	- parameter callbackURL: the URL to call when complete ; often this will be a URL scheme allowing users to return to the original application
	- parameter callbackName: the name of the application sending the callback request (short names are preferred)
	- parameter fallbackToAppleMaps: `true` to fall back to Apple Maps in case Google Maps is not installed, `false` otherwise
	- returns: `true` if opening in the Google Maps is available, `false` otherwise
	*/
	public func openInGoogleMaps(mapMode: PXGoogleMapsMode?, view: Set<PXGoogleMapsView>?, zoom: UInt?, callbackURL: URL?, callbackName: String?, fallbackToAppleMaps: Bool = true) -> Bool {
		// Prepare the base URL parameters with provided arguments
		let params = PXGoogleDirections.handleGoogleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
		// Build the Google Maps URL and open it
		if let url = PXGoogleDirections.buildGoogleMapsURL(params: params, callbackURL: callbackURL, callbackName: callbackName) {
			UIApplication.shared.openURL(url)
			return true
		} else {
			// Apply fallback strategy
			if fallbackToAppleMaps {
				let params = PXGoogleDirections.handleAppleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
				let p = (params.count > 0) ? "?" + params.joined(separator: "&") : ""
				UIApplication.shared.openURL(URL(string: "https://maps.apple.com/\(p)")!)
				return true
			}
		}
		return false
	}
	
	/**
	Tries to launch the Google Maps app and searches for the specified query.
	
	- parameter query: the search query string
	- parameter mapMode: the kind of map shown (if not specified, the current application settings will be used)
	- parameter view: turns specific views on/off, multiple values can be set using a comma-separator (if the parameter is specified with no value, then it will clear all views)
	- parameter zoom: specifies the zoom level of the map
	- parameter callbackURL: the URL to call when complete ; often this will be a URL scheme allowing users to return to the original application
	- parameter callbackName: the name of the application sending the callback request (short names are preferred)
	- parameter fallbackToAppleMaps: `true` to fall back to Apple Maps in case Google Maps is not installed, `false` otherwise
	- returns: `true` if opening in the Google Maps is available, `false` otherwise
	*/
	public func searchInGoogleMaps(_ query: String, mapMode: PXGoogleMapsMode?, view: Set<PXGoogleMapsView>?, zoom: UInt?, callbackURL: URL?, callbackName: String?, fallbackToAppleMaps: Bool = true) -> Bool {
		// Prepare the base URL parameters with provided arguments
		var params = PXGoogleDirections.handleGoogleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
		// Add the query string
		params.append("q=\(query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
		// Build the Google Maps URL and open it
		if let url = PXGoogleDirections.buildGoogleMapsURL(params: params, callbackURL: callbackURL, callbackName: callbackName) {
			UIApplication.shared.openURL(url)
			return true
		} else {
			// Apply fallback strategy
			if fallbackToAppleMaps {
				var params = PXGoogleDirections.handleAppleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
				params.append("q=\(query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
				let p = (params.count > 0) ? "?" + params.joined(separator: "&") : ""
				UIApplication.shared.openURL(URL(string: "https://maps.apple.com/\(p)")!)
				return true
			}
		}
		return false
	}
}

extension PXLocation: CustomStringConvertible {
	public var description: String {
		switch (self) {
		case let .coordinateLocation(coords):
			return "\(coords.latitude),\(coords.longitude)"
		case let .specificLocation(name, city, country):
			var locationFullName = ""
			if let n = name {
				locationFullName = n
			}
			if let c = city {
				let separator = (locationFullName.lengthOfBytes(using: String.Encoding.utf8) > 0) ? "," : ""
				locationFullName += "\(separator)\(c)"
			}
			if let c = country {
				let separator = (locationFullName.lengthOfBytes(using: String.Encoding.utf8) > 0) ? "," : ""
				locationFullName += "\(separator)\(c)"
			}
			return locationFullName
		case let .namedLocation(address):
			return address
		}
	}
}
