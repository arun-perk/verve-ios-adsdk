//
//  VWFullscreenAdViewController.h
//  VWAdLibrary
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Verve Wireless, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VWFullscreenAdViewControllerDelegate;

/**
 Represents view controller that can show full screen ads.
 */
@interface VWFullscreenAdViewController : UIViewController

@property (nonatomic, weak, nullable) id<VWFullscreenAdViewControllerDelegate> delegate;

/**
 Should show dismiss control.
 */
@property (nonatomic, assign) BOOL dismissControlVisible;
/**
 Should disable scroll interaction.
 */
@property (nonatomic, assign) BOOL scrollingDisabled;

@end

@protocol VWFullscreenAdViewControllerDelegate <NSObject>

@required
- (void)fullscreenAdViewControllerWantsToClose:(nonnull VWFullscreenAdViewController *)fullscreenAdViewController;

@optional
- (void)fullscreenAdViewWillLeaveApplication:(nonnull VWFullscreenAdViewController *)fullscreenAdViewController;

@end
