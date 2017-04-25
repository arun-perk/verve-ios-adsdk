//
//  VWSplashAd.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 09/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VWAdRequest.h"

typedef enum : NSUInteger {
  VWSplashAdSizePhone,
  VWSplashAdSizePad
} VWSplashAdSize;

@protocol VWSplashAdViewDelegate;

/**
 VWSplashAdView represents a splash ad view.
 */
@interface VWSplashAdView : UIView

/// Delegate object that receives state change notifications from this VWSplashAdView.
@property (nonatomic, weak, nullable) id<VWSplashAdViewDelegate> delegate;

- (nonnull instancetype)init; // let the SDK determine best size for the current user interface idiom
- (nonnull instancetype)initWithSize:(VWSplashAdSize)size;

/**
 Requests a new ad. You'll be informed of result through the delegate object.

 @param adRequest Request for a new splash ad
 */
- (void)loadRequest:(nonnull VWAdRequest *)adRequest; // displaySeconds = 4, loadTimeout = 1.5
/**
 Requests a new ad. You'll be informed of result through the delegate object.

 @param adRequest Request for a new splash ad
 @param displaySeconds Splash ad duration
 @param loadTimeout Splash ad loading timeout
 */
- (void)loadRequest:(nonnull VWAdRequest *)adRequest displaySeconds:(NSTimeInterval)displaySeconds loadTimeout:(NSTimeInterval)loadTimeout;

@end

/**
 Conform to this protocol to receive events from VWSplashAdView.
 */
@protocol VWSplashAdViewDelegate <NSObject>
@optional
/**
 This method will be called when splash ad view is prepared and ready for showing.

 @param splashAdView Splash view that should be presented.
 */
- (void)splashAdViewDidReceiveAd:(nonnull VWSplashAdView *)splashAdView;
/**
 Splash view will call this method when some error occurs.

 @param splashAdView Presented splash view.
 @param error Error
 */
- (void)splashAdView:(nonnull VWSplashAdView *)splashAdView didFailToReceiveAdWithError:(nullable NSError *)error;
/**
 This method will be called when splash view should be closed.

 @param splashAdView Splash view that should be closed.
 */
- (void)splashAdViewShouldBeDismissed:(nonnull VWSplashAdView *)splashAdView;
@end
