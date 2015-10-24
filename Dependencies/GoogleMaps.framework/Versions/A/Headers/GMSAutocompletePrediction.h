//
//  GMSAutocompletePrediction.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//


/*
 * Attribute name for match fragments in |GMSAutocompletePrediction| attributedFullText.
 */
extern NSString *const kGMSAutocompleteMatchAttribute;

/**
 * This class represents a prediction of a full query based on a partially typed string.
 */
@interface GMSAutocompletePrediction : NSObject

/**
 * The full description of the prediction as a NSAttributedString. E.g., "Sydney Opera House,
 * Sydney, New South Wales, Australia".
 *
 * Every text range that matches the user input has a |kGMSAutocompleteMatchAttribute|.  For
 * example, you can make every match bold using enumerateAttribute:
 * <pre>
 *   UIFont *regularFont = [UIFont systemFontOfSize:[UIFont labelFontSize]];
 *   UIFont *boldFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
 *
 *   NSMutableAttributedString *bolded = [prediction.attributedFullText mutableCopy];
 *   [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute
 *                      inRange:NSMakeRange(0, bolded.length)
 *                      options:0
 *                   usingBlock:^(id value, NSRange range, BOOL *stop) {
 *                     UIFont *font = (value == nil) ? regularFont : boldFont;
 *                     [bolded addAttribute:NSFontAttributeName value:font range:range];
 *                   }];
 *
 *   label.attributedText = bolded;
 * </pre>
 */
@property(nonatomic, copy, readonly) NSAttributedString *attributedFullText;


/**
 * An optional property representing the place ID of the prediction, suitable for use in a place
 * details request.
 */
@property(nonatomic, copy, readonly) NSString *placeID;

/**
 * The types of this autocomplete result.  Types are NSStrings, valid values are any types
 * documented at <https://developers.google.com/places/supported_types>.
 */
@property(nonatomic, copy, readonly) NSArray *types;

@end
