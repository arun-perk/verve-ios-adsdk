//
//  VWInterstitialAdManager.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 05/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWInterstitialAd.h"

@protocol VWInterstitialAdManagerDelegate;

///
/// A VWInterstitialAdManager is a long-lived object which you typically use to
/// control the frequency and display of interstitials based on screen transitions.
///
/// You configure the overall display policy and then notify the manager of each
/// important screen transition. The manager will create interstititials as appropriate
/// and notify you (via delegate callbacks) when an interstitial is ready for presentation.
///
/// You can create as many interstitials as you like, but you typically would never need
/// more than one application-wide manager. The library provides a shared default manager
/// for such use.
///
@interface VWInterstitialAdManager : NSObject

/// By default the manager is enabled.
@property (nonatomic, assign) BOOL enabled;

/// The loadFrequency controls how many transitions must occur before an interstitial is
/// requested. Default value is 5.
@property (nonatomic, assign) NSUInteger loadFrequency;

/// The impressionInterval is the minimum amount of time which must pass after a
/// full-screen ad impression before an interstitial can be requested or presented.
///
/// The purpose of this value is to ensure users are not overloaded with full-screen
/// interruptions. The value has an effect across application restarts.
///
/// It's important to note that full-screen landing pages for banner ads
/// and splash ads count as full-screen ad impressions.  Default value is 60.
@property (nonatomic, assign) NSTimeInterval impressionInterval;

/// You can register a delegate to be notified when the interstitial is ready. Alternatively, you can
/// manually check if the `intersitialAdToDisplay` is set on the next screen transition.
@property (nonatomic, weak, nullable) id<VWInterstitialAdManagerDelegate> delegate;

/// When a call to `countInterstitialAdTransitionForRequest` satisfies all the parameters, the
/// manager will request and load the interstitial and store it into this property.
///
/// The interstitial is guaranteed to be in `ready` state so there is not need to check `ìsReady`.
///
/// Once you use (present) this interstitial, it will automatically be removed the property.
@property (nonatomic, readonly, nullable) VWInterstitialAd *intersitialAdToDisplay;

+ (nonnull instancetype)defaultManager;
+ (nonnull instancetype)managerNamed:(nonnull NSString *)name;

/// On each screen transition, call this method. Once all the parameters have been satisfied, the
/// manager will request and load the interstitial. If you've setup a delegate, you'll be notified when
/// the interstitial is loaded. Once it is loaded, it will be stored into the `intersitialAdToDisplay` property.
/// Any subsequent calls to `countInterstitialAdTransitionForRequest:` will be ignored until the interstitial
/// has been used (presented).
- (void)countInterstitialAdTransitionForRequest:(nonnull VWAdRequest *)adRequest size:(VWInterstitialAdSize)size;

/// Same as previous, just let the SDK determine best size for the current user interface idiom.
- (void)countInterstitialAdTransitionForRequest:(nonnull VWAdRequest *)adRequest;

@end


////
/// Conform to this protocol to receive events from VWInterstitialAdManager.
////
@protocol VWInterstitialAdManagerDelegate <NSObject>
@optional

/// Interstitial manager will call this method just after setting the `intersitialAdToDisplay` property.
/// You can then use (present) the interstitial from that propery. The interstitial is guaranteed to be in the `ready` state.
/// Once you use (present) the interstitial, it will be automatically removed from the manager's `intersitialAdToDisplay` property.
- (void)intersitialAdManagerDidLoadInterstitialAd:(nonnull VWInterstitialAdManager *)intersitialAdManager;

- (void)intersitialAdManager:(nonnull VWInterstitialAdManager *)intersitialAdManager didFailToLoadInterstitialAdWithError:(nonnull NSError *)error;

@end
