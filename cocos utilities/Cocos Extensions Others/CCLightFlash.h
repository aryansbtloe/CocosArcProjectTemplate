//
//  CCLightFlash.h
//  SkullExplodeTest
//
//  Created by Robert Topala on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define flashStartDelay  0.8f
#define flashFadeInTime  0.3f
#define flashMidDelay    0.5f
#define flashFadeOutTime 1.5f




@interface CCLightFlash : CCNode
{
    CCArray *container_;
    CCLayerColor *flashLayer_;

    id flashP_;
    int flashZ_;
}

@property (nonatomic, assign) id flashP;
@property (nonatomic, assign) int flashZ;

+ (id)lightFlashWithOrigin:(CGPoint)origin Color:(ccColor3B)color;
- (id)initWithOrigin:(CGPoint)origin Color:(ccColor3B)color;
- (void)showFlash;
- (void)removeLights;
- (void)cleanupFlash;

@end




@interface CCLightStrip : CCNode
{
    float bW_;
    float tW_;
    float tH_;
    float dur_;

    float height_;
    float width_;
    float opacity_;

    ccColor3B color_;
}

@property (nonatomic, assign) ccColor3B color;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) float width, height;

+ (id)lightStripWithBW:(float)bW tW:(float)tW tH:(float)tH Duration:(float)dur Delay:(float)delay;
- (id)initStripWithBW:(float)bW tW:(float)tW tH:(float)tH Duration:(float)dur Delay:(float)delay;

@end