//
//  VWMoPubServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Christina Long on 10/5/15.
//  Copyright © 2015 Verve Wireless. All rights reserved.
//

import UIKit

class VWMoPubServerViewController: UIViewController, MPAdViewDelegate, MPInterstitialAdControllerDelegate {
  let kBannerAdUnit : String = "81e4362779af4f31b392223cece421a3"
  let kInlineAdUnit : String = "12a8caf3a56e40a5a883b36f910f8d96"
  let kInterstitialAdUnit : String = "400efb79cbfd4063a777d471ac25c795"
  
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
    let adSize: CGSize = UI_USER_INTERFACE_IDIOM() == .Pad ? MOPUB_LEADERBOARD_SIZE : MOPUB_BANNER_SIZE
    
    bannerAdView = MPAdView.init(adUnitId: kBannerAdUnit, size: adSize)
    bannerAdView?.delegate = self
    bannerAdView?.backgroundColor = UIColor.grayColor()
    
    let bounds : CGRect = view.bounds
    var adFrame : CGRect = CGRectZero
    
    adFrame.size = bannerAdView!.sizeThatFits(bounds.size)
    adFrame.origin.x = (bounds.size.width-adFrame.size.width)/2
    adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarController!.tabBar.frame.size.height
    
    bannerAdView!.frame = adFrame
    
    self.view?.addSubview(bannerAdView!)
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadAd()
  }
  
  
  //MARK: Inline Ad
  
  func addInlineAdView() {
    if inlineAdView == nil {
      inlineAdView = MPAdView.init(adUnitId: kInlineAdUnit, size: MOPUB_MEDIUM_RECT_SIZE)
      inlineAdView?.delegate = self
      inlineAdView?.backgroundColor = UIColor.grayColor()
      
      let bounds : CGRect = view.bounds
      var adFrame : CGRect = CGRectZero
      
      adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
      inlineAdView!.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height);
      
      self.view?.addSubview(inlineAdView!)
    }
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadAd()
  }
  
  
  //MARK: Interstitial Ad
  
  @IBAction func requestInterstitialAd() {
    interstitialAd = MPInterstitialAdController.init(forAdUnitId: kInterstitialAdUnit)
    interstitialAd?.delegate = self
    interstitialAd?.loadAd()
  }
  
  
  //MARK: MPAdViewDelegate
  
  func adViewDidLoadAd(view: MPAdView!) {
    if (view != nil) {
      NSLog("adViewDidLoadAd: %@", view)
    }
  }
  
  func  adViewDidFailToLoadAd(view: MPAdView!) {
    if (view != nil) {
      NSLog("adViewDidFailToLoadAd: %@", view)
    }
  }
  
  func viewControllerForPresentingModalView() -> UIViewController! {
    return self
  }
  
  func willPresentModalViewForAd(view: MPAdView!) {
    if (view != nil) {
      NSLog("willPresentModalViewForAd: %@", view)
    }
  }
  
  func didDismissModalViewForAd(view: MPAdView!) {
    if (view != nil) {
      NSLog("didDismissModalViewForAd: %@", view)
    }
  }
  
  func willLeaveApplicationFromAd(view: MPAdView!) {
    if (view != nil) {
      NSLog("willLeaveApplicationFromAd: %@", view)
    }
  }
  
  
  //MARK: MPInterstitialAdControllerDelegate
  
  func interstitialDidLoadAd(interstitial: MPInterstitialAdController!) {
    if (interstitial != nil) {
      NSLog("interstitialDidLoadAd: %@", interstitial)
      
      interstitial.showFromViewController(self)
    }
  }
  
  func interstitialDidFailToLoadAd(interstitial: MPInterstitialAdController!) {
    if (interstitial != nil) {
      NSLog("interstitialDidFailToLoadAd: %@", interstitial)
    }
  }
}
