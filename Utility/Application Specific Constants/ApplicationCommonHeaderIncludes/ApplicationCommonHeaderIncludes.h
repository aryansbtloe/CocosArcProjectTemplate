//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef ApplicationCommonHeaderIncludes_h
#define ApplicationCommonHeaderIncludes_h

/**
 Import headers of frequently used classes
 Note:- Do not import unnecessary files as them may slow down application compile time as well as can increase the application build size.
 */

/**
 Default frequently used
 */
#import <QuartzCore/QuartzCore.h>


/**
 Commonly used frameworks
 */
#import "TSMessage.h"
#import "AKSMethods.h"
#import "AksAnimations.h"
#import "CommonFunctions.h"
#import "ApplicationSpecificConstants.h"
#import "GlobalData.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "CacheManager.h"
#import "GameControllers.h"

/**
 Useful Category Classes
 */
#import "AllCategories.h"

/**
 Useful Macros Classes
 */
#import "All Macros.h"

/**
 Frequently used custom classes
 */
#import "AppDelegate.h"
#import "FeedItemServices.h"
#import <objc/runtime.h>
#import "AppCommonFunctions.h"

#endif
