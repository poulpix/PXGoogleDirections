//
//  PXGoogleDirections.swift
//  PXGoogleDirections
//
//  Created by Romain on 01/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

@objc public protocol PXGoogleDirectionsDelegate {
	/**
	Notifies the delegate that an API request is going to be sent.
	
	:param: googleDirections The `PXGoogleDirections` object issuing the request
	:param: requestURL The URL that is going to be called
	:returns: `true` if the request should be sent, `false` otherwise
	*/
	optional func googleDirectionsWillSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) -> Bool
	/**
	Notifies the delegate that an API request has been sent.
	
	:param: googleDirections The `PXGoogleDirections` object issuing the request
	:param: requestURL The URL that was called
	*/
	optional func googleDirectionsDidSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL)
	/**
	Notifies the delegate that (yet unparsed) response data has been received from the API.
	
	:param: googleDirections The `PXGoogleDirections` object that issued the request
	:param: data An `NSData` object containing raw data received from the API
	*/
	optional func googleDirections(googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: NSData)
	/**
	Notifies the delegate that an error occurred while trying to handle the response received from the API.
	
	:param: googleDirections The `PXGoogleDirections` object that issued the request
	:param: error An `NSError` object describing the type and potential cause of the error
	*/
	optional func googleDirectionsRequestDidFail(googleDirections: PXGoogleDirections, withError error: NSError)
	/**
	Notifies the delegate that a response has been successfully received and parsed from the API.
	
	:param: googleDirections The `PXGoogleDirections` object that issued the request
	:param: apiResponse A list of `PXGoogleDirectionsRoute` objects containing all relevant data received from the API
	*/
	optional func googleDirections(googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute])
}

protocol PXGoogleDirectionsSteppable {
	var steps: [PXGoogleDirectionsRouteLegStep] { get set }
}

public typealias PXGoogleDirectionsRequestCompletionBlock = (PXGoogleDirectionsResponse) -> Void

public class PXGoogleDirections: NSObject {
	
	// MARK: Private class variables and consants
	
	private static let errorDomain = "PXGoogleDirectionsErrorDomain"
	private static let _apiBaseURL = "https://maps.googleapis.com/maps/api/directions/json"
	private static var _apiKey = ""
	private static var apiKey: String {
		get {
		return _apiKey
		}
		set {
			_apiKey = newValue
			GMSServices.provideAPIKey(_apiKey)
		}
	}
	
	// MARK: Class variables and constants
	
	/// The Google Directions API base URL (readonly).
	public static var apiBaseURL: String { return _apiBaseURL }
	/// The address or textual latitude/longitude value from which directions should be calculated (if an address is passed, the Directions API will geocode it and convert it to a latitude/longitude coordinate to calculate directions)
	public var from: PXLocation!
	/// The address or textual latitude/longitude value of the destination of the directions request (if an address is passed, the Directions API will geocode it and convert it to a latitude/longitude coordinate to calculate directions)
	public var to: PXLocation!
	/// Specifies the mode of transport to use when calculating directions (defaults to `Driving`)
	public var mode: PXGoogleDirectionsMode?
	/// Specifies an array of waypoints (either a latitude/longitude coordinate or as an address which will be geocoded) ; waypoints alter a route by routing it through the specified location(s), and are only supported for driving, walking and bicycling directions
	public var waypoints = [PXLocation]()
	/// By default, the Directions service calculates a route through the provided waypoints in their given order, but optionally, it can be allowed to optimize the provided route by rearranging the waypoints in a more efficient order
	public var optimizeWaypoints: Bool?
	/// If set to `true`, specifies that the API may provide more than one route alternative in the response
	public var alternatives: Bool?
	/// Indicates that the calculated routes should avoid the indicated features
	public var featuresToAvoid = Set<PXGoogleDirectionsFeature>()
	/// Specifies the unit system to use when displaying results
	public var units: PXGoogleDirectionsUnit?
	///Specifies the desired time of departure
	public var departureTime: PXTime?
	/// Specifies the desired time of arrival (for transit directions only)
	public var arrivalTime: PXTime?
	/// Specifies one or more preferred modes of transit
	public var transitModes = Set<PXGoogleDirectionsTransitMode>()
	/// Specifies preferences for transit routes
	public var transitRoutingPreference: PXGoogleDirectionsTransitRoutingPreference?
	/// Specifies the language in which to return results (if invalid or not supplied, the service will attempt to use the native language of the domain from which the request is sent)
	public var language: String?
	/// Specifies the region code, specified as a ccTLD ("top-level domain") two-character value (can be practically utilized with any domain in which the main Google Maps application has launched driving directions)
	public var region: String?
	/// Specifies an optional delegate that will be notified of all events regarding the Google Directions API
	public var delegate: PXGoogleDirectionsDelegate?
	
	// MARK: Properties
	
	/**
	Tries to build an instance of `NSURL` pointing to the Google Directions API using the specified parameters, or `nil`.
	*/
	public var directionsAPIRequestURL: NSURL? {
		// Ensure origin and destination are set
		if let f = from, t = to {
			// Create the base URL with minimal arguments
			var preparedRequest = "\(PXGoogleDirections.apiBaseURL)?key=\(PXGoogleDirections.apiKey)&origin=\(f)&destination=\(t)"
			// Handle transport mode
			if let m = mode {
				preparedRequest += "&mode=\(m)"
			}
			// Handle optional waypoints
			if waypoints.count > 0 {
				let wp = "|".join(map(waypoints, { $0.description }))
				let opt = ((optimizeWaypoints ?? false) ? "optimize:true|" : "")
				preparedRequest += "&waypoints=\(opt)\(wp)"
			}
			// Handle request for alternative routes
			if let a = alternatives {
				let alt = (a ? "true" : "false")
				preparedRequest += "&alternatives=\(alt)"
			}
			// Handle request for features to avoid
			if featuresToAvoid.count > 0 {
				let fta = "|".join(map(featuresToAvoid, { $0.description }))
				preparedRequest += "&avoid=\(fta)"
			}
			// Handle results language
			if let l = language {
				preparedRequest += "&language=\(l)"
			}
			// Handle unit system
			if let u = units {
				preparedRequest += "&units=\(u)"
			}
			// Handle region bias
			if let r = region {
				preparedRequest += "&region=\(r)"
			}
			// Handle departure time
			if let dt = departureTime {
				preparedRequest += "&departure_time=\(dt)"
			}
			// Handle arrival time
			if let at = arrivalTime {
				if departureTime != nil {
					// Can't set both departure_time and arrival_time
					return nil
				}
				if mode == .Transit && at != .Now {
					preparedRequest += "&arrival_time=\(at)"
				}
			}
			// Handle public transit mode
			if transitModes.count > 0 {
				if mode == .Transit {
					let tm = "|".join(map(transitModes, { $0.description }))
					preparedRequest += "&transit_mode=\(tm)"
				}
			}
			// Handle public transit routing preference
			if let trp = transitRoutingPreference {
				if mode == .Transit {
					preparedRequest += "&transit_routing_preference=\(trp)"
				}
			}
			// Try to build the suitable NSURL and return it
			if let requestURL = preparedRequest.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
				return NSURL(string: requestURL)
			} else {
				// Error while building NSURL
				return nil
			}
		} else {
			// Missing source and/or destination
			return nil
		}
	}
	
	// MARK: Initializers
	
	/**
	Creates a new instance of `PXGoogleDirections` with the specified API key.
	
	:param: apiKey Your own API key, provided by Google
	*/
	public init(apiKey: String) {
		super.init()
		PXGoogleDirections.apiKey = apiKey
	}
	
	/**
	Creates a new instance of `PXGoogleDirections` with the specified API key, origin and destination.
	
	:param: apiKey Your own API key, provided by Google
	:param: from The address or textual latitude/longitude value from which directions should be calculated
	:param: to The address or textual latitude/longitude value of the destination of the directions request
	*/
	public convenience init(apiKey: String, from: PXLocation, to: PXLocation) {
		self.init(apiKey: apiKey)
		self.from = from
		self.to = to
	}
	
	// MARK: Public functions
	
	/**
	Performs a Google Directions API request with the specified parameters and calls the block when finished.
	
	:param: completion The completion block called when the request is done, or in case of any error
	*/
	public func calculateDirections(completion: PXGoogleDirectionsRequestCompletionBlock)
	{
		// Try to create a request URL using the supplied parameters
		if let requestURL = directionsAPIRequestURL {
			// Show network activity indicator
			UIApplication.sharedApplication().networkActivityIndicatorVisible = true
			var runQuery = true
			if delegate != nil {
				// Notify delegate
				runQuery = (delegate?.googleDirectionsWillSendRequestToAPI?(self, withURL: requestURL))!
			}
			// Handle the case where the delegate might have askeed to cancel the request
			if runQuery {
				NSURLSession.sharedSession().dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
					// Hide network activity indicator
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false
					// Notify delegate
					self.delegate?.googleDirections?(self, didReceiveRawDataFromAPI: data)
					// Check for any error (from an NSURLSession point of view)
					if error == nil {
						var response = [PXGoogleDirectionsRoute]()
						// Try to parse the received JSON data
						if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
							// Try fo fetch the API response status code
							if let st = json["status"] as? String {
								let status = PXGoogleDirectionsError.errorFromStatus(st)
								// Handle any potential error status code the API might have returned
								if status.failed {
									// API error received: notify delegate and call completion block (with error value)
									let err = prepareError(status)
									self.delegate?.googleDirectionsRequestDidFail?(self, withError: err)
									completion(.Error(err.description))
									return
								} else {
									// From here on: try to parse and process the received data
									if let routes = json["routes"] as AnyObject? as? [[String: AnyObject]] {
										// Loop through routes
										for r in routes {
											// Create a new route object
											var currentRoute = PXGoogleDirectionsRoute()
											// General route information
											currentRoute.summary = r["summary"] as? String
											currentRoute.copyrights = r["copyrights"] as? String
											// Route fare
											if let fare = r["fare"] as? [String: AnyObject] {
												currentRoute.fare = PXGoogleDirectionsRouteFare(currency: fare["currency"] as? String, value: fare["value"] as? Double)
											}
											// Overview polyline
											if let polyline = r["overview_polyline"] as? [String: String] {
												currentRoute.overviewPolyline = polyline["points"]
											}
											// Bounds
											if let bounds = r["bounds"] as? [String: AnyObject] {
												var northEastBound: CLLocationCoordinate2D?
												var southWestBound: CLLocationCoordinate2D?
												if let northeast = bounds["northeast"] as? [String: Double] {
													if let neLat = northeast["lat"], neLng = northeast["lng"] {
														northEastBound = CLLocationCoordinate2DMake(neLat, neLng)
													}
												}
												if let southwest = bounds["southwest"] as? [String: Double] {
													if let swLat = southwest["lat"], swLng = southwest["lng"] {
														southWestBound = CLLocationCoordinate2DMake(swLat, swLng)
													}
												}
												if northEastBound != nil && southWestBound != nil {
													currentRoute.bounds = GMSCoordinateBounds(coordinate: northEastBound!, coordinate: southWestBound!)
												}
											}
											// Warnings
											if let warnings = r["warnings"] as? [String] {
												for w in warnings {
													currentRoute.warnings.append(w)
												}
											}
											// Waypoint order
											if let wpOrder = r["waypoint_oder"] as? [Int] {
												for wp in wpOrder {
													currentRoute.waypointsOrder.append(wp)
												}
											}
											// Route legs
											if let legs = r["legs"] as? [[String: AnyObject]] {
												// Loop through legs
												for l in legs {
													// Create a new leg object
													var currentLeg = PXGoogleDirectionsRouteLeg()
													// General leg information
													currentLeg.startAddress = l["start_address"] as? String
													if let startLocation = l["start_location"] as? [String: CLLocationDegrees] {
														if let slLat = startLocation["lat"], slLng = startLocation["lng"] {
															currentLeg.startLocation = CLLocationCoordinate2DMake(slLat, slLng)
														}
													}
													currentLeg.endAddress = l["end_address"] as? String
													if let endLocation = l["end_location"] as? [String: CLLocationDegrees] {
														if let elLat = endLocation["lat"], elLng = endLocation["lng"] {
															currentLeg.endLocation = CLLocationCoordinate2DMake(elLat, elLng)
														}
													}
													// Distance
													if let distance = l["distance"] as? [String: AnyObject] {
														currentLeg.distance = PXGoogleDirectionsDistance(distance: distance["value"] as? CLLocationDistance, description: distance["text"] as? String)
													}
													// Duration
													if let duration = l["duration"] as? [String: AnyObject] {
														currentLeg.duration = PXGoogleDirectionsDuration(duration: duration["value"] as? NSTimeInterval, description: duration["text"] as? String)
													}
													// Duration in traffic
													if let durationT = l["duration_in_traffic"] as? [String: AnyObject] {
														if let dTText = durationT["text"] as? String, dTValue = durationT["value"] as? NSTimeInterval {
															currentLeg.durationInTraffic = PXGoogleDirectionsDuration(duration: dTValue, description: dTText)
														}
													}
													// Departure time
													if let departure = l["departure_time"] as? [String: AnyObject] {
														currentLeg.departureTime = PXGoogleDirectionsTime(description: departure["text"] as? String, timeZone: nil, timestamp: departure["value"] as? NSTimeInterval)
														if let dTZ = departure["time_zone"] as? String {
															currentLeg.arrivalTime?.timeZone = NSTimeZone(name: dTZ)
														}
													}
													// Arrival time
													if let arrival = l["arrival_time"] as? [String: AnyObject] {
														currentLeg.arrivalTime = PXGoogleDirectionsTime(description: arrival["text"] as? String, timeZone: nil, timestamp: arrival["value"] as? NSTimeInterval)
														if let aTZ = arrival["time_zone"] as? String {
															currentLeg.arrivalTime?.timeZone = NSTimeZone(name: aTZ)
														}
													}
													// Leg steps
													if let steps = l["steps"] as? [[String: AnyObject]] {
														currentLeg.steps = self.handleSteps(l)
													}
													// Add the leg to the current route object
													currentRoute.legs.append(currentLeg)
												}
											}
											// Add the route to the response object
											response.append(currentRoute)
										}
									}
								}
							} else {
								// API response status code missing: notify delegate and call completion block (with error value)
								let err = prepareError(.MissingStatusCode)
								self.delegate?.googleDirectionsRequestDidFail?(self, withError: err)
								completion(.Error(err.description))
								return
							}
						} else {
							// Unable to parse the API response: notify delegate and call completion block (with error value)
							let err = prepareError(.BadJSONFormatting)
							self.delegate?.googleDirectionsRequestDidFail?(self, withError: err)
							completion(.Error(err.description))
							return
						}
						// Everything went well up to this point: ready to forward results to delegate and callback
						dispatch_async(dispatch_get_main_queue()) {
							// Success: notify delegate and call completion block (with success value)
							self.delegate?.googleDirections?(self, didReceiveResponseFromAPI: response)
							completion(.Success(response))
							return
						}
					} else {
						// Generic NSURLSession error: notify delegate and call completion block (with error value)
						self.delegate?.googleDirectionsRequestDidFail?(self, withError: error)
						completion(.Error(error.description))
						return
					}
				}).resume()
				// Notify delegate
				delegate?.googleDirectionsDidSendRequestToAPI?(self, withURL: requestURL)
			}
		} else {
			// Unable to create an API URL with the supplied arguments: notify delegate and call completion block (with error value)
			let err = prepareError(.BadAPIURL)
			delegate?.googleDirectionsRequestDidFail?(self, withError: err)
			completion(.Error(err.description))
			return
		}
	}
	
	// MARK: Private functions
	
	private func prepareError(code: PXGoogleDirectionsError) -> NSError {
		return NSError(domain: PXGoogleDirections.errorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey: code.description])
	}
	
	private func handleSteps(jsonData: [String: AnyObject]) -> [PXGoogleDirectionsRouteLegStep] {
		var results = [PXGoogleDirectionsRouteLegStep]()
		if let steps = jsonData["steps"] as? [[String: AnyObject]] {
			for s in steps {
				// Loop through steps
				var currentStep = PXGoogleDirectionsRouteLegStep()
				// General step information
				if let startLocation = s["start_location"] as? [String: CLLocationDegrees] {
					if let slLat = startLocation["lat"], slLng = startLocation["lng"] {
						currentStep.startLocation = CLLocationCoordinate2DMake(slLat, slLng)
					}
				}
				if let endLocation = s["end_location"] as? [String: CLLocationDegrees] {
					if let elLat = endLocation["lat"], elLng = endLocation["lng"] {
						currentStep.endLocation = CLLocationCoordinate2DMake(elLat, elLng)
					}
				}
				currentStep.htmlInstructions = s["html_instructions"] as? String
				currentStep.maneuver = s["maneuver"] as? String
				currentStep.travelMode = PXGoogleDirectionsMode.modeFromLabel((s["travel_mode"] as? String) ?? "")
				// Distance
				if let distance = s["distance"] as? [String: AnyObject] {
					currentStep.distance = PXGoogleDirectionsDistance(distance: distance["value"] as? CLLocationDistance, description: distance["text"] as? String)
				}
				// Duration
				if let duration = s["duration"] as? [String: AnyObject] {
					currentStep.duration = PXGoogleDirectionsDuration(duration: duration["value"] as? NSTimeInterval, description: duration["text"] as? String)
				}
				// Polyline
				if let polyline = s["polyline"] as? [String: String] {
					currentStep.polyline = polyline["points"]
				}
				// Transit details
				if let transitDetails = s["transit_details"] as? [String: AnyObject] {
					// General transit details information
					currentStep.transitDetails = PXGoogleDirectionsRouteLegStepTransitDetails()
					currentStep.transitDetails?.headsign = transitDetails["headsign"] as? String
					currentStep.transitDetails?.headway = transitDetails["headway"] as? NSTimeInterval
					currentStep.transitDetails?.nbStops = transitDetails["num_stops"] as? UInt
					// Departure stop
					if let departureStop = transitDetails["departure_stop"] as? [String: AnyObject] {
						if let dsName = departureStop["name"] as? String, dsLocation = departureStop["location"] as? [String: CLLocationDegrees] {
							if let dslLat = dsLocation["lat"], dslLng = dsLocation["lng"] {
								currentStep.transitDetails?.departureStop = PXGoogleDirectionsStop(description: dsName, location: CLLocationCoordinate2DMake(dslLat, dslLng))
							}
						}
					}
					// Arrival stop
					if let arrivalStop = transitDetails["arrival_stop"] as? [String: AnyObject] {
						if let asName = arrivalStop["name"] as? String, asLocation = arrivalStop["location"] as? [String: CLLocationDegrees] {
							if let aslLat = asLocation["lat"], aslLng = asLocation["lng"] {
								currentStep.transitDetails?.arrivalStop = PXGoogleDirectionsStop(description: asName, location: CLLocationCoordinate2DMake(aslLat, aslLng))
							}
						}
					}
					// Departure time
					if let departure = transitDetails["departure_time"] as? [String: AnyObject] {
						currentStep.transitDetails?.departureTime = PXGoogleDirectionsTime(description: departure["text"] as? String, timeZone: nil, timestamp: departure["value"] as? NSTimeInterval)
						if let dTZ = departure["time_zone"] as? String {
							currentStep.transitDetails?.departureTime?.timeZone = NSTimeZone(name: dTZ)
						}
					}
					// Arrival time
					if let arrival = transitDetails["arrival_time"] as? [String: AnyObject] {
						currentStep.transitDetails?.arrivalTime = PXGoogleDirectionsTime(description: arrival["text"] as? String, timeZone: nil, timestamp: arrival["value"] as? NSTimeInterval)
						if let aTZ = arrival["time_zone"] as? String {
							currentStep.transitDetails?.arrivalTime?.timeZone = NSTimeZone(name: aTZ)
						}
					}
					// Line
					if let line = transitDetails["line"] as? [String: AnyObject] {
						// General line information
						currentStep.transitDetails?.line = PXGoogleDirectionsTransitLine()
						currentStep.transitDetails?.line?.color = UIColor(hexColor: (line["color"] as? String) ?? "")
						currentStep.transitDetails?.line?.name = line["name"] as? String
						currentStep.transitDetails?.line?.shortName = line["short_name"] as? String
						currentStep.transitDetails?.line?.textColor = UIColor(hexColor: (line["text_color"] as? String) ?? "")
						currentStep.transitDetails?.line?.url = NSURL(string: (line["url"] as? String) ?? "")
						// Icon
						if let iconUrl = NSURL(string: (line["icon"] as? String) ?? "") {
							if let data = NSData(contentsOfURL: iconUrl) {
								currentStep.transitDetails?.line?.icon = UIImage(data: data)
							}
						}
						// Agencies
						if let agencies = line["agencies"] as? [[String: String]] {
							for a in agencies {
								currentStep.transitDetails?.line?.agencies.append(PXGoogleDirectionsTransitAgency(name: a["name"], url: NSURL(string: (a["url"] ?? "")), phone: a["phone"]))
							}
						}
						// Vehicle
						if let vehicle = line["vehicle"] as? [String: String] {
							if let vName = vehicle["name"], vType = vehicle["type"], vIconURL = NSURL(string: vehicle["icon"] ?? "") {
								currentStep.transitDetails?.line?.vehicle = PXGoogleDirectionsTransitLineVehicle(name: vName, type: PXGoogleDirectionsVehicleType.vehicleTypeFromValue(vType), icon: nil)
								if let data = NSData(contentsOfURL: vIconURL) {
									currentStep.transitDetails?.line?.vehicle?.icon = UIImage(data: data)
								}
							}
						}
					}
					// Sub-steps
					if let substeps = s["steps"] as? [[String: AnyObject]] {
						currentStep.steps = handleSteps(s)
					}
				}
				// Add the step to results
				results.append(currentStep)
			}
		}
		return results
	}
}
