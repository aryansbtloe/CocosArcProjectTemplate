//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#ifndef Debugging_Macros_h
#define Debugging_Macros_h


#if 0
#define NSLog  //NSLog
#endif

#define METHOD_NAME                                    [NSString stringWithFormat : @ "%s", __PRETTY_FUNCTION__]

#define OBSERVATION_POINT                               NSLog(@ "\n%@ EXECUTED upto %d\n", METHOD_NAME, __LINE__);

//////////////////////ADVANCED TRY CATCH SYSTEM////////////////////////////////////////
#ifndef UseTryCatch
#define UseTryCatch                                     1
#ifndef UsePTMName
#define UsePTMName                                      0 //USE 0 TO DISABLE AND 1 TO ENABLE PRINTING OF METHOD NAMES WHERE EVER TRY CATCH IS USED
#if UseTryCatch
#if UsePTMName
#define TCSTART                                         @try { NSLog(@ "\n%@\n", METHOD_NAME);
#else
#define TCSTART                                         @try {
#endif
#define TCEND                                           } @catch (NSException *e) { NSLog(@ "\n\n\n\n\n\n\
\n\n|EXCEPTION FOUND HERE...PLEASE DO NOT IGNORE\
\n\n|FILE NAME         %s\
\n\n|LINE NUMBER       %d\
\n\n|METHOD NAME       %@\
\n\n|EXCEPTION REASON  %@\
\n\n\n\n\n\n\n", strrchr(__FILE__, '/'), __LINE__, METHOD_NAME, e); };
#else
#define TCSTART                                         {
#define TCEND                                           }
#endif
#endif
#endif
//////////////////////ADVANCED TRY CATCH SYSTEM////////////////////////////////////////

#endif
