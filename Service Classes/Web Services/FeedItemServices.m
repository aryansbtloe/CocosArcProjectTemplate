//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "FeedItemServices.h"
#import "SBJson.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "SBJsonParser.h"


@implementation FeedItemServices

@synthesize responseErrorOption;
@synthesize progresssIndicatorText;

/**
 METHODS TO DIRECTLY GET UPDATED DATA FROM THE SERVER
 */

- (id)init {
	self = [super init];
	if (self) {
		[self setResponseErrorOption:ShowErrorResponseWithUsingNotification];
	}
	return self;
}

#define CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:YES]) { operationFinishedBlock(nil); return; }
#define CONTINUE_IF_CONNECTION_AVAILABLE                if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) { operationFinishedBlock(nil); return; }
#define CONTINUE_IF_CONNECTION_AVAILABLE_1              if (![self getStatusForNetworkConnectionAndShowUnavailabilityMessage:NO]) { operationFinishedBlock(); return; }


#pragma mark - A POST REQUEST EXAMPLE

- (void)aPostRequestExample:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock {
	TCSTART

	CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG

	[AKSMethods removeAllKeysHavingNullValue : info];

	NSString *url = [[NSString stringWithFormat:EXAMPLE_URL] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

	NSMutableDictionary *bodyData = [[NSMutableDictionary alloc]init];

	[AKSMethods addParameterFrom:info WithKey:@"example_parameter1"    To:bodyData UnderKey:@"example_parameter1"          OnMethodName:METHOD_NAME];
	[AKSMethods addParameterFrom:info WithKey:@"example_parameter2"    To:bodyData UnderKey:@"example_parameter2"       OnMethodName:METHOD_NAME];

	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[NSURL URLWithString:url]host]]];

	NSMutableURLRequest *request = nil;

	if ([self isNotNull:[info objectForKey:@"image"]]) {
		request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:bodyData constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
		    [formData appendPartWithFileData:UIImagePNGRepresentation([info objectForKey:@"image"]) name:@"image" fileName:@"image.png" mimeType:@"image/png"];
		}];
	}
	else {
		request = [httpClient requestWithMethod:@"POST"path:url parameters:bodyData];
	}
	[self performRequestWithHttpClient:httpClient WithRequest:request WithBlock:operationFinishedBlock];

	TCEND
}

#pragma mark - A GET REQUEST EXAMPLE

- (void)aGetRequestExample:(NSMutableDictionary *)info didFinished:(operationFinishedBlock)operationFinishedBlock{
	[AKSMethods removeAllKeysHavingNullValue:info];

	CONTINUE_IF_CONNECTION_AVAILABLE_SHOW_ERROR_MSG

	NSString *url = [[NSString stringWithFormat:EXAMPLE_URL] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[NSURL URLWithString:url]host]]];
	NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
	                                                        path:url
	                                                  parameters:nil];
	[self prepareRequestForGetMethod:request];
	[self performRequestWithHttpClient:httpClient WithRequest:request WithBlock:operationFinishedBlock];
}


- (void)performRequestWithHttpClient:(AFHTTPClient *)httpClient WithRequest:(NSMutableURLRequest *)request WithBlock:(operationFinishedBlock)block {
	BOOL showActivityIndicator = (progresssIndicatorText != nil);

	if (showActivityIndicator)
		[CommonFunctions showActivityIndicatorWithText:progresssIndicatorText];

	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
	[operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    [self verifyServerResponseAndPerformAction:block WithResponseData:responseObject IfError:nil];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    [self verifyServerResponseAndPerformAction:block WithResponseData:nil IfError:error];
	}];
	[operation start];
}

- (void)verifyServerResponseAndPerformAction:(operationFinishedBlock)block WithResponseData:(id)responseData IfError:(NSError *)error {
	BOOL removeActivityIndicator = (progresssIndicatorText != nil);
	if (removeActivityIndicator)
		[CommonFunctions removeActivityIndicator];

	if ([self isNotNull:error]) {
		[self showServerNotRespondingMessage];
		[FeedItemServices printErrorMessage:error];
		block(nil);
	}
	else if ([self isNotNull:responseData]) {
		id responseDictionary = [self getParsedDataFrom:responseData];
		if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
			if ([self isSuccess:responseDictionary]) {
				block(responseDictionary);
			}
			else if ([[[responseDictionary objectForKey:@"ReplyCode"]uppercaseString]isEqualToString:@"ERROR"]) {
				if (responseErrorOption == ShowErrorResponseWithUsingNotification) {
					[CommonFunctions showNotificationInViewController:APPDELEGATE.window.rootViewController withTitle:nil withMessage:[responseDictionary objectForKey:@"ReplyMsg"] withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
				}
				else if (responseErrorOption == ShowErrorResponseWithUsingPopUp) {
				}
				block(nil);
			}
			else {
				[self showServerNotRespondingMessage];
				block(nil);
			}
		}
		else {
			block(nil);
		}
	}
	else {
		block(nil);
	}
}

#pragma mark - common method for Internet reachability checking

- (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage {
	AppDelegate *appDelegate = APPDELEGATE;
	if (([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)) {
		if (showMessage == NO) return NO;
		[CommonFunctions showNotificationInViewController:appDelegate.window.rootViewController withTitle:nil withMessage:@"Application requires an active internet connection.\nPlease check your network settings and try again." withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
		return NO;
	}
	return YES;
}

- (void)showServerNotRespondingMessage {
	[CommonFunctions showNotificationInViewController:APPDELEGATE.window.rootViewController withTitle:nil withMessage:@"Please try again after some time." withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
}

#pragma mark - common method parse and return the data

- (id)getParsedDataFrom:(NSData *)dataReceived {
	NSString *dataAsString = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
	id parsedData   = [[[SBJsonParser alloc]init] objectWithData:dataReceived];
	NSLog(@"\n\nRECEIVED DATA BEFORE PARSING IS \n\n%@\n\n\n", dataAsString);
	NSLog(@"\n\nRECEIVED DATA AFTER PARSING IS \n\n%@\n\n\n", parsedData);
	return parsedData;
}

- (void)prepareRequestForGetMethod:(NSMutableURLRequest *)request {
	[self addCredentialsToRequest:request];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

- (void)reportMissingParameterWithName:(NSString *)missingParameter WhileRequestingWithMethodName:(NSString *)method {
	NSString *report = [NSString stringWithFormat:@"\n\n\n PARAMETER MISSING\n\nPARAMETER NAME IS : %@ \n\nIN METHOD : %@ \n\n PLEASE CORRECT IT ASAP\n\n", missingParameter, method];
	NSLog(@"%@", report);
}

- (BOOL)isSuccess:(NSMutableDictionary *)response {
	if ([response isKindOfClass:[NSDictionary class]]) {
		if ([[[response objectForKey:@"replyCode"] uppercaseString]isEqualToString:@"SUCCESS"]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark - common method to add credentials to request

- (void)addCredentialsToRequest:(NSMutableURLRequest *)request {
#define NEED_TO_ADD_CREDENTIALS FALSE
	if (NEED_TO_ADD_CREDENTIALS) {
		NSString *userName = @"";
		NSString *password = @"";
		if ([self isNotNull:userName] && [self isNotNull:password]) {
			[request addValue:[@"Basic "stringByAppendingFormat : @"%@", [self encode:[[NSString stringWithFormat:@"%@:%@", userName, password] dataUsingEncoding:NSUTF8StringEncoding]]] forHTTPHeaderField:@"Authorization"];
		}
	}
}

#pragma mark - common method to do some encoding

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
- (NSString *)encode:(NSData *)plainText {
	int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
	unsigned char *outputBuffer = malloc(encodedLength);
	unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
	NSInteger i;
	NSInteger j = 0;
	int remain;
	for (i = 0; i < [plainText length]; i += 3) {
		remain = [plainText length] - i;
		outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
		                             ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4) : 0)];

		if (remain > 1)
			outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
			                             | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
		else outputBuffer[j++] = '=';

		if (remain > 2) outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
		else outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];
	free(outputBuffer);
	return result;
}

+ (void)printErrorMessage:(NSError *)error {
	if (error) {
		NSLog(@"[error localizedDescription]        : %@", [error localizedDescription]);
		NSLog(@"[error localizedFailureReason]      : %@", [error localizedFailureReason]);
		NSLog(@"[error localizedRecoverySuggestion] : %@", [error localizedRecoverySuggestion]);
	}
}

@end
