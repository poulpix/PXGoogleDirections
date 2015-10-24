//
//  GMSPlacePickerConfig.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSCoordinateBounds.h>
#import <GoogleMaps/GMSPlacesClient.h>


/**
 * Configuration object used to change the behaviour of the place picker.
 */
@interface GMSPlacePickerConfig : NSObject

/**
 * The initial viewport that the place picker map should show. If this is nil, a sensible default
 * will be chosen based on the user's location.
 */
@property(nonatomic, strong, readonly) GMSCoordinateBounds *viewport;

/**
 * Initialize the configuration.
 */
- (instancetype)initWithViewport:(GMSCoordinateBounds *)viewport;

@end
