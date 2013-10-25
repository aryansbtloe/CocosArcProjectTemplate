//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "RemoveNode.h"

/**

 RemoveNode:-

 This is an extension to cocos2d.This is an action to remove itself from parent node.

 */

@implementation RemoveNode

- (void)startWithTarget:(id)aTarget {
    [super startWithTarget:aTarget];
    [((CCNode *)target_)removeFromParentAndCleanup : YES];
}

@end
