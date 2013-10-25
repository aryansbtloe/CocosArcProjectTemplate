//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "DynamicConfigurationsController.h"

static DynamicConfigurationsController *dynamicConfigurationsController_ = nil;

/**

 DynamicConfigurationsController:-
 DynamicConfigurationsController class will handle game current common configuration dynamically.

 */

@implementation DynamicConfigurationsController

#pragma mark - Methods for allocate and initialise the object of this class

+ (DynamicConfigurationsController *)sharedDynamicConfigurationsController {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (dynamicConfigurationsController_ == nil) {
            dynamicConfigurationsController_ = [[DynamicConfigurationsController alloc]init];
        }
    });
    return dynamicConfigurationsController_;
}

+ (id)alloc {
    NSAssert(dynamicConfigurationsController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

@end
