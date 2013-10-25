//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "FrameCacheController.h"

/**

 FrameCacheController:-

 FrameCacheController class will prepare various image frames used throughout the application.

 */

@implementation FrameCacheController


+ (void)prepareGameSpriteSheets {
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	/**
	[cache addSpriteFramesWithFile:@"NormalWalkingPredatorSprite4.plist"];
    [[CCTextureCache sharedTextureCache] addImage:@"dots.png"];
	 */
}

@end
