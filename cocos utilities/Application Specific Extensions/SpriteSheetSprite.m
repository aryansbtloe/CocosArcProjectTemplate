//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//


#import "SpriteSheetSprite.h"

/**

 SpriteSheetSprite:-

 This singleton utility class creates a animating sprite with specified sprite sheets frames.

 */

@implementation SpriteSheetSprite

static NSMutableDictionary *allFrames_;



#pragma mark - method to creates frames with specified sheet name.

+ (NSMutableArray *)loadFrames:(NSString *)sheetName withCapacity:(int)capacity {
    if (!allFrames_) allFrames_ = [NSMutableDictionary dictionaryWithCapacity:10];

    NSMutableArray *frames;

    if ((frames = [allFrames_ objectForKey:sheetName]) == nil) {
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];

        NSString *frameNameFormat = [NSString stringWithFormat:@"%@%%04d.png", sheetName];

        frames = [NSMutableArray array];

        for (int i = 1; i <= capacity; i++) {
            NSString *frameName = [NSString stringWithFormat:frameNameFormat, i];
            CCSpriteFrame *frame = [cache spriteFrameByName:frameName];
            [frames addObject:frame];
        }

        [allFrames_ setObject:frames forKey:sheetName];
    }

    return frames;
}

#pragma mark - method to creates a animating sprite with specified sprite sheets frames.

+ (id)newAnimSprite:(NSString *)sheetName withCapacity:(int)capacity withDelay:(float)delay withSpriteClass:(id)spriteClass {
    NSString *spriteFrameName = [NSString stringWithFormat:@"%@%04d.png", sheetName, 1];

    id sprite = [spriteClass spriteWithSpriteFrameName:spriteFrameName];

    NSMutableArray *frames = [self loadFrames:sheetName withCapacity:capacity];

    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:delay];

    [sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];

    return sprite;
}

@end
