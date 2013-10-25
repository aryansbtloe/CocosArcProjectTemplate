//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

/**
 FeedItemServices:-
 This service class initiates and handles all server interaction related network connection.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ResponseErrorOption) {
	DontShowErrorResponseMessage = 0,
	ShowErrorResponseWithUsingNotification, //Default value is set to this option
	ShowErrorResponseWithUsingPopUp
};

@class AppDelegate;

typedef void (^operationFinishedBlock)(id responseData);
typedef void (^operationFinishedBlockWithOutUpdate)();


@interface FeedItemServices : NSObject

@property (nonatomic, readwrite) ResponseErrorOption responseErrorOption;
@property (nonatomic, retain) NSString *progresssIndicatorText;
/**
 write comments here
 */
- (void)aPostRequestExample:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock;
/**
 write comments here
 */
- (void)aGetRequestExample:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock;

@end



#define TRUE_FOR_LOCAL_SERVER____FALSE_FOR_GLOBAL_SERVER 0
#if TRUE_FOR_LOCAL_SERVER____FALSE_FOR_GLOBAL_SERVER
#define BASE_URL                          @"http://local server"
#else
#define BASE_URL                          @"http://global server"
#endif


/**
 write comments here
 */
#define EXAMPLE_URL                       @"url"