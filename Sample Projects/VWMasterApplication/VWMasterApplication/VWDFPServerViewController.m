//
//  VWDFPServerViewController.m
//  
//
//  Created by Christina Long on 10/1/15.
//  Copyright (c) 2015 Christina Long. All rights reserved.
//

#import "VWDFPServerViewController.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADCustomEventExtras.h>
#import <VerveAd/VerveAd.h>

static NSString *const kBannerAdUnit = @"/11027047/vrvadmob";
static NSString *const kInlineAdUnit = @"/11027047/vrvadmob";
static NSString *const kInterstitialAdUnit = @"/11027047/vrvadmobint";
static NSString *const kCustomEventLabel = @"Verve Ad Network";

@interface VWDFPServerViewController () <GADBannerViewDelegate, GADInterstitialDelegate>

@property (strong, nonatomic) GADBannerView *bannerAdView;
@property (strong, nonatomic) GADBannerView *inlineAdView;
@property (strong, nonatomic) GADInterstitial *interstitialAdView;

@end

@implementation VWDFPServerViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);
    
    [self addBannerAdView];
    [self addInlineAdView];
}


#pragma mark - Banner Ad

- (void)addBannerAdView {
    //determine size for device
    GADAdSize size = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kGADAdSizeLeaderboard : kGADAdSizeBanner;
    
    self.bannerAdView = [[GADBannerView alloc] initWithAdSize:size];
    self.bannerAdView.delegate = self;
    self.bannerAdView.rootViewController = self;
    self.bannerAdView.adUnitID = kBannerAdUnit;
    self.bannerAdView.backgroundColor = [UIColor grayColor];

    
    //determine size/frame for banner Ad
    CGRect bounds = self.view.bounds;
    CGRect adFrame = CGRectZero;
    
    adFrame.size = [self.bannerAdView sizeThatFits:bounds.size];
    adFrame.origin.x = (bounds.size.width - adFrame.size.width)/2;
    adFrame.origin.y = bounds.size.height - adFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    
    self.bannerAdView.frame = adFrame;
    
    //ad the banner ad to the view
    [self.view addSubview:self.bannerAdView];
}

- (IBAction)requestBannerAd:(id)sender {
    [self.bannerAdView loadRequest:[self newRequest]];
}


#pragma mark - Inline Ad

- (void)addInlineAdView {
    //add the inline ad view
    self.inlineAdView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    self.inlineAdView.delegate = self;
    self.inlineAdView.rootViewController = self;
    self.inlineAdView.adUnitID = kInlineAdUnit;
    self.inlineAdView.backgroundColor = [UIColor grayColor];
    
    //determine frame and size for the view
    CGRect bounds = self.view.bounds;
    CGRect adFrame = CGRectZero;
    
    adFrame.size = [self.inlineAdView sizeThatFits:bounds.size];
    self.inlineAdView.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height);
    
    //add the inline ad view
    [self.view addSubview:self.inlineAdView];
}

- (IBAction)requestInlineAd:(id)sender {
    [self.inlineAdView loadRequest:[self newRequest]];
}


#pragma mark - Interstitial Ad

- (IBAction)requestInterstitialAd:(id)sender {
    self.interstitialAdView = [[GADInterstitial alloc] initWithAdUnitID:kInterstitialAdUnit];
    self.interstitialAdView.delegate = self;
    [self.interstitialAdView loadRequest:[self newRequest]];
}


#pragma mark - Ad Request

- (GADRequest *)newRequest {
    //optional paramters
    NSDictionary *extras = @{ kVWGADExtraContentCategoryIDKey: @(VWContentCategoryNewsAndInformation)};
    
    GADCustomEventExtras *customEventExtras = [[GADCustomEventExtras alloc] init];
    
    [customEventExtras setExtras:extras forLabel:kCustomEventLabel];
    
    // Make request
    GADRequest *request = [GADRequest request];
    [request registerAdNetworkExtras:customEventExtras];
    
    return request;
}


#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"adViewDidReceiveAd: %@", view.adNetworkClassName);
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", view.adNetworkClassName);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication: %@", adView.adNetworkClassName);
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen: %@", adView.adNetworkClassName);
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen: %@", adView.adNetworkClassName);
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen: %@", adView.adNetworkClassName);
}


#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd: %@", ad.adNetworkClassName);
    [self.interstitialAdView presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    self.interstitialAdView = nil;
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen: %@", ad.adNetworkClassName);
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen: %@", ad.adNetworkClassName);
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen: %@", ad.adNetworkClassName);
    self.interstitialAdView = nil;
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication: %@", ad.adNetworkClassName);
}

@end
