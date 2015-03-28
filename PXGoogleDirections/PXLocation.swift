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
	
	private var centerCoordinate: CLLocationCoordinate2D? {
		switch self {
		case let .CoordinateLocation(loc):
			return loc
		default:
			return nil
		}
	}
	
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
	
	/**
	Tries to open the selected location in the Google Maps app.
	
	:param: mapMode the kind of map shown (if not specified, the current application settings will be used)
	:param: view turns specific views on/off, multiple values can be set using a comma-separator (if the parameter is specified with no value, then it will clear all views)
	:param: zoom specifies the zoom level of the map
	:param: callbackURL the URL to call when complete ; often this will be a URL scheme allowing users to return to the original application
	:param: callbackName the name of the application sending the callback request (short names are preferred)
	:returns: `true` if opening in the Google Maps is available, `false` otherwise
	*/
	public func openInGoogleMaps(#mapMode: PXGoogleMapsMode?, view: Set<PXGoogleMapsView>?, zoom: UInt?, callbackURL: NSURL?, callbackName: String?) -> Bool {
		// Prepare the base URL parameters with provided arguments
		let params = PXGoogleDirections.handleGoogleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
		// Build the Google Maps URL and open it
		if let url = PXGoogleDirections.buildGoogleMapsURL(params: params, callbackURL: callbackURL, callbackName: callbackName) {
			UIApplication.sharedApplication().openURL(url)
			return true
		}
		return false
	}
	
	/**
	Tries to launch the Google Maps app and searches for the specified query.
	
	:param: query the search query string
	:param: mapMode the kind of map shown (if not specified, the current application settings will be used)
	:param: view turns specific views on/off, multiple values can be set using a comma-separator (if the parameter is specified with no value, then it will clear all views)
	:param: zoom specifies the zoom level of the map
	:param: callbackURL the URL to call when complete ; often this will be a URL scheme allowing users to return to the original application
	:param: callbackName the name of the application sending the callback request (short names are preferred)
	:returns: `true` if opening in the Google Maps is available, `false` otherwise
	*/
	public func searchInGoogleMaps(query: String, mapMode: PXGoogleMapsMode?, view: Set<PXGoogleMapsView>?, zoom: UInt?, callbackURL: NSURL?, callbackName: String?) -> Bool {
		// Prepare the base URL parameters with provided arguments
		var params = PXGoogleDirections.handleGoogleMapsURL(center: centerCoordinate, mapMode: mapMode, view: view, zoom: zoom)
		// Add the query string
		params.append("q=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))")
		// Build the Google Maps URL and open it
		if let url = PXGoogleDirections.buildGoogleMapsURL(params: params, callbackURL: callbackURL, callbackName: callbackName) {
			UIApplication.sharedApplication().openURL(url)
			return true
		}
		return false
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
