//
//  VWAppNexusServerViewController.m
//  VWMasterApplication
//
//  Created by Danijel Lombarovic on 20/09/16.
//  Copyright © 2016 Christina Long. All rights reserved.
//

#import "VWAppNexusServerViewController.h"
#import "ANBannerAdView.h"
#import "ANInterstitialAd.h"
#import <VerveAd/VerveAd.h>
#import "ANSDKSettings.h"

static NSString *const kPlacementIdBanner = @"11113606";
static NSString *const kPlacementIdBannerTablet = @"11113608";
static NSString *const kPlacementIdInline = @"11113607";
static NSString *const kPlacementIdInterstitial = @"11113611";

@interface VWAppNexusServerViewController () <ANBannerAdViewDelegate, ANInterstitialAdDelegate>

@property (strong, nonatomic) ANBannerAdView *bannerAdView;
@property (strong, nonatomic) ANBannerAdView *inlineAdView;
@property (strong, nonatomic) ANInterstitialAd *interstitialAdView;

@end

@implementation VWAppNexusServerViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  BOOL canUseHTTP = NO;
  NSDictionary *appTransportSecurity =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"NSAppTransportSecurity"];
  
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    canUseHTTP = !([appTransportSecurity valueForKey:@"NSAllowsArbitraryLoadsInWebContent"] || [appTransportSecurity valueForKey:@"NSAllowsArbitraryLoadsInMedia"] || [appTransportSecurity valueForKey:@"NSAllowsLocalNetworking"]) && [[appTransportSecurity valueForKey:@"NSAllowsArbitraryLoads"] boolValue];
  } else {
    canUseHTTP = [[appTransportSecurity valueForKey:@"NSAllowsArbitraryLoads"] boolValue];
  }
  
  [ANSDKSettings sharedInstance].HTTPSEnabled = !canUseHTTP;

  
  [self addBannerAdView];
  [self addInlineAdView];
}


#pragma mark - Banner Ad

- (void)addBannerAdView {
 
  //determine size and farame for banner ad
  CGRect bounds = self.view.bounds;
  CGSize adSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(728, 90) : CGSizeMake(320, 50);
  
  CGRect adFrame = CGRectMake((bounds.size.width - adSize.width)/2, bounds.size.height - adSize.height - self.tabBarController.tabBar.frame.size.height, adSize.width, adSize.height);
  
  NSString *placementID = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? kPlacementIdBannerTablet : kPlacementIdBanner;
  self.bannerAdView = [ANBannerAdView adViewWithFrame:adFrame placementId:placementID adSize:adSize];
  self.bannerAdView.rootViewController = self;
  self.bannerAdView.autoRefreshInterval = 0;
  self.bannerAdView.delegate = self;
  self.bannerAdView.backgroundColor = [UIColor grayColor];
  
  //ad the banner ad to the view
  [self.view addSubview:self.bannerAdView];
}

- (IBAction)requestBannerAd:(id)sender {
  [self.bannerAdView loadAd];
}


#pragma mark - Inline Ad

- (void)addInlineAdView {

  //determine size and frame for the inline ad
  CGRect bounds = self.view.bounds;
  CGSize adSize = CGSizeMake(300, 250);
  
  CGRect adFrame = CGRectMake((bounds.size.width - adSize.width)/2, (bounds.size.height - adSize.height)/2, adSize.width, adSize.height);
  
  self.inlineAdView = [ANBannerAdView adViewWithFrame:adFrame placementId:kPlacementIdInline adSize:adSize];
  self.inlineAdView.rootViewController = self;
  self.inlineAdView.autoRefreshInterval = 0;
  self.inlineAdView.delegate = self;
  self.inlineAdView.backgroundColor = [UIColor grayColor];
  
  //add the inline ad to the view
  [self.view addSubview:self.inlineAdView];
}

- (IBAction)requestInlineAd:(id)sender {
  [self.inlineAdView loadAd];
}


#pragma mark - Interstitial Ad

- (IBAction)requestInterstitialAd:(id)sender {
  self.interstitialAdView = [[ANInterstitialAd alloc] initWithPlacementId:kPlacementIdInterstitial];
  self.interstitialAdView.delegate = self;
  [self.interstitialAdView loadAd];
}


#pragma mark - ANBannerAdViewDelegate

- (void)adDidReceiveAd:(id<ANAdProtocol>)ad
{
  NSLog(@"adDidReceiveAd: %@", [ad placementId]);
  if ([ad isEqual:self.interstitialAdView]) {
    [self.interstitialAdView displayAdFromViewController:self];
  }
}

- (void)ad:(id<ANAdProtocol>)ad requestFailedWithError:(NSError *)error
{
  NSLog(@"ad:requestFailedWithError: %@", [ad placementId]);
}

- (void)adWasClicked:(id<ANAdProtocol>)ad
{
  NSLog(@"adWasClicked: %@", [ad placementId]);
}

- (void)adWillClose:(id<ANAdProtocol>)ad
{
  NSLog(@"adWillClose: %@", [ad placementId]);
}

- (void)adDidClose:(id<ANAdProtocol>)ad
{
  NSLog(@"adDidClose: %@", [ad placementId]);
}

- (void)adWillPresent:(id<ANAdProtocol>)ad
{
  NSLog(@"adWillPresent: %@", [ad placementId]);
}

- (void)adDidPresent:(id<ANAdProtocol>)ad
{
  NSLog(@"adDidPresent: %@", [ad placementId]);
}

- (void)adWillLeaveApplication:(id<ANAdProtocol>)ad
{
  NSLog(@"adWillLeaveApplication: %@", [ad placementId]);
}


#pragma mark - ANInterstitialAdDelegate

- (void)adFailedToDisplay:(ANInterstitialAd *)ad
{
  NSLog(@"adFailedToDisplay: %@", [ad placementId]);
}

@end
