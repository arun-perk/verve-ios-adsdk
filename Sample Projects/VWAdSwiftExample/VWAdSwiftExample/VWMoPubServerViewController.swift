//
//  VWMoPubServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Christina Long on 10/5/15.
//  Copyright © 2015 Verve Wireless. All rights reserved.
//

import UIKit

class VWMoPubServerViewController: UIViewController, MPAdViewDelegate, MPInterstitialAdControllerDelegate {
  
  @IBOutlet weak var autoRefreshSwitch: UISwitch!
    
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
    
    enableOrDisableAutoRefreshing(autoRefreshSwitch)
  }
  
  
  //MARK: Banner Ad
  
  func addBannerAdView() {
    let adSize = UI_USER_INTERFACE_IDIOM() == .pad ? MOPUB_LEADERBOARD_SIZE : MOPUB_BANNER_SIZE
    let adUnit = UI_USER_INTERFACE_IDIOM() == .pad ? kLeaderboardAdUnit : kBannerAdUnit
    
    guard let tabBarHeight = tabBarController?.tabBar.frame.size.height else {
      return
    }
    
    guard let bannerAdView = MPAdView(adUnitId: adUnit, size: adSize) else { return }
    bannerAdView.delegate = self
    bannerAdView.backgroundColor = .gray
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = bannerAdView.sizeThatFits(bounds.size)
    adFrame.origin.x = (bounds.size.width-adFrame.size.width)/2
    adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarHeight
    
    bannerAdView.frame = adFrame
    
    view.addSubview(bannerAdView)
    
    self.bannerAdView = bannerAdView
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadAd()
  }
  
  
  //MARK: Inline Ad
  
  func addInlineAdView() {
    guard self.inlineAdView == nil else { return }
    
    guard let inlineAdView = MPAdView(adUnitId: kInlineAdUnit, size: MOPUB_MEDIUM_RECT_SIZE) else { return }
    inlineAdView.delegate = self
    inlineAdView.backgroundColor = .gray
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = inlineAdView.sizeThatFits(bounds.size)
    inlineAdView.frame = CGRect(
      x: (bounds.size.width - adFrame.size.width)/2,
      y: (bounds.size.height - adFrame.size.height)/2,
      width: adFrame.size.width,
      height: adFrame.size.height);
    
    view.addSubview(inlineAdView)
    
    self.inlineAdView = inlineAdView
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
  
  func adViewDidLoadAd(_ view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("adViewDidLoadAd: \(adUnit)")
    }
  }
  
  func adViewDidFail(toLoadAd view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("adViewDidFailToLoadAd: \(adUnit)")
    }
  }
  
  func viewControllerForPresentingModalView() -> UIViewController! {
    NSLog("viewControllerForPresentingModalView")
    return self
  }
  
  func willPresentModalView(forAd view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("willPresentModalViewForAd: \(adUnit)")
    }
  }
  
  func didDismissModalView(forAd view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("didDismissModalViewForAd: \(adUnit)")
    }
  }
  
  func willLeaveApplication(fromAd view: MPAdView!) {
    if let adUnit = view.adUnitId {
      NSLog("willLeaveApplicationFromAd: \(adUnit)")
    }
  }
  
  
  //MARK: MPInterstitialAdControllerDelegate
  
  func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidLoadAd: \(adUnit)")
      
      interstitial.show(from: self)
    }
  }
  
  func interstitialDidFailToLoadAd(interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidFailToLoadAd: \(adUnit)")
    }
  }
  
  func interstitialWillAppear(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialWillAppear: \(adUnit)")
    }
  }
  
  func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidAppear: \(adUnit)")
    }
  }
  
  func interstitialWillDisappear(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialWillDisappear: \(adUnit)")
    }
  }
  
  func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidDisappear: \(adUnit)")
    }
  }
  
  func interstitialDidExpire(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidExpire: \(adUnit)")
    }
  }
  
  func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
    if let adUnit = interstitial.adUnitId {
      NSLog("interstitialDidReceiveTapEvent: \(adUnit)")
    }
  }
    
  @IBAction func autoRefreshSwitchValueChanged(_ currentAutoRefreshSwitch: UISwitch) {
    enableOrDisableAutoRefreshing(currentAutoRefreshSwitch)
  }
  
  func enableOrDisableAutoRefreshing(_ currentAutoRefreshSwitch: UISwitch) {
    guard let bannerAdView = bannerAdView else { return }
    guard let inlineAdView = inlineAdView else { return }
    if currentAutoRefreshSwitch.isOn {
        bannerAdView.startAutomaticallyRefreshingContents()
        inlineAdView.startAutomaticallyRefreshingContents()
    } else {
        bannerAdView.stopAutomaticallyRefreshingContents()
        inlineAdView.stopAutomaticallyRefreshingContents()
    }
  }
}
