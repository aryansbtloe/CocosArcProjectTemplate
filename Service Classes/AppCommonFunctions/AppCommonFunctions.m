//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "AppCommonFunctions.h"
#import "AppDelegate.h"
#import "CENotifier.h"

@implementation AppCommonFunctions
@synthesize appDelegate;

static AppCommonFunctions *singletonInstance = nil;

+ (AppCommonFunctions *)sharedInstance {
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
	    if (singletonInstance == nil) {
	        singletonInstance = [[AppCommonFunctions alloc]init];
	        singletonInstance.appDelegate = APPDELEGATE;
		}
	});
	return singletonInstance;
}

#pragma mark - startup configurations required for this class

- (void)prepareStartup {
}

#pragma mark - register this class for required notifications

- (void)registerForNotifications {
}

- (void)handleLocalRemoteNotification:(UILocalNotification *)notification {
}

#pragma mark - push notification handler methods

#define ALERT                          @"alert"
#define APS                            @"aps"
#define PUSH_TYPE                      @"pushType"

#define PUSHTYPE_ACCOUNT_SUCCESSFUL_ACTIVATION   @"account activation"

- (void)handlePushWith:(NSDictionary *)userInfo {
	NSString *alertMessage = [[userInfo objectForKey:APS]objectForKey:ALERT];
	NSString *pushType     = [userInfo objectForKey:PUSH_TYPE];
	if ([pushType isEqualToString:PUSHTYPE_ACCOUNT_SUCCESSFUL_ACTIVATION] &&[self isNotNull:alertMessage]) {
		[CENotifier displayInView:[appDelegate.window.rootViewController view] image:nil title:@"Congratulations!" text:alertMessage duration:3600 userInfo:nil delegate:nil];
	}else{
		[CENotifier displayInView:[appDelegate.window.rootViewController view] image:nil title:@"Notification!" text:alertMessage duration:3600 userInfo:nil delegate:nil];
	}
}

#pragma mark - CENotifier delegate

- (void)notifyView:(CENotifyView *)notifyView didReceiveInteraction:(NSDictionary *)userInfo {
}

@end
