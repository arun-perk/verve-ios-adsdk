//
//  VWAdLibrary.h
//  VWAdLibrary
//
//  Copyright (c) 2014 Verve Wireless, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * Name of string value in Info.plist containing the partner keyword used for ad requests.
 *
 * Partner keyword is used to allocate revenue for the ads you display, so it's very important
 * that you specify it unless you're also using Verve Content API.
 *
 * When using the Verve Content API, you should not set this value.
 */
#define kVWOnlineAdsKeyword @"kVWOnlineAdsKeyword"

/*!
 * Name of string value in Standard User Defaults containing the base URL used for ad requests.
 * Should be used only in conjunction with Verve Content API! Otherwise ignore.
 * Typically this will look something like:
 *
 *   https://adcel.vrvm.com/banner?b=dailyplanet&p=iphn
 *
 * This base URL should specify your Verve-assigned partner (b=) and portal (p=) keywords.
 *
 * When not using the Verve Content API, use kVWOnlineAdsKeyword
 * to specify your partner keyword and ignore this key.
 */
#define kVWOnlineAdsBaseURL @"kVWOnlineAdsBaseURL"


/*!
 * Use this key in Standard User Defaults to control geofencing attribution. It is enabled by default.
 * You need to set this key before using any of Ad SDK's methods, preferably in application:didFinishLaunchingWithOptions:.
 */
extern NSString * _Nonnull const VWAdLibraryAdvertisingAttributionEnabled;

/*!
 * Following keys are used to set request parameters when using Google Mobile Ads SDK's mediation.
 * All parameters are optional. Default content category used is News and Information.
 * Pass parameters in following way:
 *
 * NSDictionary *extras = @{ kVWGADExtraContentCategoryIDKey: @(VWContentCategoryNewsAndInformation),
 *                           kVWGADExtraDisplayBlockIDKey: @(15995) };
 *
 * GADCustomEventExtras *customEventExtras = [[GADCustomEventExtras alloc] init];
 * [customEventExtras setExtras:extras forLabel:@"Verve Ad Network"];
 *
 * GADRequest *request = [GADRequest request];
 * [request registerAdNetworkExtras:customEventExtras];
 */
extern NSString * _Nonnull const kVWGADExtraContentCategoryIDKey;  // NSNumber
extern NSString * _Nonnull const kVWGADExtraDisplayBlockIDKey;     // NSNumber
extern NSString * _Nonnull const kVWGADExtraPartnerModuleIDKey;    // NSNumber
extern NSString * _Nonnull const kVWGADExtraPostalCodeKey;         // NSString

@class VWAdRequest;
@class CLLocation;

typedef enum : NSUInteger {
  VWAdLogPrintLevelInfo,  // default
  VWAdLogPrintLevelWarning,
  VWAdLogPrintLevelError
} VWAdLogPrintLevel;

@protocol VWAdLibraryDelegate <NSObject>

@optional

/*!
 * Ad Library will request authorization for location services at first instance it needs location. If you wish to
 * disallow authorization request, implement this delegate method and return NO. If at some point later library 
 * should be allowed to proceed with authorization request, just return YES.
 *
 * Ad Library will call this method whenever it needs location but CLLocationManager's status equals NotDetermined.
 *
 * If NSLocationAlwaysUsageDescription key is set, Library will request 'always' authorization.
 * If NSLocationAlwaysUsageDescription key is not set, but NSLocationWhenInUseUsageDescription is, Library will
 *    ask for 'when in use' authorization.
 * If neither key is set, library will not request authoriation for location services by itself even if this
 * method returns YES.
 */
- (BOOL)shouldAdLibraryRequestAuthorizationForLocationServices;

@end

@interface VWAdLibrary : NSObject

/*!
 * Returns version number of the library.
 */
+ (nonnull NSString *)sdkVersion;

/*!
 * If you've not disabled advertising attribution, you must implement
 * application:performFetchWithCompletionHandler: method of your application's delegate 
 * and call this method within it. If your application does not use background fetch itself,
 * just pass completionHandler block you got from application:performFetchWithCompletionHandler: method,
 * like this:
 *
 * -(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
 * {
 *   [VWAdLibrary performFetchWithCompletionHandler:completionHandler];
 * }
 *
 * Otherwise, you should pass your custom block here and use that block to be notified when library is done with processing.
 *
 * If you've disabled advertising attribution, you can ignore this method.
 */
+ (BOOL)performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler;


/*!
 * Shared instance.
 */
+ (nonnull VWAdLibrary *)shared;

/*!
 * Set desired log print level. Default is .Info.
 */
- (void)setLogPrintLevel:(VWAdLogPrintLevel)level;

/*!
 * Delegate.
 */
@property (nonatomic, weak, nullable) id<VWAdLibraryDelegate> delegate;

/*!
 * Partner keyword you specified in Info.plist file (kVWOnlineAdsKeyword). If you did not specify
 * partner keyword in Info.plist, you must set it here prior to creating any ad views. You can change
 * this at any time. Value set here has higher priority than what's in Info.plist.
 */
@property (nonatomic, copy, nullable) NSString *partnerKeyword;

/*!
 * Boolean value indicating whether geofence monitoring is enabled.
 */
@property (nonatomic, readonly) BOOL geofenceMonitoringRunning;

/*!
 * Set this property to reserve number of region monitoring slots available for the app.
 * Default value is 0.
 *
 * @warning You should not modify this value unless your app also monitores regions - a shared system resource.
 */
@property (nonatomic, assign) NSInteger geofenceReservedSlots;

/*!
 * Set this property to reserve number of beacon monitoring slots available for the app.
 * Default value is 0.
 *
 * @warning You should not modify this value unless your app also monitores beacons - a shared system resource.
 */
@property (nonatomic, assign) NSInteger beaconReservedSlots;

/*!
 * Latest acquired location. Updated on init and applicationDidBecomeActive with 1km desired accuracy.
 * When location services are enabled, should never be nil, but might be outdated.
 */
@property (nonatomic, readonly, nullable) CLLocation *sessionLocation;

@end
