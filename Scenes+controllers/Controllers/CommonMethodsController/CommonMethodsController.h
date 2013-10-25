//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 CommonMethodsController:-

 CommonMethodsController class will handle game current common methods.

 */

@interface CommonMethodsController : NSObject

/**
 singleton object for this class
 */
+ (CommonMethodsController *)sharedCommonMethodsController;

+ (void)showParticleSystemEffectAt:(CGPoint)position;

@end
