//
//  GMSPlacesMacros.h
//  Google Maps SDK for iOS
//
//  Copyright 2015 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#if !__has_feature(nullability) \
    || !defined(NS_ASSUME_NONNULL_BEGIN) \
    || !defined(NS_ASSUME_NONNULL_END)
#define GMS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END
#define GMS_NULLABLE
#define GMS_NULLABLE_PTR
#else
#define GMS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define GMS_NULLABLE nullable
#define GMS_NULLABLE_PTR __nullable
#endif
