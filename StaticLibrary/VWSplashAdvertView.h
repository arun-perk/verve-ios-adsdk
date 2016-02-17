//
//  VWSplashAdvertView.h
//  VWAdLibrary
//
//  Copyright (c) 2012 Verve Wireless, Inc.//
#import <CoreLocation/CoreLocation.h>
#import "VWContentCategory.h"

@class VWSplashAdvertPolicy;
@protocol VWSplashAdvertViewDelegate;

__deprecated_msg("VWSplashAdvertView has been deprecated and will be removed in future versions. Please use VWInterstitialAdManager instead.")
@interface VWSplashAdvertView : UIView
@property (nonatomic, weak) id <VWSplashAdvertViewDelegate> delegate;
@property (nonatomic) CLLocation *location;
@property (nonatomic, copy) NSString *postalCode; /* Useful if you don't have lat/long handy. */

+ (VWSplashAdvertView*)splashAdvertViewWithFrame:(CGRect)frame contentCategoryID:(VWContentCategory)contentCategory;
+ (VWSplashAdvertView*)splashAdvertViewWithFrame:(CGRect)frame contentCategoryID:(VWContentCategory)contentCategory displayBlockID:(NSInteger)displayBlock;
- (void)loadWithDelegate:(id<VWSplashAdvertViewDelegate>)delegate;
@end

__deprecated_msg("VWSplashAdvertPolicy has been deprecated and will be removed in future versions. Please use VWSplashAdManager instead.")
@interface VWSplashAdvertPolicy : NSObject
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, assign) NSUInteger impressionFrequency;
@property (nonatomic, assign) NSTimeInterval impressionInterval;
@property (nonatomic, assign) NSTimeInterval loadTimeout;
@property (nonatomic, assign) NSUInteger displaySeconds;

+ (VWSplashAdvertPolicy*)sharedPolicy;
- (void)resetConfiguration;
@end

__deprecated_msg("VWSplashAdvertViewDelegate has been deprecated and will be removed in future versions. Please use VWSplashAdManager instead.")
@protocol VWSplashAdvertViewDelegate <NSObject>
- (void)verveSplashAdvertView:(VWSplashAdvertView*)advertView didReceiveResponse:(BOOL)success;
- (void)verveSplashAdvertView:(VWSplashAdvertView*)advertView didFinishAfterDisplay:(BOOL)advertDisplayed;
@end
