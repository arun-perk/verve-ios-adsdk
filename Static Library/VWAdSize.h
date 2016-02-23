//
//  VWAdSize.h
//  VWAdLibrary
//
//  Copyright (c) 2014 Verve Wireless, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// You should consider this struct as an opaque type.
// Never, ever, rely on size property of this struct - instead use
// CGSizeFromVWAdSize and other methods defined below.
typedef struct {
  CGSize size;
  NSUInteger flags;
} VWAdSize;


#pragma mark Standard Sizes

// 320 x 50 or device-width x 50
extern VWAdSize const kVWAdSizeBanner;

// 300 x 250
extern VWAdSize const kVWAdSizeMediumRectangle;

// 728 x 90
extern VWAdSize const kVWAdSizeLeaderboard;


#pragma mark Custom Sizes

/*!
 * Given a CGSize, return a custom VWAdSize. Use this only if you require a
 * non-standard size, otherwise, use one of the standard size constants above.
 */
VWAdSize VWAdSizeFromCGSize(CGSize size);


#pragma mark Convenience Functions

/*!
 * Checks whether the two VWAdSizes are equal.
 */
BOOL VWAdSizeEqualToSize(VWAdSize size1, VWAdSize size2);

/*!
 * Given a VWAdSize constant, returns a CGSize. If the VWAdSize is unknown,
 * returns CGSizeZero.
 *
 * @warning You should not rely on this value while laying out your view hierarchy,
 * instead use sizeThatFits: method of VWAdvertView to get view's preferred size.
 */
CGSize CGSizeFromVWAdSize(VWAdSize size);

/*!
 * Given a VWAdSize constant, returns a NSString describing the VWAdSize.
 */
NSString *NSStringFromVWAdSize(VWAdSize size);

