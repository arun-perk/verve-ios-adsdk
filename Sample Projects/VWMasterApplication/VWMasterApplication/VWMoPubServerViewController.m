//
//  VWMoPubServerViewController.m
//  VWMasterApplication
//
//  Created by Christina Long on 10/2/15.
//  Copyright © 2015 Christina Long. All rights reserved.
//

#import "VWMoPubServerViewController.h"
#import "MoPub.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"

static NSString *const kBannerAdUnit = @"81e4362779af4f31b392223cece421a3";
static NSString *const kInlineAdUnit = @"12a8caf3a56e40a5a883b36f910f8d96";
static NSString *const kInterstitialAdUnit = @"400efb79cbfd4063a777d471ac25c795";
static NSString *const kLeaderboardAdUnit = @"83023bd000f44a12a02de151b1664e30";

@interface VWMoPubServerViewController () <MPAdViewDelegate, MPInterstitialAdControllerDelegate>

@property (strong, nonatomic) MPAdView *bannerAdView;
@property (strong, nonatomic) MPAdView *inlineAdView;
@property (strong, nonatomic) MPInterstitialAdController *interstitialAdView;

@end

@implementation VWMoPubServerViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MoPub SDK version: %@", [[MoPub sharedInstance] version]);
    
    [self addBannerAdView];
    [self addInlineAdView];
}


#pragma mark - Banner Ad

-(void)addBannerAdView {
    //determine size for device
    CGSize size = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? MOPUB_LEADERBOARD_SIZE : MOPUB_BANNER_SIZE;
    NSString *adUnit = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kLeaderboardAdUnit : kBannerAdUnit;
    
    self.bannerAdView = [[MPAdView alloc] initWithAdUnitId:adUnit size:size];
    self.bannerAdView.delegate = self;
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
    [self.bannerAdView loadAd];
}


#pragma mark - Inline Ad

-(void)addInlineAdView {
    //add the inline ad view
    self.inlineAdView = [[MPAdView alloc] initWithAdUnitId:kInlineAdUnit size:MOPUB_MEDIUM_RECT_SIZE];
    self.inlineAdView.delegate = self;
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
    [self.inlineAdView loadAd];
}


#pragma mark - Interstitial Ad

- (IBAction)requestInterstitialAd:(id)sender {
    if (!self.interstitialAdView) {
        self.interstitialAdView = [MPInterstitialAdController interstitialAdControllerForAdUnitId:kInterstitialAdUnit];
        self.interstitialAdView.delegate = self;
    }
    
    [self.interstitialAdView loadAd];
}


#pragma mark - MPAdViewDelegate

- (void)adViewDidLoadAd:(MPAdView *)view {
    NSLog(@"adViewDidReceiveAd:");
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view {
    NSLog(@"adView:didFailToReceiveAdWithError:");
}

- (UIViewController *)viewControllerForPresentingModalView {
    NSLog(@"viewControllerForPresentingModalView");
    return self;
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"willPresentModalViewForAd:");
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"didDismissModalViewForAd:");
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"willLeaveApplicationFromAd:");
}


#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidLoadAd:");
    
    [interstitial showFromViewController:self];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidFailToLoadAd:");
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillAppear:");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidAppear:");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillDisappear:");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidDisappear:");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidExpire:");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidReceiveTapEvent:");
}

@end
