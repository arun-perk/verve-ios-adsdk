//
//  VWAdvertView.h
//  VWAdLibrary
//
//  Copyright (c) 2014 Verve Wireless, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "VWContentCategory.h"
#import "VWAdSize.h"
#import "VWAdRequest.h"

/*
 * Name of boolean value in Info.plist indicating whether the Apple
 * iAd service should be used when a Verve request doesn't return
 * an ad.  Note that use of this service requires activation with Apple.
 * Also note that debug and ad hoc builds of apps will show test iAd
 * advertisements.
 */
#define kVWiAdEnabled @"kVWiAdEnabled"


extern NSString * _Nonnull const VWFullScreenAdImpressionNotification;
extern NSString * _Nonnull const VWAdvertErrorDomain;


/* Possible error codes for VWAdvertErrorDomain. */
typedef enum {
  VWAdvertErrorUnknown = 0,
  VWAdvertErrorInventoryUnavailable = 1,
} VWAdvertError;


/* Possible values for ad position (default is Unknown). */
typedef enum {
  VWAdvertPositionUnknown = 0,
  VWAdvertPositionTop,
  VWAdvertPositionInline,
  VWAdvertPositionBottom
} VWAdvertPosition;


/*
 * Possible values for specialized ad presentations (default is Regular).
 * Note that this affects the types of ads returned and should only be used
 * after consultation with Verve ad operations.
 */
typedef enum {
  VWAdvertTypeRegular = 0,
  VWAdvertTypeSponsorship,
  VWAdvertTypeInterstitial,
  VWAdvertTypeSplashSponsorship,
  VWAdvertTypeBanner
} VWAdvertType;



@class VWAdvertView;

/*
 * Delegate methods for handling display and removal of the ad view.
 * Your view controller should display or hide the ad view in a manner
 * appropriate for your UI.
 */

@protocol VWAdvertViewDelegate

@optional

/*!
 * Informs you that new ad has been received as a result of loadRequest: call.
 *
 * This is the best place to add (and preferably animate in) advert view to your
 * view hierarchy. Use sizeThatFits: to calculate preferable size for advert view's frame.
 *
 * @warning If you're changing adSize property on advert view after it has been created or
 * if you have kVWiAdEnabled enabled, you should set (and preferably animate) advert view's
 * frame size in implementation of this method as it is possible that new ad is of different
 * size. Use sizeThatFits: to get new size.
 *
 * We encourage you to familiarize yourself with sample aps included in SDK as they present
 * simple but powerful architecture that should be used for view hierarchies that include
 * advert views.
 */
- (void)advertViewDidReceiveAd:(nonnull VWAdvertView *)adView;

/*!
 * Informs you that last loadRequest: call has failed. You should hide advert view if it's visible.
 */
- (void)advertView:(nonnull VWAdvertView *)adView didFailToReceiveAdWithError:(nullable NSError *)error;

/*
 * These methods are optional but should only be used when your app needs to
 * present viewController a specific way.  If you return NO for either, you're
 * responsible showing or dismissing viewController.  The response view must be
 * presented full screen.
 *
 * Also, you don't have to implement both methods.  If shouldDismiss is unimplemented
 * (or returns YES), viewController will simply be dismissed with
 * dismissViewControllerAnimated:completion:.
 */
- (BOOL)advertView:(nonnull VWAdvertView *)adView shouldPresentAdResponseViewController:(nonnull UIViewController *)viewController;
- (BOOL)advertView:(nonnull VWAdvertView *)adView shouldDismissAdResponseViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;

/*
 * If your app is interested, the iAd bannerViewActionShouldBegin:willLeaveApplication:
 * delegate gets passed through to this method.  Note that it only gets invoked on an iAd,
 * not a Verve ad.  If unimplemented, the default return is YES.
 */
- (BOOL)advertViewiAdActionShouldBegin:(nonnull VWAdvertView *)adView willLeaveApplication:(BOOL)willLeave;


- (void)advertViewWillPresentAdResponseViewController:(nonnull VWAdvertView *)adView;
- (void)advertViewWillDismissAdResponseViewController:(nonnull VWAdvertView *)adView;
- (void)advertViewDidDismissAdResponseViewController:(nonnull VWAdvertView *)adView;
- (void)advertViewWillLeaveApplication:(nonnull VWAdvertView *)adView;

@end


@interface VWAdvertView : UIView

/*!
 * Size of an ad in the advert view. Changing this will not affect current ad, rather it will be
 * used in next request made by explicit call to loadRequest:.
 *
 * @warning: Although allowed, it's not recomended to change this after view is created. If you find
 * yourself doing it you might want to reconsider your architecture and create different views for
 * different sizes.
 */
@property (nonatomic, assign) VWAdSize adSize;

/*!
 * Set this property to indicate advert position when known.
 * Defaults to VWAdvertPositionUnknown.
 */
@property (nonatomic, assign) VWAdvertPosition adPosition;

/*!
 * Affects the types of ads returned.
 * Only set this value if told to do so by Verve Ad Operations!
 */
@property (nonatomic, assign) VWAdvertType adType;

/*!
 * Use delegate object to observe advert's state and to show or hide view accordingly.
 */
@property (nonatomic, weak, nullable) id <VWAdvertViewDelegate, NSObject> delegate;

/*! 
 * This value will default to whatever kVWiAdEnabled is set to in your Info.plist, so
 * there's usually no need to touch this if you have the default configured correctly.
 * However, if you want to conditionalize when iAd should be used, you may twiddle
 * this value after VWAdvertView has been initialized.  (Only applicable for non-custom
 * ad sizes.)  kVWiAdEnabled should be set to YES if this value will ever be YES.
 */
@property (nonatomic, assign, getter=shouldUseiAds) BOOL useiAds;

/*!
 * Indicates whether view has an ad loaded or not.
 *
 * This is always set to YES prior to calling advertViewDidReceiveAd: on delegate object.
 */
@property (nonatomic, assign, readonly) BOOL adLoaded;

/*!
 * Optional. View controller used to present ad response from.
 * If not set, library searches for first view controller by traversing
 * UIResponer chain from the ad view upwards.
 */
@property (nonatomic, weak, nullable) UIViewController *rootViewController;

/*! 
 * Creates new advert view for given size with origin in (0,0).
 * 
 * Size should be one of the constants defined in VWAdSize.h or a custom size created with
 * VWAdSizeFromCGSize method.
 */
- (nonnull instancetype)initWithSize:(VWAdSize)size;

/*!
 * Creates new advert view for given size and origin.
 *
 * Size should be one of the constants defined in VWAdSize.h or a custom size created with
 * VWAdSizeFromCGSize method.
 */
- (nonnull instancetype)initWithSize:(VWAdSize)size origin:(CGPoint)origin;

/*!
 * Requests a new ad. You'll be informed of result through delegate object.
 *
 * Will replace existing ad (if any) upon completion. You should call this method whenever screen
 * content changes significantly.
 */
- (void)loadRequest:(nonnull VWAdRequest *)request;

/*!
 * While laying out your view hierarchy, we strongly encourage you to use this method 
 * to determine size of the advert view. Pass size of superview for size argument.
 *
 * Library will calculate best size that fits superview size. Method will never return
 * size smaller than required by the loaded ad whose size is determed by the adSize property
 * of self, but it can return size that is wider than adSize so it nicely fills superview.
 *
 * Please checkout samples included with the SDK for best approaches on laying out your views.
 *
 */
- (CGSize)sizeThatFits:(CGSize)size;

/*!
 * (Optional) If the screen that is displaying the ad has a scrollable content, use this method
 * to pass information about scrollable size and offset to the ad. Ad might use that to provide more
 * interactive experience to the user.
 *
 *  - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *  {
 *    [self.adView setScrollableSize:scrollView.contentSize offset:scrollView.contentOffset];
 *  }
 */
- (void)setScrollableSize:(CGSize)size offset:(CGPoint)offset;

@end

