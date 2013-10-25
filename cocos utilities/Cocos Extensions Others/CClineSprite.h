#import "cocos2d.h"

@interface CClineSprite : CCLayer
{
    CCRenderTexture *renderTarget;
    NSMutableArray *pathArray;
    CCSprite *pathBrush;
    CGPoint prePosition;
}

- (void)setLinePosition:(CGPoint)position;

- (void)setLineOpacity:(GLubyte)anOpacity;

- (void)setLineScale:(float)scale;

- (void)setLineColor:(ccColor3B)color;

@end