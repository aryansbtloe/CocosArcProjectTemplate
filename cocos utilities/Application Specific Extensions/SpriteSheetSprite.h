//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//


#import "cocos2d.h"


/**

 SpriteSheetSprite:-

 This singleton utility class creates a animating sprite with specified sprite sheets frames.

 */

@interface SpriteSheetSprite : CCSprite


/**
 method to creates a animating sprite with specified sprite sheets frames.
 */
+ (id)newAnimSprite:(NSString *)sheetName withCapacity:(int)capacity withDelay:(float)delay withSpriteClass:(id)spriteClass;

@end
