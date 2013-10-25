//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "CommonMethodsController.h"
#import "MessageController.h"


static CommonMethodsController *commonMethodsController_ = nil;

/**

 CommonMethodsController:-

 CommonMethodsController class will handle game current common methods.

 */

@implementation CommonMethodsController


#pragma mark - Methods for allocate and initialise the object of this class

+ (CommonMethodsController *)sharedCommonMethodsController {
    TCSTART

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (commonMethodsController_ == nil) {
            commonMethodsController_ = [[CommonMethodsController alloc]init];
        }
    });
    return commonMethodsController_;

    TCEND
}

+ (id)alloc {
    NSAssert(commonMethodsController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

+ (void)showParticleSystemEffectAt:(CGPoint)position {
    CCParticleSystem *ps = [CCParticleExplosion node];
    ps.texture = [[CCTextureCache sharedTextureCache] addImage:@"stars.png"];
    ps.position = position;
    ps.life = 0.5f;
    ps.lifeVar = 0.5f;
    ps.totalParticles = 60.0f;
    ps.autoRemoveOnFinish = YES;
    [[(CCDirectorIOS *)[CCDirector sharedDirector] runningScene] addChild:ps z:12];
}

@end
