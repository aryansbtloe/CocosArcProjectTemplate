//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef ApplicationSpecificConstants_h
#define ApplicationSpecificConstants_h

/**
 Constants:-

 This header file holds all configurable constants specific  to this application.

 */

////////////////////////////////////////SOME MACROS TO MAKE YOUR PROGRAMING LIFE EASIER/////////////////////////////////////////

/**
 return if no internet connection is available with and without error message
 */
#define RETURN_IF_NO_INTERNET_AVAILABLE_WITH_USER_WARNING if (![CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]) return;
#define RETURN_IF_NO_INTERNET_AVAILABLE                   if (![CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) return;

/**
 get status of internet connection
 */
#define IS_INTERNET_AVAILABLE_WITH_USER_WARNING           [CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]
#define IS_INTERNET_AVAILABLE                             [CommonFunctions getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]

#define SHOW_SERVER_NOT_RESPONDING_MESSAGE                [CommonFunctions showNotificationInViewController:self withTitle:nil withMessage:@"Server not responding .Please try again after some time." withType:TSMessageNotificationTypeError withDuration:MIN_DUR];

#define MIN_DUR 2

#define PUSH_NOTIFICATION_DEVICE_TOKEN                    @"deviceToken"

#define MAX_ANIMATION_FREQUENCY 1.0 / 60


/**
 various constants to configure the game level
 */


/**
 some fixed constants
 */


/**
 various notifications used through out the application
 */


/**
 various message string used throughout the application
 */

/**
 various fonts used through out the application
 */

#define FONT_TYPE_1 @"Verdana"
#define FONT_TYPE_2 @"Marker Felt"

#endif
