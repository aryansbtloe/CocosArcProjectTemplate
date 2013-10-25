//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


/**

 FrameCacheController:-

 FrameCacheController class will prepare various image frames used throughout the application.

 */

@interface FrameCacheController : NSObject

/**
 method to prepare and add commonly used frame and spritesheets in the cache
 */
+ (void)prepareGameSpriteSheets;

@end
