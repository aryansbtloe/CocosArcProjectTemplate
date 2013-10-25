//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 MessageController:-

 MessageController class will handle user messages.

 */

@interface MessageController : NSObject


/**
 method to show points earned messsage
 */
+ (void)showPointsMessage:(int)points;

/**
 method to clear already show message(if any)
 */
+ (void)clearMessage;

@end
