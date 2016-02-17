//
//  VWInterstitial.h
//  VWAdLibrary
//
//  Copyright (c) 2012 Verve Wireless, Inc.
//

/*
 * A VWInterstitial is a single-use object for loading and presenting an interstitial.
 *
 * Because interstitials interrupt the user, you should ensure you only present them
 * infrequently.
 *
 * If you want to present interstitials at certain intervals then you can use
 * VWInterstitialManager to manage that for you.
 *
 * Note: interactions with a VWInterstitial should occur on the main thread only.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import "VWContentCategory.h"

extern NSString * const VWInterstitialErrorDomain;

/* Possible error codes for VWInterstitialErrorDomain. */
enum {
  VWInterstitialErrorUnknown = 0,
  VWInterstitialErrorEngineError = 1, // underlying error available in userInfo NSUnderlyingErrorKey
  VWInterstitialErrorAlreadyRequested = 2,
  VWInterstitialErrorMissingBaseURL = 3,
};
typedef NSInteger VWInterstitialError;

typedef void (^VWInterstitialCompletionBlock)(BOOL presentationCancelled);

@protocol VWInterstitialDelegate;


__deprecated_msg("VWInterstitial has been deprecated and will be removed in future versions. Please use VWInterstitialAd instead.")
@interface VWInterstitial : NSObject

@property (nonatomic, weak) id <VWInterstitialDelegate> delegate;

@property (nonatomic, assign, readonly) VWContentCategory contentCategoryID;
@property (nonatomic, assign, readonly) NSInteger displayBlockID;
@property (nonatomic, assign, readonly) NSInteger partnerModuleID;

/*
 * The location property is ignored and deprecated since v1.5.0.
 *
 * Setting the postalCode is when location services are disabled or unavailable.
 */
@property (nonatomic, retain) CLLocation *location __deprecated;
@property (nonatomic, copy) NSString *postalCode;

/*
 * The isLoaded accessor will tell you if the interstitial ad response is ready
 * and available for presentation.
 * If you want to take action as soon as the ad response is ready then implement
 * the verveInterstitialDidLoad: delegate method rather than poll on this value.
 */
@property (nonatomic, readonly, getter=isLoaded) BOOL loaded;

/*
 * View controller that displays ad. If you want to provide custom presentation of the
 * interstitial, present this controller on verveInterstitialManagerTransitionedWithPresentableInterstital:
 * event. Be sure to set interstitialPresenting to YES if you presented controller.
 */
@property (nonatomic, readonly, strong) UIViewController *viewControllerToPresent;

/*
 * The isPresenting accessor will tell you if the interstitial view is currently
 * visible on-screen. 
 *
 * Note: When providing custom presentation of interstitial it is imperative that you
 * set this property according to the current state of the interstitial.
 */
@property (nonatomic, readonly, getter=isPresenting) BOOL presenting;

/*
 * When set to YES webview inside of an interstitial will not be scrollable.
 * By default this is set to NO.
 */
@property (nonatomic, assign) BOOL scrollingDisabled;

/*
 * An intersitital request must always have positive, non-zero content category.
 *
 * Include display block ID only if you've got it.
 *
 * Include partner module ID if you have a set of values assigned for
 * your content.
 *
 * You are responsible for maintaining a strong reference to a VWInterstitial. Required
 * delegate callbacks will inform you of appropriate times to release your reference.
 */
- (id)initWithContentCategoryID:(VWContentCategory)contentCategory;
- (id)initWithContentCategoryID:(VWContentCategory)contentCategory displayBlockID:(NSInteger)displayBlock;
- (id)initWithContentCategoryID:(VWContentCategory)contentCategory displayBlockID:(NSInteger)displayBlock partnerModuleID:(NSInteger)partnerModule;

/*
 * Once you have initialized and (optionally) configured the additional information for
 * the interstitial, you request the ad with this method.
 *
 * loadWithDelegate: will respond with a NO if you have previously called loadWithDelegate:error:
 * or if there is no base ad request URL configured for your app. In either of those cases the error 
 * pointer will be filled in, however you would not typically display the error to a user.
 */
- (BOOL)loadWithDelegate:(id<VWInterstitialDelegate>)delegate error:(NSError**)error;

/*
 * If the interstitial is loaded, calling presentFromViewController: will cause the interstital
 * to be displayed. The interstitial will be presented modally on the viewController but you
 * should not rely on that particular implementation detail.
 */
- (BOOL)presentFromViewController:(UIViewController *)viewController;

/*
 * This variant of presetnFromViewController: also adds a guarantee to call your completion block
 * when the interstitial is dismissed. You can use this instead of, or in addition to, the 
 * verveInterstitial:didDismissPresentationAsCancellation: delegate callback.
 */
- (BOOL)presentFromViewController:(UIViewController *)viewController withCompletion:(VWInterstitialCompletionBlock)completionBlock;

/* 
 * Once you have presented the interstitial you can forcibly dismiss the interstitial view by calling
 * cancelPresentation. This may be useful for situations like dismissing a visible interstitial
 * in response to the user putting the application into the background.
 *
 * The verveInterstitialDidUnload: delegate method will *not* fire in response, however the 
 * verveInterstitial:didDismissPresentationAsCancellation: method will fire, as will any completion
 * block you may have supplied.
 */
- (void)cancelPresentation;

@end


@protocol VWInterstitialDelegate <NSObject>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@required

/*
 * These two delegate methods inform you of when the interstitial has either
 * completed its presentation or failed to load in the first place.
 * In either case, you should release your reference to the interstitial.
 */
- (void)verveInterstitialDidUnload:(VWInterstitial*)interstitial;
- (void)verveInterstitial:(VWInterstitial*)interstitial didFailWithError:(NSError*)error;

@optional

/*
 * When the interstitial has loaded an ad response and is ready for presentation
 * you will receive this callback. It is your responsibility to call one of the 
 * presentFromViewController: methods and to pause any application activity that 
 * would conflict with the on-screen interstitial.
 */
- (void)verveInterstitialDidLoad:(VWInterstitial*)interstitial;

/*
 * You can use this callback as a signal to resume application activity after the
 * interstitial has been dismissed.
 * The cancellation parameter is a hint that cancelPresentation was called, allowing
 * you to adjust your response. For example, you may not wish to resume certain
 * activities if you typically call cancelPresentation when the application has been
 * put into the background.
 */
- (void)verveInterstitial:(VWInterstitial*)interstitial didDismissPresentationAsCancellation:(BOOL)cancellation;

/*
 * By implementing this method you can control visibility of interstitial's dismiss control.
 */
- (BOOL)interstitialShouldShowDismissControl:(VWInterstitial *)interstitial;

/*
 * If you are doing a custom presentation of the interstitial and you're not hiding interstitial's dismiss control,
 * you must provide custom dismissal mechanism by implementing this method. This method will be called when user
 * taps dismiss button on interstitial.
 *
 * Note: It is imperative that you set interstitialPresenting property to NO so that library knows you
 * successfully dismissed interstitial.
 */
- (void)dismissInterstitialViewControllerVerveInterstitial:(VWInterstitial*)interstitial;

#pragma clang diagnostic pop

@end
