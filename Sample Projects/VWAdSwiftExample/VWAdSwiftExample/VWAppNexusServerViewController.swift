//
//  VWAppNexusServerViewController.swift
//  VWAdSwiftExample
//
//  Created by Danijel Lombarovic on 20/09/16.
//  Copyright © 2016 Verve Wireless. All rights reserved.
//

import UIKit

class VWAppNexusServerViewController: UIViewController, ANBannerAdViewDelegate, ANInterstitialAdDelegate {
  
  let kPlacementIdBanner = "9517930"
  let kPlacementIdBannerTablet = "9836644"
  let kPlacementIdInline = "9519151"
  let kPlacementIdInterstitial = "9517931";
  
  var bannerAdView: ANBannerAdView?
  var inlineAdView: ANBannerAdView?
  var interstitialAdView: ANInterstitialAd?
		
  //MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var canUseHTTP: Bool = false
    guard let infoDictionary = NSBundle.mainBundle().infoDictionary else { return }
    if let appTransportSecurity = infoDictionary["NSAppTransportSecurity"] as? NSDictionary {
      
      let allowsArbitraryLoadsInWebContent = appTransportSecurity.objectForKey("NSAllowsArbitraryLoadsInWebContent") != nil
      let allowsArbitraryLoadsInMedia = appTransportSecurity.objectForKey("NSAllowsArbitraryLoadsInMedia") != nil
      let allowsLocalNetworking = appTransportSecurity.objectForKey("NSAllowsLocalNetworking") != nil
      
      var allowsArbitraryLoadsValue: Bool = false
      if let allowsArbitraryLoads = appTransportSecurity.objectForKey("NSAllowsArbitraryLoads") {
        allowsArbitraryLoadsValue = allowsArbitraryLoads.boolValue
      }
      
      let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
      if systemVersion >= 10.0 {
        canUseHTTP = !(allowsArbitraryLoadsInWebContent || allowsArbitraryLoadsInMedia || allowsLocalNetworking) && allowsArbitraryLoadsValue
      } else {
        canUseHTTP = allowsArbitraryLoadsValue
      }
    }
    
    ANSDKSettings.sharedInstance().HTTPSEnabled = !canUseHTTP
    
    addBannerAdView()
    addInlineAdView()
  }
  
  
  //MARK: Banner Ad
  
  func addBannerAdView() {
    
    //determine size and farame for banner ad
    let bounds = view.bounds
    let adSize = UI_USER_INTERFACE_IDIOM() == .Pad ? CGSize(width: 728, height: 90) : CGSize(width: 320, height: 50)
   
    let adFrame = CGRect(x: (bounds.size.width - adSize.width)/2, y: bounds.size.height - adSize.height - self.tabBarController!.tabBar.frame.size.height, width: adSize.width, height: adSize.height)
    
    let placementId = UI_USER_INTERFACE_IDIOM() == .Pad ? kPlacementIdBannerTablet : kPlacementIdBanner
    bannerAdView = ANBannerAdView(frame: adFrame, placementId: placementId, adSize: adSize)
    bannerAdView?.rootViewController = self
    bannerAdView?.autoRefreshInterval = 0
    bannerAdView?.delegate = self
    bannerAdView?.backgroundColor = .grayColor()
    
    //ad the banner ad to the view
    view.addSubview(bannerAdView!)
  }
  
  @IBAction func requestBannerAd() {
    bannerAdView?.loadAd()
  }
  
  //MARK: Inline Ad
  
  func addInlineAdView() {
   
    //determine size and frame for the inline ad
    let bounds = view.bounds
    let adSize = CGSize(width: 300, height: 250)
    
    let adFrame = CGRect(x: (bounds.size.width - adSize.width)/2, y: (bounds.size.height - adSize.height)/2, width: adSize.width, height: adSize.height)
    
    inlineAdView = ANBannerAdView(frame: adFrame, placementId: kPlacementIdInline, adSize: adSize)
    inlineAdView?.rootViewController = self
    inlineAdView?.autoRefreshInterval = 0
    inlineAdView?.delegate = self
    inlineAdView?.backgroundColor = .grayColor()
    
    //add the inline ad to the view
    view.addSubview(inlineAdView!)
  }
  
  @IBAction func requestInlineAd() {
    inlineAdView?.loadAd()
  }
  
  //MARK: Interstitial Ad
  
  @IBAction func requestInterstitialAd() {
    interstitialAdView = ANInterstitialAd(placementId: kPlacementIdInterstitial)
    interstitialAdView?.delegate = self
    interstitialAdView?.loadAd()
  }
  
  //MARK: ANBannerAdViewDelegate
  
  func adDidReceiveAd(ad: ANAdProtocol!) {
    NSLog("adDidReceiveAd: \(ad.placementId)")
    if (ad as? ANInterstitialAd) != nil {
      interstitialAdView?.displayAdFromViewController(self)
    }
  }
  
  func ad(ad: ANAdProtocol!, requestFailedWithError error: NSError!) {
    NSLog("ad:requestFailedWithError: \(ad.placementId)")
  }
  
  func adWasClicked(ad: ANAdProtocol!) {
    NSLog("adWasClicked: \(ad.placementId)")
  }
  
  func adWillClose(ad: ANAdProtocol!) {
    NSLog("adWillClose: \(ad.placementId)")
  }
  
  func adDidClose(ad: ANAdProtocol!) {
    NSLog("adDidClose: \(ad.placementId)")
  }
  
  func adWillPresent(ad: ANAdProtocol!) {
    NSLog("adWillPresent: \(ad.placementId)")
  }
  
  func adDidPresent(ad: ANAdProtocol!) {
    NSLog("adDidPresent: \(ad.placementId)")
  }
  
  func adWillLeaveApplication(ad: ANAdProtocol!) {
    NSLog("adWillLeaveApplication: \(ad.placementId)")
  }
  
  //MARK: ANInterstitialAdDelegate
  
  func adFailedToDisplay(ad: ANInterstitialAd!) {
     NSLog("adFailedToDisplay: \(ad.placementId)")
  }
  
}
