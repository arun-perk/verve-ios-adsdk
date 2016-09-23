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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    
    splashAd = VWSplashAdView()
    splashAd?.delegate = self
    
    splashAd?.loadRequest(VWAdRequest(contentCategoryID: .NewsAndInformation))
    
    return true
  }
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    VWAdLibrary.performFetchWithCompletionHandler(completionHandler)
  }
  
  //MARK: Splash Ad Delegate
  
  func splashAdView(splashAdView: VWSplashAdView, didFailToReceiveAdWithError error: NSError?) {
    //handle
  }
  
  func splashAdViewDidReceiveAd(splashAdView: VWSplashAdView) {
    window?.rootViewController?.view.addSubview(splashAdView)
  }
  
  func splashAdViewShouldBeDismissed(splashAdView: VWSplashAdView) {
    splashAdView.removeFromSuperview()
  }
}
