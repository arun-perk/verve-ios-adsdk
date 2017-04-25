//
//  AppDelegate.swift
//  VWAdSwiftExample
//
//  Created by Srdan Rasic on 25/09/14.
//  Copyright (c) 2014 Verve Wireless. All rights reserved.
//

import UIKit
import VerveAd

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, VWSplashAdViewDelegate {
  
  var window: UIWindow?
  var splashAd : VWSplashAdView?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    splashAd = VWSplashAdView()
    splashAd?.delegate = self
    
    splashAd?.load(VWAdRequest(contentCategoryID: .newsAndInformation))
    
    return true
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    VWAdLibrary.performFetch(completionHandler: completionHandler)
  }
  
  //MARK: Splash Ad Delegate
  
  func splashAdView(_ splashAdView: VWSplashAdView, didFailToReceiveAdWithError error: Error?) {
    //handle
  }
  
  func splashAdViewDidReceiveAd(_ splashAdView: VWSplashAdView) {
    window?.rootViewController?.view.addSubview(splashAdView)
  }
  
  func splashAdViewShouldBeDismissed(_ splashAdView: VWSplashAdView) {
    splashAdView.removeFromSuperview()
  }
}
