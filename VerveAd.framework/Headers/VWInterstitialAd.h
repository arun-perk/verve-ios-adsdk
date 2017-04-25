//
//  VWInterstitialAd.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWAdRequest.h"
#import "VWFullscreenAdViewController.h"

typedef enum : NSUInteger {
  VWInterstitialAdSizePhone,
  VWInterstitialAdSizePad
} VWInterstitialAdSize;

@protocol VWInterstitialAdDelegate;

///
/// Interstitial object is used to load single Interstitial Ad
/// and control its presentation. It cannot be reused.
///
@interface VWInterstitialAd : NSObject

/// Delegate object that receives state change notifications from this VWInterstitialAd.
@property (nonatomic, weak, nullable) id<VWInterstitialAdDelegate> delegate;

/// Returns YES if the interstitial is ready to be displayed. The delegate's
/// interstitialAdDidReceiveAd: will be called after this property switches from NO to YES.
@property(nonatomic, readonly, assign) BOOL isReady;

/// Returns YES if this object has already been presented. Interstitial objects can only be used
/// once even with different requests.
@property(nonatomic, readonly, assign) BOOL hasBeenUsed;

- (nonnull instancetype)init; // let the SDK determine best size for the current user interface idiom
- (nonnull instancetype)initWithSize:(VWInterstitialAdSize)size;
/**
 Requests a new ad. You'll be informed of result through the delegate object.

 @param adRequest Request for a new ad
 */
- (void)loadRequest:(nonnull VWAdRequest *)adRequest;

/// Make sure the interstitial is ready and not used before calling this method.
///
/// Calling it will present the interstitial and mark it as used. You can call this method only once.
- (void)presentFromViewController:(nonnull UIViewController *)viewController;

/// If the method `presentFromViewController:` does not play well with your UI/UX, use this method
/// to get the view controller with the ad loaded and then present it manually.
///
/// Make sure the interstitial is ready and not used before calling this method.
///
/// When this view controller receives `viewDidAppear` it will mark the interstitial as `hasBeenUsed`.
- (nullable VWFullscreenAdViewController *)viewControllerForCustomPresentation;

@end

/**
 Conform to this protocol to receive events from VWInterstitialAd.
 */
@protocol VWInterstitialAdDelegate <NSObject>
@required
- (void)interstitialAdReceiveAd:(nonnull VWInterstitialAd *)interstitialAd;
@optional
- (void)interstitialAd:(nonnull VWInterstitialAd *)interstitialAd didFailToReceiveAdWithError:(nullable NSError *)error;
- (void)interstitialAdWillPresentAd:(nonnull VWInterstitialAd *)interstitialAd;
- (void)interstitialAdWillDismissAd:(nonnull VWInterstitialAd *)interstitialAd;
- (void)interstitialAdDidDismissAd:(nonnull VWInterstitialAd *)interstitialAd;
- (void)interstitialAdWillLeaveApplication:(nonnull VWInterstitialAd *)interstitialAd;
@end
