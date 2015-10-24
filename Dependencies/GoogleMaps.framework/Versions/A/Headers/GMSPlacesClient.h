//
//  GMSPlacesClient.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>

#import <GoogleMaps/GMSPlace.h>
#import <GoogleMaps/GMSPlacesMacros.h>
#import <GoogleMaps/GMSUserAddedPlace.h>


@class GMSAutocompleteFilter;
@class GMSPlaceLikelihoodList;

GMS_ASSUME_NONNULL_BEGIN

/* Error domain used for Places API errors. */
extern NSString * const kGMSPlacesErrorDomain;

/* Error codes for |kGMSPlacesErrorDomain|. */
typedef NS_ENUM(NSInteger, GMSPlacesErrorCode) {
  /**
   * Something went wrong with the connection to the Places API server.
   */
  kGMSPlacesNetworkError = -1,
  /**
   * The Places API server returned a response that we couldn't understand.
   */
  kGMSPlacesServerError = -2,
  /**
   * An internal error occurred in the Places API library.
   */
  kGMSPlacesInternalError = -3,
  /**
   * Operation failed due to an invalid (malformed or missing) API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for information on creating and using an API key.
   */
  kGMSPlacesKeyInvalid = -4,
  /**
   * Operation failed due to an expired API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for information on creating and using an API key.
   */
  kGMSPlacesKeyExpired = -5,
  /**
   * Operation failed due to exceeding the quota usage limit.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/usage">developer's guide</a>
   * for information on usage limits and how to request a higher limit.
   */
  kGMSPlacesUsageLimitExceeded = -6,
  /**
   * Operation failed due to exceeding the usage rate limit for the API key.
   * <p>
   * This status code shouldn't be returned during normal usage of the API. It relates to usage of
   * the API that far exceeds normal request levels.
   */
  kGMSPlacesRateLimitExceeded = -7,
  /**
   * Operation failed due to exceeding the per-device usage rate limit.
   * <p>
   * This status code shouldn't be returned during normal usage of the API. It relates to usage of
   * the API that far exceeds normal request levels.
   */
  kGMSPlacesDeviceRateLimitExceeded = -8,
  /**
   * The Places API is not enabled.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a> for how
   * to enable the Google Places API for iOS.
   */
  kGMSPlacesAccessNotConfigured = -9,
  /**
   * The application's bundle identifier does not match one of the allowed iOS applications for the
   * API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for how to configure bundle restrictions on API keys.
   */
  kGMSPlacesIncorrectBundleIdentifier = -10
};

/**
 * @relates GMSPlacesClient
 * Callback type for receiving place details lookups. If an error occurred,
 * |result| will be nil and |error| will contain information about the error.
 * @param result The |GMSPlace| that was returned.
 * @param error The error that occured, if any.
 */
typedef void (^GMSPlaceResultCallback)(
    GMSPlace * GMS_NULLABLE_PTR result,
    NSError * GMS_NULLABLE_PTR error);

/**
 * @relates GMSPlacesClient
 * Callback type for receiving place likelihood lists. If an error occurred, |likelihoodList| will
 * be nil and |error| will contain information about the error.
 * @param likelihoodList The list of place likelihoods.
 * @param error The error that occured, if any.
 */
typedef void (^GMSPlaceLikelihoodListCallback)(
    GMSPlaceLikelihoodList * GMS_NULLABLE_PTR likelihoodList,
    NSError * GMS_NULLABLE_PTR error);

/**
 * @relates GMSPlacesClient
 * Callback type for receiving autocompletion results. |results| is an array of
 * GMSAutocompletePredictions representing candidate completions of the query.
 * @param results An array of |GMSAutocompletePrediction|s.
 * @param error The error that occured, if any.
 */
typedef void (^GMSAutocompletePredictionsCallback)(
    NSArray * GMS_NULLABLE_PTR results,
    NSError * GMS_NULLABLE_PTR error);

/**
 * Main interface to the Places API. Used for searching and getting details about places. This class
 * should be accessed through the [GMSPlacesClient sharedClient] method.
 *
 * GMSPlacesClient methods should only be called from the main thread. Calling these methods from
 * another thread will result in an exception or undefined behavior. Unless otherwise specified, all
 * callbacks will be invoked on the main thread.
 */
@interface GMSPlacesClient : NSObject

/**
 * Provides the shared instance of GMSPlacesClient for the Google Maps SDK for iOS,
 * creating it if necessary.
 *
 * If your application often uses methods of GMSPlacesClient it may want to hold
 * onto this object directly, as otherwise your connection to Google may be restarted
 * on a regular basis.
 */
+ (instancetype)sharedClient;

/**
 * Report that the device is at a particular place.
 */
- (void)reportDeviceAtPlaceWithID:(NSString *)placeID;

/**
 * Get details for a place. This method is non-blocking.
 * @param placeID The place ID to lookup.
 * @param callback The callback to invoke with the lookup result.
 */
- (void)lookUpPlaceID:(NSString *)placeID callback:(GMSPlaceResultCallback)callback;

/**
 * Returns an estimate of the place where the device is currently known to be located.
 *
 * Generates a place likelihood list based on the device's last estimated location. The supplied
 * callback will be invoked with this likelihood list upon success and an NSError upon an error.
 * @param callback The callback to invoke with the place likelihood list.
 */
- (void)currentPlaceWithCallback:(GMSPlaceLikelihoodListCallback)callback;

/**
 * Autocompletes a given text query. Results may optionally be biased towards a certain location.
 * The supplied callback will be invoked with an array of autocompletion predictions upon success
 * and an NSError upon an error.
 * @param query The partial text to autocomplete.
 * @param bounds The bounds used to bias the results. This is not a hard restrict - places may still
 *               be returned outside of these bounds. This parameter may be nil.
 * @param filter The filter to apply to the results. This parameter may be nil.
 * @param callback The callback to invoke with the predictions.
 */
- (void)autocompleteQuery:(NSString *)query
                   bounds:(GMSCoordinateBounds * GMS_NULLABLE_PTR)bounds
                   filter:(GMSAutocompleteFilter * GMS_NULLABLE_PTR)filter
                 callback:(GMSAutocompletePredictionsCallback)callback;

/**
 * Add a place. The |place| must have all its fields set, except that website or phoneNumber may be
 * nil.
 * @param place The details of the place to be added.
 * @param callback The callback to invoke with the place that was added.
 */
- (void)addPlace:(GMSUserAddedPlace *)place
        callback:(GMSPlaceResultCallback)callback;

@end

GMS_ASSUME_NONNULL_END
