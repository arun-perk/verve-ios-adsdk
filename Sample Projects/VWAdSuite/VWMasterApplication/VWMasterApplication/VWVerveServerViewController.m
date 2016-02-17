//
//  VWVerveServerViewController.m
//  VWMasterApplication
//
//  Created by Christina Long on 9/25/15.
//  Copyright (c) 2015 Christina Long. All rights reserved.
//

#import "VWVerveServerViewController.h"
#import <VWAdvertView.h>
#import <VWInterstitialAd.h>

@interface VWVerveServerViewController () <VWInterstitialAdDelegate, VWAdvertViewDelegate>

@property (strong, nonatomic) VWAdvertView *bannerAdView;
@property (strong, nonatomic) VWAdvertView *inlineAdView;
@property (strong, nonatomic) VWInterstitialAd *interstitial;

@end


#pragma mark - View Controller Lifecycle

@implementation VWVerveServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBannerAdView];
    [self addInlineAdView];
}

#pragma mark - Banner Ad Code

-(void)addBannerAdView {
    //determine size for device
    VWAdSize size = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kVWAdSizeLeaderboard : kVWAdSizeBanner;
    
    self.bannerAdView = [[VWAdvertView alloc] initWithSize:size];
    self.bannerAdView.adPosition = VWAdvertPositionBottom;
    self.bannerAdView.delegate = self;
    self.bannerAdView.backgroundColor = [UIColor grayColor];

    //determine size/frame for banner Ad
    CGRect bounds = self.view.bounds;
    CGRect adFrame = CGRectZero;
    
    adFrame.size = [self.bannerAdView sizeThatFits:bounds.size];
    adFrame.origin.y = bounds.size.height - adFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    
    self.bannerAdView.frame = adFrame;
    
    //ad the banner ad to the view
    [self.view addSubview:self.bannerAdView];
}

- (IBAction)requestBannerAd:(id)sender {
    [self.bannerAdView loadRequest:[VWAdRequest requestWithContentCategoryID:VWContentCategoryNewsAndInformation]];
}


#pragma mark - Inline Ad Code

-(void)addInlineAdView {
    //add the inline ad view
    self.inlineAdView = [[VWAdvertView alloc] initWithSize:kVWAdSizeMediumRectangle];
    self.inlineAdView.adPosition = VWAdvertPositionInline;
    self.inlineAdView.delegate = self;
    self.inlineAdView.backgroundColor = [UIColor grayColor];

    //determine frame and size for the view
    CGRect bounds = self.view.bounds;
    CGRect adFrame = CGRectZero;
    
    adFrame.size = [self.inlineAdView sizeThatFits:bounds.size];
    self.inlineAdView.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height);
    
    [self.view addSubview:self.inlineAdView];
}

- (IBAction)requestInlineAd:(id)sender {
    [self.inlineAdView loadRequest:[VWAdRequest requestWithContentCategoryID:VWContentCategoryNewsAndInformation]];
}

#pragma mark - VWAdvertViewDelegate

- (void)advertViewDidReceiveAd:(VWAdvertView *)adView {
    //handle successful ad
}

- (void)advertView:(VWAdvertView *)adView didFailToReceiveAdWithError:(NSError *)error {
    //handle error condition
}

#pragma mark - Interstitial Ad Code

- (IBAction)requestIntersititalAd:(id)sender {
    VWInterstitialAdSize interstitialAdSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? VWInterstitialAdSizePad : VWInterstitialAdSizePhone;
    
    self.interstitial = [[VWInterstitialAd alloc] initWithSize:interstitialAdSize];
    self.interstitial.delegate = self;
    
    VWAdRequest *adRequest = [VWAdRequest requestWithContentCategoryID:VWContentCategoryNewsAndInformation];
    
    [self.interstitial loadRequest:adRequest];
}

#pragma mark - VWInterstitialAdDelegate

- (void)interstitialAdReceiveAd:(nonnull VWInterstitialAd *)interstitialAd {
    [self.interstitial presentFromViewController:self];
}

- (void)interstitialAd:(nonnull VWInterstitialAd *)interstitialAd didFailToReceiveAdWithError:(nullable NSError *)error {
    self.interstitial = nil;
}

- (void)interstitialAdWillPresentAd:(nonnull VWInterstitialAd *)interstitialAd {
}

- (void)interstitialAdDidDismissAd:(nonnull VWInterstitialAd *)interstitialAd {
    self.interstitial = nil;
}

- (void)interstitialAdWillLeaveApplication:(nonnull VWInterstitialAd *)interstitialAd {
    self.interstitial = nil;
}

@end
