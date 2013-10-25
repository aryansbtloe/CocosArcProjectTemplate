#import "CClineSprite.h"

@implementation CClineSprite

- (id)init {
    self = [super init];

    if (self) {
        CGSize s = [[CCDirector sharedDirector] winSize];
        renderTarget = [CCRenderTexture renderTextureWithWidth:s.width height:s.height];
        [renderTarget setPosition:ccp(s.width / 2, s.height / 2)];
        [self addChild:renderTarget z:1];
        pathBrush = [CCSprite spriteWithFile:@"dots.png"];
        pathBrush.color = ccWHITE;
        [pathBrush setOpacity:100];
        [pathBrush setScale:0.5];
        pathArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setLineOpacity:(GLubyte)anOpacity {
    [pathBrush setOpacity:anOpacity];
}

- (void)setLineScale:(float)scale {
    [pathBrush setScale:scale];
}

- (void)setLineColor:(ccColor3B)color {
    [pathBrush setColor:color];
}

- (void)setLinePosition:(CGPoint)position {
    [pathArray addObject:[NSValue valueWithCGPoint:position]];
    [self renderPath];
}

- (void)renderPath {
    [renderTarget clear:0 g:0 b:0 a:0];
    [renderTarget begin];

    for (int i = 0; i < pathArray.count - 1; i++) {
        CGPoint pt1;
        CGPoint pt2;

        [[pathArray objectAtIndex:i] getValue:&pt1];
        [[pathArray objectAtIndex:i + 1] getValue:&pt2];

        float distance = ccpDistance(pt1, pt2);

        if (distance > 1) {
            int d = (int)distance;
            for (int i = 0; i < d; i += 10) {
                float difx = pt2.x - pt1.x;
                float dify = pt2.y - pt1.y;
                float delta = (float)i / distance;

                [pathBrush setPosition:ccp(pt1.x + (difx * delta), pt1.y + (dify * delta))];
                [pathBrush visit];
            }
        }
    }
    [renderTarget end];
}

@end