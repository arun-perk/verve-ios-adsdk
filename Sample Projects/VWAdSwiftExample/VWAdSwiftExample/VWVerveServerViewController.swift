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
    guard bannerAdView == nil else { return }
    
    let adSize = UI_USER_INTERFACE_IDIOM() == .Pad ? kVWAdSizeLeaderboard : kVWAdSizeBanner
    
    bannerAdView = VWAdvertView(size: adSize)
    bannerAdView?.adPosition = VWAdvertPositionBottom
    bannerAdView?.delegate = self
    bannerAdView?.backgroundColor = .grayColor()
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = bannerAdView!.sizeThatFits(bounds.size)
    adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarController!.tabBar.frame.size.height
    
    bannerAdView?.frame = adFrame
    
    self.view?.addSubview(bannerAdView!)
    
  }
  
  @IBAction func requestBannerAd() {
    if let bannerAdView = bannerAdView {
      bannerAdView.loadRequest(VWAdRequest(contentCategoryID : .NewsAndInformation))
    }
  }
  
  
  //MARK: - Inline Ads
  
  func addInlineAdView() {
    guard inlineAdView == nil else { return }
    
    inlineAdView = VWAdvertView(size: kVWAdSizeMediumRectangle)
    
    inlineAdView?.adPosition = VWAdvertPositionInline
    inlineAdView?.delegate = self
    inlineAdView?.backgroundColor = .grayColor()
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
    inlineAdView?.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height)
    
    self.view?.addSubview(inlineAdView!)
  }
  
  @IBAction func requestInlineAd() {
    if let inlineAdView = inlineAdView {
      inlineAdView.loadRequest(VWAdRequest(contentCategoryID : .NewsAndInformation))
    }
  }
  
  
  //MARK: - Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    let adSize = UI_USER_INTERFACE_IDIOM() == .Pad ? VWInterstitialAdSizePad : VWInterstitialAdSizePhone
    
    interstitial = VWInterstitialAd(size: adSize)
    interstitial?.delegate = self
    
    let adRequest = VWAdRequest(contentCategoryID: .NewsAndInformation)
    
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

