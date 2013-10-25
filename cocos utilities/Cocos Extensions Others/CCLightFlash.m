//
//  CCLightStrip.m
//  SkullExplodeTest
//
//  Created by Robert Topala on 2/28/12.
//  Copyright 2012 RobTop Games. All rights reserved.
//

#import "CCLightFlash.h"

@implementation CCLightFlash

@synthesize flashP;
@synthesize flashZ;

+ (id)lightFlashWithOrigin:(CGPoint)origin Color:(ccColor3B)color {
    return [[self alloc] initWithOrigin:origin Color:color];
}

- (id)initWithOrigin:(CGPoint)origin Color:(ccColor3B)color {
    if ( (self = [super init])) {
        container_ = [[CCArray alloc] initWithCapacity:0];

        for (int i = 0; i < 7; i++) {
            CCLightStrip *light = [CCLightStrip lightStripWithBW:1 tW:10 + CCRANDOM_0_1() * 20 tH:480 Duration:0.15f + CCRANDOM_MINUS1_1() * 0.1f Delay:i * 0.1f + CCRANDOM_0_1() * 0.1f];
            [self addChild:light z:1];
            light.position = origin;
            light.rotation = CCRANDOM_0_1() * 360;
            light.opacity = arc4random() % 155 + 150;
            light.color = color;
            [container_ addObject:light];
        }

        id delay = [CCDelayTime actionWithDuration:flashStartDelay];
        id callfunc = [CCCallFunc actionWithTarget:self selector:@selector(showFlash)];
        id seq = [CCSequence actions:delay, callfunc, nil];
        [self runAction:seq];
    }
    return self;
}

- (void)showFlash {
    if (!flashP_) flashP_ = self;

    flashLayer_ = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 0)];
    [flashLayer_ setBlendFunc:(ccBlendFunc) {GL_SRC_ALPHA, GL_ONE }];
    [flashP_ addChild:flashLayer_ z:flashZ_];

    id fadeIn = [CCFadeIn actionWithDuration:flashFadeInTime];
    fadeIn = [CCEaseIn actionWithAction:fadeIn rate:2.0f];
    id callfunc = [CCCallFunc actionWithTarget:self selector:@selector(removeLights)];
    id delay = [CCDelayTime actionWithDuration:flashMidDelay];
    id fadeOut = [CCFadeOut actionWithDuration:flashFadeOutTime];
    fadeOut = [CCEaseInOut actionWithAction:fadeOut rate:2.0f];

    id remove = [CCCallFunc actionWithTarget:self selector:@selector(cleanupFlash)];

    id seq = [CCSequence actions:fadeIn, callfunc, delay, fadeOut, remove, nil];
    [flashLayer_ runAction:seq];
}

- (void)removeLights {
    for (int i = 0; i < [container_ count]; i++) {
        [[container_ objectAtIndex:i] removeFromParentAndCleanup:YES];
    }
}

- (void)cleanupFlash {
    [flashLayer_ removeFromParentAndCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
}

@end

@implementation CCLightStrip

@synthesize width = width_;
@synthesize height = height_;
@synthesize opacity = opacity_;
@synthesize color = color_;

+ (id)lightStripWithBW:(float)bW tW:(float)tW tH:(float)tH Duration:(float)dur Delay:(float)delay {
    return [[self alloc] initStripWithBW:bW tW:tW tH:tH Duration:dur Delay:delay];
}

- (id)initStripWithBW:(float)bW tW:(float)tW tH:(float)tH Duration:(float)dur Delay:(float)delay {
    if (self == [super init]) {
        bW_ = bW;
        tW_ = tW;
        tH_ = tH;
        dur_ = dur;

        width_ = bW;
        height_ = 1.0f;

        opacity_ = 255;

        self.visible = NO;

        // Create the actions
        id delayAction = [CCDelayTime actionWithDuration:delay];

        id show = [CCShow action];

        id hAction = [CCActionTween actionWithDuration:dur key:@"height" from:height_ to:tH];
        hAction = [CCEaseOut actionWithAction:hAction rate:2.0f];
        id wAction = [CCActionTween actionWithDuration:dur key:@"width" from:width_ to:tW_];
        wAction = [CCEaseOut actionWithAction:wAction rate:2.0f];

        id spawn = [CCSpawn actions:hAction, wAction, nil];

        id seq = [CCSequence actions:delayAction, show, spawn, nil];

        [[CCActionManager sharedManager] addAction:seq target:self paused:NO];
    }

    return self;
}

@end