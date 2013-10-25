//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef ViewController_Macros_h
#define ViewController_Macros_h

#define RETURN_IF_THIS_VIEW_IS_NOT_A_TOPVIEW_CONTROLLER if (self.navigationController) if (!(self.navigationController.topViewController == self)) return;

#define SHOW_STATUS_BAR               [[UIApplication sharedApplication] setStatusBarHidden : NO withAnimation : UIStatusBarAnimationNone];
#define HIDE_STATUS_BAR               [[UIApplication sharedApplication] setStatusBarHidden : YES withAnimation : UIStatusBarAnimationNone];

#define SHOW_NAVIGATION_BAR           [self.navigationController setNavigationBarHidden : FALSE];
#define HIDE_NAVIGATION_BAR           [self.navigationController setNavigationBarHidden : TRUE];

#define VC_OBJ(x) [[x alloc] init]
#define VC_OBJ_WITH_NIB(x) [[x alloc] initWithNibName:(NSString *)CFSTR(#x) bundle:nil]

//macros for ios 6 orientation support
#ifndef ORIENTATION_SUPPORT_LANDSCAPE_RIGHT__ONLY
#define ORIENTATION_SUPPORT_LANDSCAPE_RIGHT__ONLY \
- (BOOL)shouldAutorotate { \
return NO; \
} \
-(NSUInteger)supportedInterfaceOrientations { \
return UIInterfaceOrientationMaskLandscapeRight; \
}

#endif

#ifndef ORIENTATION_SUPPORT_PORTRAIT_ONLY
#define ORIENTATION_SUPPORT_PORTRAIT_ONLY \
- (BOOL)shouldAutorotate { \
return NO; \
} \
-(NSUInteger)supportedInterfaceOrientations { \
return UIInterfaceOrientationMaskPortrait; \
}

#endif

#define IOS_STANDARD_COLOR_BLUE                        [UIColor colorWithHue : 0.6 saturation : 0.33 brightness : 0.69 alpha : 1]
#define CLEAR_NOTIFICATION_BADGE                       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#define REGISTER_APPLICATION_FOR_NOTIFICATION_SERVICE  [[UIApplication sharedApplication] registerForRemoteNotificationTypes :(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)]



#define FONT_REGULAR                  @ "Solomon"
#define FONT_HEAVY                    @ "Solomon-Heavy"
#define FONT_BOLD                     @ "Solomon-Bold"

#define APPDELEGATE                                     ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define HIDE_NETWORK_ACTIVITY_INDICATOR                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible : NO];
#define SHOW_NETWORK_ACTIVITY_INDICATOR                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible : YES];

#define SCREEN_FRAME_RECT                               [[UIScreen mainScreen] bounds]

#define DATE_FORMAT_USED @"yyyy'-'MM'-'dd' 'HH':'mm':'ss"

#define NAVIGATION_BAR_HEIGHT 44

#endif
