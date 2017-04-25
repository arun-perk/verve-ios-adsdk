//
//  VWDFPServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Christina Long on 10/5/15.
//  Copyright © 2015 Verve Wireless. All rights reserved.
//

import UIKit
import VerveAd
import GoogleMobileAds

class VWDFPServerViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
  
  let kBannerAdUnit = "/11027047/vrvadmob"
  let kInlineAdUnit = "/11027047/vrvadmob"
  let kInterstitialAdUnit = "/11027047/vrvadmobint"
  let kCustomEventLabel = "Verve Ad Network"
  
  var bannerAdView: GADBannerView?
  var inlineAdView: GADBannerView?
  var interstitialAdView: GADInterstitial?
  

  //MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBannerAdView()
    addInlineAdView()
  }
  
  
  //MARK: Banner Ads
  
  func addBannerAdView() {
    guard self.bannerAdView == nil else { return }
    
    let size = UI_USER_INTERFACE_IDIOM() == .pad ? kGADAdSizeLeaderboard : kGADAdSizeBanner
    
    guard let tabBarHeight = tabBarController?.tabBar.frame.size.height else {
      return
    }
    
    let bannerAdView = GADBannerView(adSize: size)
    bannerAdView.delegate = self
    bannerAdView.rootViewController = self
    bannerAdView.adUnitID = kBannerAdUnit
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
    bannerAdView?.load(newRequest())
  }
  
  
  //MARK: Inline Ads
  
  func addInlineAdView() {
    guard self.inlineAdView == nil else { return }
    
    let inlineAdView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    inlineAdView.delegate = self
    inlineAdView.rootViewController = self
    inlineAdView.adUnitID = kBannerAdUnit
    inlineAdView.backgroundColor = UIColor.gray
    
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
    inlineAdView?.load(newRequest())
  }
  
  
  //MARK: Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    interstitialAdView = GADInterstitial(adUnitID: kInterstitialAdUnit)
    interstitialAdView?.delegate = self
    interstitialAdView?.load(newRequest())
  }
  
  
  //MARK: Ad Request
  
  func newRequest() -> GADRequest
  {
    // GADCustomEventExtras class alows us to send network specific params to network's SDK
    // Let us set example contentCategoryID
    // These parameters are optional. Consult Verve Ad Library documentation for more info.
    let extras = [
      kVWGADExtraContentCategoryIDKey :  VWContentCategory.newsAndInformation.rawValue,
    ]
    
    let customEventExtras = GADCustomEventExtras()
    customEventExtras.setExtras(extras, forLabel: kCustomEventLabel)
    
    let request =  GADRequest()
    request.register(customEventExtras)
    
    return request
  }
  
  
  //MARK: GADBannerViewDelegate
  
  func adViewDidReceiveAd(_ view: GADBannerView) {
    if let adNetworkClassName = view.adNetworkClassName {
      NSLog("adViewDidReceiveAd: \(adNetworkClassName)")
    }
  }
  
  func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    if let adNetworkClassName = view.adNetworkClassName {
      NSLog("adViewDidFailToReceiveAd: \(adNetworkClassName)")
    }
  }
  
  func adViewWillLeaveApplication(_ adView: GADBannerView) {
    if let adNetworkClassName = adView.adNetworkClassName {
      NSLog("adViewWillLeaveApplication: \(adNetworkClassName)")
    }
  }
  
  func adViewWillPresentScreen(_ adView: GADBannerView) {
    if let adNetworkClassName = adView.adNetworkClassName {
      NSLog("adViewWillPresentScreen: \(adNetworkClassName)")
    }
  }
  
  func adViewWillDismissScreen(_ adView: GADBannerView) {
    if let adNetworkClassName = adView.adNetworkClassName {
      NSLog("adViewWillDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func adViewDidDismissScreen(_ adView: GADBannerView) {
    if let adNetworkClassName = adView.adNetworkClassName {
      NSLog("adViewDidDismissScreen: \(adNetworkClassName)")
    }
  }
  
  
  //MARK: GADInterstitialDelegate
  
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    if let adNetworkClassName = ad.adNetworkClassName {
      NSLog("adViewDidReceiveAd: \(adNetworkClassName)")
      ad.present(fromRootViewController: self)
    }
  }
  
  func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    NSLog("interstitial:didFailToReceiveAdWithError: %@", error.localizedDescription)
  }
  
  func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    if let adNetworkClassName = ad.adNetworkClassName {
      NSLog("interstitialWillPresentScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    if let adNetworkClassName = ad.adNetworkClassName {
      NSLog("interstitialWillDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    if let adNetworkClassName = ad.adNetworkClassName {
      NSLog("interstitialDidDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    if let adNetworkClassName = ad.adNetworkClassName {
      NSLog("interstitialWillLeaveApplication: \(adNetworkClassName)")
    }
  }
}


