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
    guard self.bannerAdView == nil else { return }
    
    let adSize = UI_USER_INTERFACE_IDIOM() == .pad ? kVWAdSizeLeaderboard : kVWAdSizeBanner
    
    guard let tabBarHeight = tabBarController?.tabBar.frame.size.height else {
      return
    }
    
    let bannerAdView = VWAdvertView(size: adSize)
    bannerAdView.adPosition = VWAdvertPositionBottom
    bannerAdView.delegate = self
    bannerAdView.backgroundColor = .gray
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = bannerAdView.sizeThatFits(bounds.size)
    adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarHeight
    
    bannerAdView.frame = adFrame
    
    view.addSubview(bannerAdView)
    
    self.bannerAdView = bannerAdView
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.load(VWAdRequest(contentCategoryID : .newsAndInformation))
  }
  
  
  //MARK: - Inline Ads
  
  func addInlineAdView() {
    guard self.inlineAdView == nil else { return }
    
    let inlineAdView = VWAdvertView(size: kVWAdSizeMediumRectangle)
    
    inlineAdView.adPosition = VWAdvertPositionInline
    inlineAdView.delegate = self
    inlineAdView.backgroundColor = .gray
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = inlineAdView.sizeThatFits(bounds.size)
    inlineAdView.frame = CGRect(
      x: (bounds.size.width - adFrame.size.width)/2,
      y: (bounds.size.height - adFrame.size.height)/2,
      width: adFrame.size.width,
      height: adFrame.size.height)
    
    view.addSubview(inlineAdView)
    
    self.inlineAdView = inlineAdView
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.load(VWAdRequest(contentCategoryID : .newsAndInformation))
  }
  
  //MARK: - Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    let adSize = UI_USER_INTERFACE_IDIOM() == .pad ? VWInterstitialAdSizePad : VWInterstitialAdSizePhone
    
    interstitial = VWInterstitialAd(size: adSize)
    interstitial?.delegate = self
    
    let adRequest = VWAdRequest(contentCategoryID: .newsAndInformation)
    
    interstitial?.load(adRequest)
  }
  
  // MARK: - VWAdvertViewDelegate
  
  func advertViewDidReceiveAd(_ adView: VWAdvertView) {
    NSLog("adViewDidReceiveAd: %@", adView)
  }
  
  func advertView(_ adView: VWAdvertView, didFailToReceiveAdWithError error: Error?) {
    if let error = error as NSError? {
      NSLog("didFailToReceiveAdWithError: %@", error)
    }
  }
  
  
  // MARK: - VWInterstitialDelegate
  func interstitialAdReceive(_ interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdReceiveAd: %ld", interstitialAd)
    
    interstitial?.present(from: self)
  }
  
  func interstitialAd(_ interstitialAd: VWInterstitialAd, didFailToReceiveAdWithError error: Error?) {
    if let error = error as NSError? {
      NSLog("dismissInterstitialViewControllerVerveInterstitial: %@", error)
    }
    
    interstitial = nil
  }
  
  func interstitialAdWillPresent(_ interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdWillPresentAd: %ld", interstitialAd);
  }
  
  func interstitialAdDidDismiss(_ interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdDidDismissAd: %ld", interstitialAd);
    interstitial = nil;
  }
  
  func interstitialAdWillLeaveApplication(_ interstitialAd: VWInterstitialAd) {
    NSLog("interstitialAdWillLeaveApplication: %ld", interstitialAd);
    interstitial = nil;
  }
}

