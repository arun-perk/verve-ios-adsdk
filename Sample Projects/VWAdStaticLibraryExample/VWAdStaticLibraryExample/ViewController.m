//
//  ViewController.m
//  VWAdStaticLibraryExample
//
//  Created by Srdan Rasic on 27/06/16.
//  Copyright © 2016 Verve Mobile. All rights reserved.
//

#import "ViewController.h"
#import "VWAdvertView.h"

@interface ViewController ()<VWAdvertViewDelegate>
@property (strong, nonatomic) VWAdvertView *bannerAdView;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  VWAdSize size = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kVWAdSizeLeaderboard : kVWAdSizeBanner;
  self.bannerAdView = [[VWAdvertView alloc] initWithSize:size];
  self.bannerAdView.adPosition = VWAdvertPositionBottom;
  self.bannerAdView.delegate = self;

  CGRect bounds = self.view.bounds;
  CGRect adFrame = CGRectZero;
  adFrame.size = [self.bannerAdView sizeThatFits:bounds.size];
  adFrame.origin.y = bounds.size.height - adFrame.size.height;
  self.bannerAdView.frame = adFrame;

  [self.view addSubview:self.bannerAdView];

  VWAdRequest *adRequest = [VWAdRequest requestWithContentCategoryID:VWContentCategoryNewsAndInformation];
  [self.bannerAdView loadRequest:adRequest];
}

- (void)advertViewDidReceiveAd:(VWAdvertView *)adView
{
  //do tasks when the advertising view receives an ad
}

- (void)advertView:(VWAdvertView *)adView didFailToReceiveAdWithError:(NSError *)error
{
  //do tasks when the advertising view fails to receive an ad
}

@end
