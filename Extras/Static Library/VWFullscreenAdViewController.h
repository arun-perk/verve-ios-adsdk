//
//  VWFullscreenAdViewController.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VWFullscreenAdViewControllerDelegate;

@interface VWFullscreenAdViewController : UIViewController

@property (nonatomic, weak, nullable) id<VWFullscreenAdViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL dismissControlVisible;
@property (nonatomic, assign) BOOL scrollingDisabled;

@end

@protocol VWFullscreenAdViewControllerDelegate <NSObject>

@required
- (void)fullscreenAdViewControllerWantsToClose:(nonnull VWFullscreenAdViewController *)fullscreenAdViewController;

@optional
- (void)fullscreenAdViewWillLeaveApplication:(nonnull VWFullscreenAdViewController *)fullscreenAdViewController;

@end
