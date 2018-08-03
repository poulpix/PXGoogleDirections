//
//  PXGoogleDirectionsEnums.swift
//  PXGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

/// Possible error codes in the Google Directions API
public enum PXGoogleDirectionsError: Int {
	/// Indicates the response contains a valid result
	case ok = 0
	/// Indicates at least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded
	case notFound
	/// Indicates no route could be found between the origin and destination
	case zeroResults
	/// Indicates that too many waypoints were provided in the request (the maximum allowed waypoints is 8, plus the origin, and destination)
	case maxWaypointsExceeded
	/// Indicates that the provided request was invalid. Common causes of this status include an invalid parameter or parameter value
	case invalidRequest
	/// Indicates the service has received too many requests from this application within the allowed time period
	case overQueryLimit
	/// Indicates that the service denied use of the directions service by this application
	case requestDenied
	/// Indicates a directions request could not be processed due to a server error (may succeed with an other attempt)
	case unknownError
	/// Indicates the inability to generate a valid request URL
	case badAPIURL
	/// Indicates the inability to parse JSON data returned from the API
	case badJSONFormatting
	/// Indicates the response status code was unexpectedly missing from the JSON data
	case missingStatusCode

	public var description: String {
		switch self {
		case .ok:
			return "OK"
		case .notFound:
			return "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded"
		case .zeroResults:
			return "No route could be found between the specified origin and destination"
		case .maxWaypointsExceeded:
			return "Too many waypointss were provided in the request"
		case .invalidRequest:
			return "The provided request was invalid"
		case .overQueryLimit:
			return "The service has received too many requests from this application within the allowed time period"
		case .requestDenied:
			return "The service denied use of the directions service by this application"
		case .unknownError:
			return "The directions request could not be processed due to a server error"
		case .badAPIURL:
			return "Unable to build a suitable URL for API request"
		case .badJSONFormatting:
			return "Unable to parse JSON data returned from the API"
		case .missingStatusCode:
			return "Response status code unexpectedly missing from the response payload"
		}
	}

	/**
	Returns an `PXGoogleDirectionsError` object corresponding to the status code returned by the API for a specific response.

	- parameter status: The status code returned by the API
	- returns: The corresponding `PXGoogleDirectionsError` instance
	*/
	static func errorFromStatus(_ status: String) -> PXGoogleDirectionsError {
		switch (status) {
		case "OK":
			return .ok
		case "NOT_FOUND":
			return .notFound
		case "ZERO_RESULTS":
			return .zeroResults
		case "MAX_WAYPOINTS_EXCEEDED":
			return .maxWaypointsExceeded
		case "INVALID_REQUEST":
			return .invalidRequest
		case "OVER_QUERY_LIMIT":
			return .overQueryLimit
		case "REQUEST_DENIED":
			return .requestDenied
		case "UNKNOWN_ERROR":
			return .unknownError
		default:
			return .unknownError
		}
	}

	/// Returns `true` if this status code indicates an error during the API request process, or `false` otherwise
	public var failed: Bool { return (self != .ok) }
}

/// The mode of transport used when calculating directions
public enum PXGoogleDirectionsMode: Int {
	/// Caclulate directions by car/automobile
	case driving = 0
	/// Calculate directions by walk
	case walking
	/// Calculate directions by bicycle
	case bicycling
	/// Calculate directions with public transports
	case transit

	/**
	Returns an `PXGoogleDirectionsMode` object corresponding to the status code returned by the API for a specific response.

	- parameter label: The label returned by the API
	- returns: The corresponding `PXGoogleDirectionsMode` instance, or `nil` if no appropriate mode is found
	*/
	public static func modeFromLabel(_ label: String) -> PXGoogleDirectionsMode? {
		switch label {
		case "DRIVING":
			return .driving
		case "WALKING":
			return .walking
		case "BICYCLING":
			return .bicycling
		case "TRANSIT":
			return .transit
		default:
			return nil
		}
	}
}

extension PXGoogleDirectionsMode: CustomStringConvertible {
	public var description: String {
		switch self {
		case .driving:
			return "driving"
		case .walking:
			return "walking"
		case .bicycling:
			return "bicycling"
		case .transit:
			return "transit"
		}
	}
}

/// The assumptions to use when calculating time in traffic
///
/// This setting affects the value returned in the `durationInTraffic` field in the response, which contains the predicted time in traffic based on historical averages. The `trafficModel` parameter may only be specified for driving directions where the request includes a `departureTime`, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
///
/// The default value of `bestGuess` will give the most useful predictions for the vast majority of use cases. The `bestGuess` travel time prediction may be shorter than `optimistic`, or alternatively, longer than `pessimistic`, due to the way the `bestGuess` prediction model integrates live traffic information.
public enum PXGoogleDirectionsTrafficModel: Int {
	/// Indicates that the returned `durationInTraffic` should be the best estimate of travel time given what is known about both historical traffic conditions and live traffic; live traffic becomes more important the closer the `departureTime` is to now
	case bestGuess = 0
	/// Indicates that the returned `durationInTraffic` should be longer than the actual travel time on most days, though occasional days with particularly bad traffic conditions may exceed this value
	case pessimistic
	/// Indicates that the returned `durationInTraffic` should be shorter than the actual travel time on most days, though occasional days with particularly good traffic conditions may be faster than this value
	case optimistic
}

extension PXGoogleDirectionsTrafficModel: CustomStringConvertible {
	public var description: String {
		switch self {
		case .bestGuess:
			return "best_guess"
		case .pessimistic:
			return "pessimistic"
		case .optimistic:
			return "optimistic"
		}
	}
}

/// Features that should be avoided when calculating routes
public enum PXGoogleDirectionsFeature: Int {
	/// The calculated route should avoid toll roads/bridges
	case tolls = 0
	/// The calculated route should avoid highways
	case highways
	/// The calculated route should avoid ferries
	case ferries
}

extension PXGoogleDirectionsFeature: CustomStringConvertible {
	public var description: String {
		switch self {
		case .tolls:
			return "tolls"
		case .highways:
			return "highways"
		case .ferries:
			return "ferries"
		}
	}
}

/// The unit system to use when displaying results (by default, the texts are rendered using the unit system of the origin's country or region)
public enum PXGoogleDirectionsUnit: Int {
	/// Use the metric system (textual distances are returned using kilometers and meters)
	case metric = 0
	/// Use the imperial (English) system (textual distances are returned using kilometers and meters)
	case imperial
}

extension PXGoogleDirectionsUnit: CustomStringConvertible {
	public var description: String {
		switch self {
		case .metric:
			return "metric"
		case .imperial:
			return "imperial"
		}
	}
}

/// Preferred modes of transit (only valid for transit directions)
public enum PXGoogleDirectionsTransitMode: Int {
	/// The calculated route should prefer travel by bus
	case bus = 0
	/// The calculated route should prefer travel by subway
	case subway
	/// The calculated route should prefer travel by train
	case train
	/// The calculated route should prefer travel by tram and light rail
	case tram
	/// The calculated route should prefer travel by train, tram, light rail, and subway (equivalent to `Train` + `Tram`+ `Subway`)
	case rail
}

extension PXGoogleDirectionsTransitMode: CustomStringConvertible {
	public var description: String {
		switch self {
		case .bus:
			return "bus"
		case .subway:
			return "subway"
		case .train:
			return "train"
		case .tram:
			return "tram"
		case .rail:
			return "rail"
		}
	}
}

/// Preferences for transit routes only ; using this parameter, the options returned can be biased, rather than accepting the default best route chosen by the API
public enum PXGoogleDirectionsTransitRoutingPreference: Int {
	/// Indicates that the calculated route should prefer limited amounts of walking
	case lessWalking = 0
	/// Indicates that the calculated route should prefer a limited number of transfers
	case fewerTransfers
}

extension PXGoogleDirectionsTransitRoutingPreference: CustomStringConvertible {
	public var description: String {
		switch self {
		case .lessWalking:
			return "less_walking"
		case .fewerTransfers:
			return "fewer_transfers"
		}
	}
}

/// Type of vehicles that run on transit lines
public enum PXGoogleDirectionsVehicleType: Int {
	/// Rail
	case rail = 0
	/// Light rail transit
	case metroRail
	/// Underground light rail
	case subway
	/// Above ground light rail
	case tram
	/// Monorail
	case monorail
	/// Heavy rail
	case heavyRail
	/// Commuter rail
	case commuterTrain
	/// High speed train
	case highSpeedTrain
	/// Bus
	case bus
	/// Intercity bus
	case intercityBus
	/// Trolleybys
	case trolleybus
	/// Share taxi is a kind of bus with the ability to drop off and pick up passengers anywhere on its route
	case shareTaxi
	/// Ferry
	case ferry
	/// A vehicle that operates on a cable, usually on the ground (aerial cable cars may be of the type `GondolaLift`)
	case cableCar
	/// An aerial cable car
	case gondolaLift
	/// A vehicle that is pulled up a steep incline by a cable ; a funicular typically consists of two cars, with each car acting as a counterweight for the other
	case funicular
	/// All other vehicles will return this type
	case other

	/**
	Returns an `PXGoogleDirectionsVehicleType` object corresponding to the vehicle type returned by the API for a specific line.

	- parameter value: The vehicle type code returned by the API
	- returns: The corresponding `PXGoogleDirectionsVehicleType` instance
	*/
	public static func vehicleTypeFromValue(_ value: String) -> PXGoogleDirectionsVehicleType {
		switch value {
		case "RAIL":
			return .rail
		case "METRO_RAIL":
			return .metroRail
		case "SUBWAY":
			return .subway
		case "TRAM":
			return .tram
		case "MONORAIL":
			return .monorail
		case "HEAVY_RAIL":
			return .heavyRail
		case "COMMUTER_TRAIN":
			return .commuterTrain
		case "HIGH_SPEED_TRAIN":
			return .highSpeedTrain
		case "BUS":
			return .bus
		case "INTERCITY_BUS":
			return .intercityBus
		case "TROLLEYBUS":
			return .trolleybus
		case "SHARE_TAXI":
			return .shareTaxi
		case "FERRY":
			return .ferry
		case "CABLE_CAR":
			return .cableCar
		case "GONDOLA_LIFT":
			return .gondolaLift
		case "FUNICULAR":
			return .funicular
		case "OTHER":
			return .other
		default:
			return .other
		}
	}
}

/// Kind of map shown when opening a location or direction in the Google Maps app
public enum PXGoogleMapsMode: Int {
	/// Standard map view
	case standard = 0
	/// Google Street View mode
	case streetView
}

extension PXGoogleMapsMode: CustomStringConvertible {
	public var description: String {
		switch self {
		case .standard:
			return "standard"
		case .streetView:
			return "streetview"
		}
	}
}

/// Turns specific views on or off, like satellite, traffic or transit
public enum PXGoogleMapsView: Int {
	/// Turns satellite view on
	case satellite = 0
	/// Turns traffic view on
	case traffic
	/// Turns transit view on
	case transit
}

extension PXGoogleMapsView: CustomStringConvertible {
	public var description: String {
		switch self {
		case .satellite:
			return "satellite"
		case .traffic:
			return "traffic"
		case .transit:
			return "transit"
		}
	}
}
