//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PredatorsAndTurtlesLayer;

#define dynamicConfigurationController [DynamicConfigurationsController sharedDynamicConfigurationsController]

/**

 DynamicConfigurationsController:-

 DynamicConfigurationsController class will handle game current common configuration dynamically.

 */

@interface DynamicConfigurationsController : NSObject{
}

/**
 singleton object for this class
 */
+ (DynamicConfigurationsController *)sharedDynamicConfigurationsController;

@end
