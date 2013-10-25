//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LocalNotificationHelper : NSObject

+ (BOOL)scheduleLocalNotificationWithBody:(NSString*)alertBody
								   action:(NSString*)alertAction 
									sound:(NSString*)soundName 
									badge:(NSInteger)appIconBadgeNumber 
								 userInfo:(id)userInfo 
									after:(NSUInteger)seconds
								 repeated:(NSCalendarUnit)interval;

+ (BOOL)scheduleLocalNotificationWithBody:(NSString*)alertBody 
								   action:(NSString*)alertAction 
									sound:(NSString*)soundName 
									badge:(NSInteger)appIconBadgeNumber 
								 userInfo:(id)userInfo 
									 year:(NSUInteger)year 
									month:(NSUInteger)month 
									  day:(NSUInteger)day 
									 hour:(NSUInteger)hour 
								   minute:(NSUInteger)minute
								 repeated:(NSCalendarUnit)interval;

+ (BOOL)scheduleLocalNotificationWithBody:(NSString*)alertBody 
								   action:(NSString*)alertAction 
									sound:(NSString*)soundName 
									badge:(NSInteger)appIconBadgeNumber 
								 userInfo:(id)userInfo 
									   on:(NSDate*)date
								 repeated:(NSCalendarUnit)interval;

+ (BOOL)presentLocalNotificationNow:(UILocalNotification*)notification;

+ (BOOL)presentLocalNotificationNowWithBody:(NSString*)alertBody 
									 action:(NSString*)alertAction 
									  sound:(NSString*)soundName 
									  badge:(NSInteger)appIconBadgeNumber 
								   userInfo:(id)userInfo
								   repeated:(NSCalendarUnit)interval;

+ (BOOL)cancelAllLocalNotifications;

+ (NSArray*)scheduledLocalNotifications;

+ (BOOL)cancelLocalNotification:(UILocalNotification*)notification;

+ (UILocalNotification*)localNotificationWithBody:(NSString*)alertBody 
										   action:(NSString*)alertAction 
											sound:(NSString*)soundName 
											badge:(NSInteger)appIconBadgeNumber 
										 userInfo:(id)userInfo 
											   on:(NSDate*)date 
										 repeated:(NSCalendarUnit)interval;

+ (NSArray*)getAllScheduledLocalNotifications;


@end
