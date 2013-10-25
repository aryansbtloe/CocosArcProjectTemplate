//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

/**

 AppDelegate:-

 Application delegate class

 */

@interface AppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
    /**
     window object
     */
    UIWindow *window;

    /**
     navigation controller for the application
     */
    UINavigationController *navigationController;

    /**
     cocos2d director to render everything related to cocos
     */
    CCDirectorIOS *__unsafe_unretained cocosDirector;
	
    /**
     bool to specify that before going to background game was paused intentionally
	 and should not automatically resume in such a case
     */
	BOOL    gamePausedIntentionally;
}

/**
 cocos2d director to render everything related to cocos
 */
@property (unsafe_unretained, readonly) CCDirectorIOS *cocosDirector;

/**
 navigation controller for the application
 */
@property (nonatomic, retain) UINavigationController *navigationController;

/**
 window object
 */
@property (nonatomic, retain) UIWindow *window;


@property (nonatomic, readwrite)BOOL gamePausedIntentionally;


@end