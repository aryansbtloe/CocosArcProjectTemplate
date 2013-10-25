//
//  SIAlertView.h
//  SIAlertView
//
//  Created by Kevin Cao on 13-4-29.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SIAlertViewWillShowNotification;
extern NSString *const SIAlertViewDidShowNotification;
extern NSString *const SIAlertViewWillDismissNotification;
extern NSString *const SIAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, SIAlertViewButtonType) {
    SIAlertViewButtonTypeDefault = 0,
    SIAlertViewButtonTypeDestructive,
    SIAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, SIAlertViewBackgroundStyle) {
    SIAlertViewBackgroundStyleGradient = 0,
    SIAlertViewBackgroundStyleSolid,
};

typedef NS_ENUM(NSInteger, SIAlertViewTransitionStyle) {
    SIAlertViewTransitionStyleSlideFromBottom = 0,
    SIAlertViewTransitionStyleSlideFromTop,
    SIAlertViewTransitionStyleFade,
    SIAlertViewTransitionStyleBounce,
    SIAlertViewTransitionStyleDropDown
};

@class SIAlertView;
typedef void(^SIAlertViewHandler)(SIAlertView *alertView);

@interface SIAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) SIAlertViewTransitionStyle transitionStyle; // default is SIAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) SIAlertViewBackgroundStyle backgroundStyle; // default is SIAlertViewButtonTypeGradient

@property (nonatomic, copy) SIAlertViewHandler willShowHandler;
@property (nonatomic, copy) SIAlertViewHandler didShowHandler;
@property (nonatomic, copy) SIAlertViewHandler willDismissHandler;
@property (nonatomic, copy) SIAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(SIAlertViewButtonType)type handler:(SIAlertViewHandler)handler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end



























/**

 HOW TO USE


 {
 SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Title2" andMessage:@"Message2"];
 [alertView addButtonWithTitle:@"Cancel"
 type:SIAlertViewButtonTypeCancel
 handler:^(SIAlertView *alertView) {
 NSLog(@"Cancel Clicked");
 }];
 [alertView addButtonWithTitle:@"OK"
 type:SIAlertViewButtonTypeDefault
 handler:^(SIAlertView *alertView) {
 NSLog(@"OK Clicked");

 [self alert3:nil];
 [self alert3:nil];
 }];
 alertView.titleColor = [UIColor blueColor];
 alertView.cornerRadius = 10;
 alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
 alertView.transitionStyle = SIAlertViewTransitionStyleBounce;

 alertView.willShowHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, willShowHandler2", alertView);
 };
 alertView.didShowHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, didShowHandler2", alertView);
 };
 alertView.willDismissHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, willDismissHandler2", alertView);
 };
 alertView.didDismissHandler = ^(SIAlertView *alertView) {
 NSLog(@"%@, didDismissHandler2", alertView);
 };

 [alertView show];
 }




*/