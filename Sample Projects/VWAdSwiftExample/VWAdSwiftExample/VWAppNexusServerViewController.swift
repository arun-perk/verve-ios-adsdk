//
//  VWAppNexusServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Danijel Lombarovic on 20/09/16.
//  Copyright © 2016 Verve Wireless. All rights reserved.
//

import UIKit

class VWAppNexusServerViewController: UIViewController, ANBannerAdViewDelegate, ANInterstitialAdDelegate {
  
  let kPlacementIdBanner = "11113606"
  let kPlacementIdBannerTablet = "11113608"
  let kPlacementIdInline = "11113607"
  let kPlacementIdInterstitial = "11113611";
  
  var bannerAdView: ANBannerAdView?
  var inlineAdView: ANBannerAdView?
  var interstitialAdView: ANInterstitialAd?
		
  //MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var canUseHTTP: Bool = false
    guard let infoDictionary = Bundle.main.infoDictionary else { return }
    if let appTransportSecurity = infoDictionary["NSAppTransportSecurity"] as? NSDictionary {
      
      let allowsArbitraryLoadsInWebContent = appTransportSecurity.object(forKey: "NSAllowsArbitraryLoadsInWebContent") != nil
      let allowsArbitraryLoadsInMedia = appTransportSecurity.object(forKey: "NSAllowsArbitraryLoadsInMedia") != nil
      let allowsLocalNetworking = appTransportSecurity.object(forKey: "NSAllowsLocalNetworking") != nil
      
      var allowsArbitraryLoadsValue: Bool = false
      if let allowsArbitraryLoads = appTransportSecurity.object(forKey: "NSAllowsArbitraryLoads") as? Bool {
        allowsArbitraryLoadsValue = allowsArbitraryLoads
      }

      if UIDevice.current.systemVersion.compare("10.0", options: .numeric) == .orderedDescending {
        canUseHTTP = !(allowsArbitraryLoadsInWebContent || allowsArbitraryLoadsInMedia || allowsLocalNetworking) && allowsArbitraryLoadsValue
      } else {
        canUseHTTP = allowsArbitraryLoadsValue
      }
    }
    
    ANSDKSettings.sharedInstance().httpsEnabled = !canUseHTTP
    
    addBannerAdView()
    addInlineAdView()
  }
  
  
  //MARK: Banner Ad
  
  func addBannerAdView() {
    //determine size and farame for banner ad
    let bounds = view.bounds
    let adSize = UI_USER_INTERFACE_IDIOM() == .pad ? CGSize(width: 728, height: 90) : CGSize(width: 320, height: 50)
    
    guard let tabBarHeight = tabBarController?.tabBar.frame.size.height else {
      return
    }
    let adFrame = CGRect(
      x: (bounds.size.width - adSize.width)/2,
      y: bounds.size.height - adSize.height - tabBarHeight,
      width: adSize.width,
      height: adSize.height)
    
    let placementId = UI_USER_INTERFACE_IDIOM() == .pad ? kPlacementIdBannerTablet : kPlacementIdBanner
    guard let bannerAdView = ANBannerAdView(frame: adFrame, placementId: placementId, adSize: adSize) else { return }
    bannerAdView.rootViewController = self
    bannerAdView.autoRefreshInterval = 0
    bannerAdView.delegate = self
    bannerAdView.backgroundColor = .gray
    
    //ad the banner ad to the view
    view.addSubview(bannerAdView)
    
    self.bannerAdView = bannerAdView
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadAd()
  }
  
  //MARK: Inline Ad
  
  func addInlineAdView() {
    //determine size and frame for the inline ad
    let bounds = view.bounds
    let adSize = CGSize(width: 300, height: 250)
    
    let adFrame = CGRect(
      x: (bounds.size.width - adSize.width)/2,
      y: (bounds.size.height - adSize.height)/2,
      width: adSize.width,
      height: adSize.height)
    
    guard let inlineAdView = ANBannerAdView(frame: adFrame, placementId: kPlacementIdInline, adSize: adSize) else { return }
    inlineAdView.rootViewController = self
    inlineAdView.autoRefreshInterval = 0
    inlineAdView.delegate = self
    inlineAdView.backgroundColor = .gray
    
    //add the inline ad to the view
    view.addSubview(inlineAdView)
    
    self.inlineAdView = inlineAdView
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadAd()
  }
  
  //MARK: Interstitial Ad
  
  @IBAction func requestInterstitialAd() {
    interstitialAdView = ANInterstitialAd(placementId: kPlacementIdInterstitial)
    interstitialAdView?.delegate = self
    interstitialAdView?.load()
  }
  
  //MARK: ANBannerAdViewDelegate
  
  func adDidReceiveAd(_ ad: ANAdProtocol!) {
    NSLog("adDidReceiveAd: \(ad.placementId)")
    if let _ = ad as? ANInterstitialAd {
      interstitialAdView?.display(from: self)
    }
  }
  
  func ad(_ ad: ANAdProtocol!, requestFailedWithError error: Error!) {
    NSLog("ad:requestFailedWithError: \(ad.placementId)")
  }
  
  func adWasClicked(_ ad: ANAdProtocol!) {
    NSLog("adWasClicked: \(ad.placementId)")
  }
  
  func adWillClose(_ ad: ANAdProtocol!) {
    NSLog("adWillClose: \(ad.placementId)")
  }
  
  func adDidClose(_ ad: ANAdProtocol!) {
    NSLog("adDidClose: \(ad.placementId)")
  }
  
  func adWillPresent(_ ad: ANAdProtocol!) {
    NSLog("adWillPresent: \(ad.placementId)")
  }
  
  func adDidPresent(_ ad: ANAdProtocol!) {
    NSLog("adDidPresent: \(ad.placementId)")
  }
  
  func adWillLeaveApplication(_ ad: ANAdProtocol!) {
    NSLog("adWillLeaveApplication: \(ad.placementId)")
  }
  
  //MARK: ANInterstitialAdDelegate
  
  func adFailed(toDisplay ad: ANInterstitialAd!) {
    NSLog("adFailedToDisplay: \(ad.placementId)")
  }
  
}
