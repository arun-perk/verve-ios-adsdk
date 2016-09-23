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
    guard bannerAdView == nil else { return }
    
    let size = UI_USER_INTERFACE_IDIOM() == .Pad ? kGADAdSizeLeaderboard : kGADAdSizeBanner
    
    bannerAdView = GADBannerView(adSize: size)
    bannerAdView?.delegate = self
    bannerAdView?.rootViewController = self
    bannerAdView?.adUnitID = kBannerAdUnit
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
    bannerAdView?.loadRequest(newRequest())
  }
  
  
  //MARK: Inline Ads
  
  func addInlineAdView() {
    guard inlineAdView == nil else { return }
    
    inlineAdView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    inlineAdView?.delegate = self
    inlineAdView?.rootViewController = self
    inlineAdView?.adUnitID = kBannerAdUnit
    inlineAdView?.backgroundColor = UIColor.grayColor()
    
    let bounds = view.bounds
    var adFrame = CGRect.zero
    
    adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
    inlineAdView?.frame = CGRect(x: (bounds.size.width - adFrame.size.width)/2, y: (bounds.size.height - adFrame.size.height)/2, width: adFrame.size.width, height: adFrame.size.height)
    
    self.view?.addSubview(inlineAdView!)
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadRequest(newRequest())
  }
  
  
  //MARK: Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    interstitialAdView = GADInterstitial(adUnitID: kInterstitialAdUnit)
    interstitialAdView?.delegate = self
    interstitialAdView?.loadRequest(newRequest())
  }
  
  
  //MARK: Ad Request
  
  func newRequest() -> GADRequest
  {
    // GADCustomEventExtras class alows us to send network specific params to network's SDK
    // Let us set example contentCategoryID
    // These parameters are optional. Consult Verve Ad Library documentation for more info.
    let extras = [
      kVWGADExtraContentCategoryIDKey :  VWContentCategory.NewsAndInformation.rawValue,
    ]
    
    let customEventExtras = GADCustomEventExtras()
    customEventExtras.setExtras(extras, forLabel: kCustomEventLabel)
    
    let request =  GADRequest()
    request.registerAdNetworkExtras(customEventExtras)
    
    return request
  }
  
  
  //MARK: GADBannerViewDelegate
  
  func adViewDidReceiveAd(view: GADBannerView!) {
    if let adNetworkClassName = view?.adNetworkClassName {
      NSLog("adViewDidReceiveAd: \(adNetworkClassName)")
    }
  }
  
  func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
    if let adNetworkClassName = view?.adNetworkClassName {
      NSLog("adViewDidFailToReceiveAd: \(adNetworkClassName)")
    }
  }
  
  func adViewWillLeaveApplication(adView: GADBannerView!) {
    if let adNetworkClassName = adView?.adNetworkClassName {
      NSLog("adViewWillLeaveApplication: \(adNetworkClassName)")
    }
  }
  
  func adViewWillPresentScreen(adView: GADBannerView!) {
    if let adNetworkClassName = adView?.adNetworkClassName {
      NSLog("adViewWillPresentScreen: \(adNetworkClassName)")
    }
  }
  
  func adViewWillDismissScreen(adView: GADBannerView!) {
    if let adNetworkClassName = adView?.adNetworkClassName {
      NSLog("adViewWillDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func adViewDidDismissScreen(adView: GADBannerView!) {
    if let adNetworkClassName = adView?.adNetworkClassName {
      NSLog("adViewDidDismissScreen: \(adNetworkClassName)")
    }
  }
  
  
  //MARK: GADInterstitialDelegate
  
  func interstitialDidReceiveAd(ad: GADInterstitial!) {
    if let adNetworkClassName = ad?.adNetworkClassName {
      NSLog("adViewDidReceiveAd: \(adNetworkClassName)")
      ad?.presentFromRootViewController(self)
    }
  }
  
  func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
    if (error != nil) {
      NSLog("interstitial:didFailToReceiveAdWithError: %@", error!.localizedDescription)
    }
  }
  
  func interstitialWillPresentScreen(ad: GADInterstitial!) {
    if let adNetworkClassName = ad?.adNetworkClassName {
      NSLog("interstitialWillPresentScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialWillDismissScreen(ad: GADInterstitial!) {
    if let adNetworkClassName = ad?.adNetworkClassName {
      NSLog("interstitialWillDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialDidDismissScreen(ad: GADInterstitial!) {
    if let adNetworkClassName = ad?.adNetworkClassName {
      NSLog("interstitialDidDismissScreen: \(adNetworkClassName)")
    }
  }
  
  func interstitialWillLeaveApplication(ad: GADInterstitial!) {
    if let adNetworkClassName = ad?.adNetworkClassName {
      NSLog("interstitialWillLeaveApplication: \(adNetworkClassName)")
    }
  }
}


