//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

/**

 AppCommonFunctions:-

 This singleton class implements some app specific methods which are frequently needed in application.

 */
@interface AppCommonFunctions : NSObject {
	AppDelegate *appDelegate;
}
@property (strong, nonatomic) AppDelegate *appDelegate;

+ (AppCommonFunctions *)sharedInstance;
- (void)prepareStartup;
- (void)handleLocalRemoteNotification:(UILocalNotification *)notification;
- (void)handlePushWith:(NSDictionary *)userInfo;

@end
