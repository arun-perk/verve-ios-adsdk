//
//  VWVerveServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Srdan Rasic on 25/09/14.
//  Copyright (c) 2014 Verve Wireless. All rights reserved.
//

import UIKit
import VerveAd

class VWVerveServerViewController: UIViewController, VWAdvertViewDelegate, VWInterstitialAdDelegate {
  
  var bannerAdView : VWAdvertView?
  var inlineAdView : VWAdvertView?
  var interstitial: VWInterstitialAd?
  
  
  //MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBannerAdView()
    addInlineAdView()
  }
  
  //MARK: - Banner Ads
  
  func addBannerAdView() {
    if bannerAdView == nil {
      let adSize: VWAdSize = UI_USER_INTERFACE_IDIOM() == .Pad ? kVWAdSizeLeaderboard : kVWAdSizeBanner
      
      bannerAdView = VWAdvertView(size: adSize)
      bannerAdView!.adPosition = VWAdvertPositionBottom
      bannerAdView!.delegate = self
      bannerAdView!.backgroundColor = UIColor.grayColor()
      
      let bounds : CGRect = view.bounds
      var adFrame : CGRect = CGRectZero
      
      adFrame.size = bannerAdView!.sizeThatFits(bounds.size)
      adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarController!.tabBar.frame.size.height
      
      bannerAdView!.frame = adFrame
      
      self.view?.addSubview(bannerAdView!)
    }
  }
  
  @IBAction func requestBannerAd() {
    if (bannerAdView != nil) {
      bannerAdView!.loadRequest(VWAdRequest(contentCategoryID : VWContentCategory.NewsAndInformation))
    }
  }
  
  
  //MARK: - Inline Ads
  
  func addInlineAdView() {
    if (inlineAdView == nil) {
      inlineAdView = VWAdvertView(size: kVWAdSizeMediumRectangle)
      
      inlineAdView!.adPosition = VWAdvertPositionInline
      inlineAdView!.delegate = self
      inlineAdView!.backgroundColor = UIColor.grayColor()
      
      let bounds : CGRect = view.bounds
      var adFrame : CGRect = CGRectZero
      
      adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
      inlineAdView!.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height)
      
      self.view?.addSubview(inlineAdView!)
    }
  }
  
  @IBAction func requestInlineAd() {
    if (inlineAdView != nil) {
      inlineAdView!.loadRequest(VWAdRequest(contentCategoryID : VWContentCategory.NewsAndInformation))
    }
  }
  
  
  //MARK: - Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    let adSize: VWInterstitialAdSize = UI_USER_INTERFACE_IDIOM() == .Pad ? VWInterstitialAdSizePad : VWInterstitialAdSizePhone
    
    interstitial = VWInterstitialAd.init(size: adSize)
    interstitial?.delegate = self
    
    let adRequest : VWAdRequest = VWAdRequest.init(contentCategoryID: VWContentCategory.NewsAndInformation)
    
    interstitial?.loadRequest(adRequest)
  }
  
  // MARK: - VWAdvertViewDelegate
  
  func advertViewDidReceiveAd(adView: VWAdvertView) {
    NSLog("adViewDidReceiveAd: %@", adView)
  }
  
  func advertView(adView: VWAdvertView, didFailToReceiveAdWithError error: NSError?) {
    if (error != nil) {
      NSLog("didFailToReceiveAdWithError: %@", error!)
    }
  }
  
  
  // MARK: - VWInterstitialDelegate
  func interstitialAdReceiveAd(interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdReceiveAd: %ld", interstitialAd)
    
    interstitial?.presentFromViewController(self)
  }
  
  func interstitialAd(interstitialAd: VWInterstitialAd, didFailToReceiveAdWithError error: NSError?) {
    if (error != nil) {
      NSLog("dismissInterstitialViewControllerVerveInterstitial: %@", error!)
    }
    
    interstitial = nil
  }
  
  func interstitialAdWillPresentAd(interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdWillPresentAd: %ld", interstitialAd);
  }
  
  func interstitialAdDidDismissAd(interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdDidDismissAd: %ld", interstitialAd);
    self.interstitial = nil;
  }
  
  func interstitialAdWillLeaveApplication(interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdWillLeaveApplication: %ld", interstitialAd);
    self.interstitial = nil;
  }
}

