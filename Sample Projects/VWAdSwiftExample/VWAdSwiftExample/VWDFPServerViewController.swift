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
  
  let kBannerAdUnit : String  = "/11027047/vrvadmob"
  let kInlineAdUnit : String = "/11027047/vrvadmob"
  let kInterstitialAdUnit : String = "/11027047/vrvadmobint"
  let kCustomEventLabel : String = "Verve Ad Network"
  
  var bannerAdView : GADBannerView?
  var inlineAdView : GADBannerView?
  var interstitialAdView : GADInterstitial?
  

  //MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBannerAdView()
    addInlineAdView()
  }
  
  
  //MARK: Banner Ads
  
  func addBannerAdView() {
    if bannerAdView == nil {
      let size: GADAdSize = UI_USER_INTERFACE_IDIOM() == .Pad ? kGADAdSizeLeaderboard : kGADAdSizeBanner
      
      bannerAdView = GADBannerView(adSize: size)
      bannerAdView?.delegate = self
      bannerAdView?.rootViewController = self
      bannerAdView?.adUnitID = kBannerAdUnit
      bannerAdView?.backgroundColor = UIColor.grayColor()
      
      let bounds : CGRect = view.bounds
      var adFrame : CGRect = CGRectZero
      
      adFrame.size = bannerAdView!.sizeThatFits(bounds.size)
      adFrame.origin.x = (bounds.size.width-adFrame.size.width)/2
      adFrame.origin.y = bounds.size.height - adFrame.size.height - tabBarController!.tabBar.frame.size.height
      
      bannerAdView!.frame = adFrame
      
      self.view?.addSubview(bannerAdView!)
    }
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadRequest(newRequest())
  }
  
  
  //MARK: Inline Ads
  
  func addInlineAdView() {
    if inlineAdView == nil {
      inlineAdView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
      inlineAdView?.delegate = self
      inlineAdView?.rootViewController = self
      inlineAdView?.adUnitID = kBannerAdUnit
      inlineAdView?.backgroundColor = UIColor.grayColor()
      
      let bounds : CGRect = view.bounds
      var adFrame : CGRect = CGRectZero
      
      adFrame.size = inlineAdView!.sizeThatFits(bounds.size)
      inlineAdView!.frame = CGRectMake((bounds.size.width - adFrame.size.width)/2, (bounds.size.height - adFrame.size.height)/2, adFrame.size.width, adFrame.size.height)
      
      self.view?.addSubview(inlineAdView!)
    }
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadRequest(newRequest())
  }
  
  
  //MARK: Interstitial Ads
  
  @IBAction func requestInterstitialAd() {
    interstitialAdView = GADInterstitial.init(adUnitID: kInterstitialAdUnit)
    interstitialAdView!.delegate = self
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
    
    let customEventExtras : GADCustomEventExtras? = GADCustomEventExtras.init()
    customEventExtras?.setExtras(extras, forLabel: kCustomEventLabel)
    
    let request : GADRequest? =  GADRequest()
    request?.registerAdNetworkExtras(customEventExtras)
    
    return request!
  }
  
  
  //MARK: GADBannerViewDelegate
  
  func adViewDidReceiveAd(view: GADBannerView!) {
    if (view != nil) {
      if (view.adNetworkClassName != nil) {
        NSLog("adViewDidReceiveAd: %@", view.adNetworkClassName)
      }
    }
  }
  
  func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
    if (view != nil) {
      if (view.adNetworkClassName != nil) {
        NSLog("%@", view.adNetworkClassName!)
      }
    }
  }
  
  func adViewWillLeaveApplication(adView: GADBannerView!) {
    if (adView != nil && adView.adNetworkClassName != nil) {
      NSLog("adViewWillLeaveApplication: %@", adView.adNetworkClassName)
    }
  }
  
  func adViewWillPresentScreen(adView: GADBannerView!) {
    if (adView != nil && adView.adNetworkClassName != nil) {
      NSLog("adViewWillPresentScreen: %@", adView.adNetworkClassName)
    }
  }
  
  func adViewWillDismissScreen(adView: GADBannerView!) {
    if (adView != nil && adView.adNetworkClassName != nil) {
      NSLog("adViewWillDismissScreen: %@", adView.adNetworkClassName)
    }
  }
  
  func adViewDidDismissScreen(adView: GADBannerView!) {
    if (adView != nil && adView.adNetworkClassName != nil) {
      NSLog("adViewDidDismissScreen: %@", adView.adNetworkClassName)
    }
  }
  
  
  //MARK: GADInterstitialDelegate
  
  func interstitialDidReceiveAd(ad: GADInterstitial!) {
    if (ad != nil) {
      if (ad.adNetworkClassName != nil) {
        NSLog("adViewDidReceiveAd: %@", ad.adNetworkClassName)
      }
      
      ad?.presentFromRootViewController(self)
    }
  }
  
  func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
    if (error != nil) {
      NSLog("interstitial:didFailToReceiveAdWithError: %@", error!.localizedDescription)
    }
  }
}


