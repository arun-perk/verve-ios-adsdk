//
//  VWMoPubServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Christina Long on 10/5/15.
//  Copyright © 2015 Verve Wireless. All rights reserved.
//

import UIKit

class VWMoPubServerViewController: UIViewController, MPAdViewDelegate, MPInterstitialAdControllerDelegate {
  let kBannerAdUnit = "81e4362779af4f31b392223cece421a3"
  let kInlineAdUnit = "12a8caf3a56e40a5a883b36f910f8d96"
  let kInterstitialAdUnit = "400efb79cbfd4063a777d471ac25c795"
  let kLeaderboardAdUnit = "83023bd000f44a12a02de151b1664e30"
  
  var bannerAdView : MPAdView?
  var inlineAdView : MPAdView?
  var interstitialAd : MPInterstitialAdController?
  
  
  //MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBannerAdView()
    addInlineAdView()
  }
  
  
  //MARK: Banner Ad
  
  func addBannerAdView() {
    let adSize = UI_USER_INTERFACE_IDIOM() == .Pad ? MOPUB_LEADERBOARD_SIZE : MOPUB_BANNER_SIZE
    let adUnit = UI_USER_INTERFACE_IDIOM() == .Pad ? kLeaderboardAdUnit : kBannerAdUnit
    
    bannerAdView = MPAdView(adUnitId: adUnit, size: adSize)
    bannerAdView?.delegate = self
    bannerAdView?.backgroundColor = .grayColor()
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = bannerAdView!.sizeThatFits(bounds.size)
    adFrame.origin.x = (bounds.size.width-adFrame.size.width)/2
    adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarController!.tabBar.frame.size.height
    
    bannerAdView?.frame = adFrame
    
    self.view?.addSubview(bannerAdView!)
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadAd()
  }
  
  
  //MARK: Inline Ad
  
  func addInlineAdView() {
    guard inlineAdView == nil else { return }
    
    inlineAdView = MPAdView(adUnitId: kInlineAdUnit, size: MOPUB_MEDIUM_RECT_SIZE)
    inlineAdView?.delegate = self
    inlineAdView?.backgroundColor = .grayColor()
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
    inlineAdView!.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height);
    
    self.view?.addSubview(inlineAdView!)
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadAd()
  }
  
  
  //MARK: Interstitial Ad
  
  @IBAction func requestInterstitialAd() {
    interstitialAd = MPInterstitialAdController(forAdUnitId: kInterstitialAdUnit)
    interstitialAd?.delegate = self
    interstitialAd?.loadAd()
  }
  
  
  //MARK: MPAdViewDelegate
  
  func adViewDidLoadAd(view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("adViewDidLoadAd: \(adUnit)")
    }
  }
  
  func  adViewDidFailToLoadAd(view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("adViewDidFailToLoadAd: \(adUnit)")
    }
  }
  
  func viewControllerForPresentingModalView() -> UIViewController! {
    NSLog("viewControllerForPresentingModalView")
    return self
  }
  
  func willPresentModalViewForAd(view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("willPresentModalViewForAd: \(adUnit)")
    }
  }
  
  func didDismissModalViewForAd(view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("didDismissModalViewForAd: \(adUnit)")
    }
  }
  
  func willLeaveApplicationFromAd(view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("willLeaveApplicationFromAd: \(adUnit)")
    }
  }
  
  
  //MARK: MPInterstitialAdControllerDelegate
  
  func interstitialDidLoadAd(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidLoadAd: \(adUnit)")
      
      interstitial.showFromViewController(self)
    }
  }
  
  func interstitialDidFailToLoadAd(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidFailToLoadAd: \(adUnit)")
    }
  }
  
  func interstitialWillAppear(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialWillAppear: \(adUnit)")
    }
  }
  
  func interstitialDidAppear(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidAppear: \(adUnit)")
    }
  }
  
  func interstitialWillDisappear(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialWillDisappear: \(adUnit)")
    }
  }
  
  func interstitialDidDisappear(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidDisappear: \(adUnit)")
    }
  }
  
  func interstitialDidExpire(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidExpire: \(adUnit)")
    }
  }
  
  func interstitialDidReceiveTapEvent(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidReceiveTapEvent: \(adUnit)")
    }
  }
}
