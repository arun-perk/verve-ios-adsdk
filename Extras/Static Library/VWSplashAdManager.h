//
//  VWSplashAdManager.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 09/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWSplashAdManager : NSObject

/// By default the manager is enabled.
@property (nonatomic, assign) BOOL enabled;

/// The loadFrequency controls how many app launches must occur before splash is requested.
@property (nonatomic, assign) NSUInteger loadFrequency;

/// The impressionInterval is the minimum amount of time which must pass after a
/// full-screen ad impression before splash can be requested or presented.
///
/// The purpose of this value is to ensure users are not overloaded with full-screen
/// interruptions. The value has an effect across application restarts.
///
/// It's important to note that full-screen landing pages for banner ads
/// and interstitials count as full-screen ad impressions.
@property (nonatomic, assign) NSTimeInterval impressionInterval;

+ (nonnull instancetype)defaultManager;

/// On each application launch call this method. Once all the parameters have been satisfied, the method
/// will return YES and you can proceed with creation and loading of VWSplashAdView.
- (BOOL)shouldLoadSplashAdForThisAppLaunch;

@end
