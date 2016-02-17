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

@interface VWSplashAdView : UIView

/// Delegate object that receives state change notifications from this VWSplashAdView.
@property (nonatomic, weak, nullable) id<VWSplashAdViewDelegate> delegate;

- (nonnull instancetype)init; // let the SDK determine best size for the current user interface idiom
- (nonnull instancetype)initWithSize:(VWSplashAdSize)size;

- (void)loadRequest:(nonnull VWAdRequest *)adRequest; // displaySeconds = 4, loadTimeout = 1.5
- (void)loadRequest:(nonnull VWAdRequest *)adRequest displaySeconds:(NSTimeInterval)displaySeconds loadTimeout:(NSTimeInterval)loadTimeout;

@end

@protocol VWSplashAdViewDelegate <NSObject>
@optional
- (void)splashAdViewDidReceiveAd:(nonnull VWSplashAdView *)splashAdView;
- (void)splashAdView:(nonnull VWSplashAdView *)splashAdView didFailToReceiveAdWithError:(nullable NSError *)error;
- (void)splashAdViewShouldBeDismissed:(nonnull VWSplashAdView *)splashAdView;
@end
