//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//


#import "AKSMethods.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+PE.h"
#import "Reachability.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "SBJsonWriter.h"
#import "NSDate+Helper.h"
#import "NSDate+Utilities.h"

static AKSMethods *AKSMethods_ = nil;

@implementation AKSMethods


+ (AKSMethods *)sharedAKSMethods {
	TCSTART

	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
	    if (AKSMethods_ == nil) {
	        AKSMethods_ = [[AKSMethods alloc]init];
		}
	});
	return AKSMethods_;

	TCEND
}

+ (id)alloc {
	NSAssert(AKSMethods_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (CGPoint)centerForRect:(CGRect)rect {
	return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

+ (void)printErrorMessage:(NSError *)error showit:(BOOL)show {
	TCSTART

	if (error) {
		NSLog(@"[error localizedDescription]        : %@", [error localizedDescription]);
		NSLog(@"[error localizedFailureReason]      : %@", [error localizedFailureReason]);
		NSLog(@"[error localizedRecoverySuggestion] : %@", [error localizedRecoverySuggestion]);

		if (show) [AKSMethods showMessage:[error localizedDescription]];
	}

	TCEND
}

+ (void)printFreeMemory {
	TCSTART

	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;

	host_port = mach_host_self();
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	host_page_size(host_port, &pagesize);

	vm_statistics_data_t vm_stat;

	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics"); ;

	/* Stats in bytes */
	natural_t mem_used = (vm_stat.active_count +
	                      vm_stat.inactive_count +
	                      vm_stat.wire_count) * pagesize;
	natural_t mem_free = vm_stat.free_count * pagesize;
	natural_t mem_total = mem_used + mem_free;
	NSLog(@"used: %u free: %u total: %u", mem_used / 100000, mem_free / 100000, mem_total / 100000);

	TCEND
}

+ (NSString *)getClassNameForObject:(id)object {
	return [NSString stringWithFormat:@"%s", class_getName([object class])];
}

+ (void)showMessage:(NSString *)msg {
	if (!(msg && msg.length > 0)) return;
	[self performSelectorOnMainThread:@selector(messageFromMainThread:) withObject:msg waitUntilDone:NO];
}

+ (void)showDebuggingMessage:(NSString *)msg {
	if (!(msg && msg.length > 0)) return;
	[self performSelectorOnMainThread:@selector(messageFromMainThread:) withObject:msg waitUntilDone:NO];
}

+ (void)messageFromMainThread:(NSString *)msg {
	TCSTART

	UIAlertView *alert = [[UIAlertView alloc]
	                      initWithTitle:@"Information"
						  message:msg
						  delegate:nil
						  cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];

	TCEND
}

+ (void)removeAllKeysHavingNullValue:(NSMutableDictionary *)dictionary {
	TCSTART

	NSSet *nullSet = [dictionary keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest: ^BOOL (id key, id obj, BOOL *stop) {
	    return [obj isEqual:[NSNull null]] ? YES : NO;
	}];

	[dictionary removeObjectsForKeys:[nullSet allObjects]];

	TCEND
}

+ (NSMutableString *)documentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

+ (NSString *)limitThis:(NSString *)string ForLengthUpto:(int)maxLength {
	if (string && string.length > maxLength) return [NSString stringWithFormat:@"%@...", [string substringToIndex:maxLength - 4]];
	return string;
}

+ (UIImage *)compressThisImage:(UIImage *)image {
	return (image.size.width > 640) ? ([AKSMethods imageWithImage:image scaledToWidth:640]) : image;
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width {
	float oldWidth = sourceImage.size.width;
	float scaleFactor = i_width / oldWidth;
	float newHeight = sourceImage.size.height * scaleFactor;
	float newWidth = oldWidth * scaleFactor;
	UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
	[sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (void)highlightAllLabelsOfThisView:(UIView *)view {
	NSArray *subviews = [view subviews];
	for (int i = 0; i < subviews.count; i++) {
		if ([[subviews objectAtIndex:i] isKindOfClass:[UILabel class]]) [((UILabel *)[subviews objectAtIndex:i])setBackgroundColor :[UIColor lightGrayColor]];
	}
}

+ (void)showThisAlertViewByWorkAroundForParallelButtons:(UIAlertView *)alertView {
	[alertView addButtonWithTitle:@"Fake"];

	for (int i = 0; i < alertView.subviews.count; i++) {
		if ([[AKSMethods getClassNameForObject:[alertView.subviews objectAtIndex:i]] isEqualToString:@"UIAlertButton"]) {
			if ([((UIButton *)[alertView.subviews objectAtIndex:i]).titleLabel.text isEqualToString : @"Fake"]) {
				[((UIButton *)[alertView.subviews objectAtIndex:i])setHidden : TRUE];
			}
		}
	}

	[alertView show];
}

+ (void)syncroniseNSUserDefaults {
	[[NSUserDefaults standardUserDefaults]synchronize];
}

+ (UIView *)getCapturedImageAsView {
	UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];

	UIImageView *imageView  = [[UIImageView alloc]initWithImage:[AKSMethods getScreenCapture]];
	[imageView setFrame:[[UIScreen mainScreen]bounds]];
	[mainView addSubview:imageView];

	UIView *blackTranslucentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
	[blackTranslucentView setBackgroundColor:[UIColor blackColor]];
	[blackTranslucentView setOpaque:NO];
	[blackTranslucentView.layer setOpacity:0.5];
	[mainView addSubview:blackTranslucentView];

	return mainView;
}

+ (UIImage *)getScreenCapture {
	UIImage *image = nil;
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIGraphicsBeginImageContextWithOptions([keyWindow bounds].size, NO, 0.0);
	[keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification *)notification {
	NSTimeInterval duration = 0;
	[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
	return duration;
}

+ (float)keyboardHeightForNotification:(NSNotification *)notification {
	CGSize keyboardSize = [[[notification userInfo]
	                        objectForKey:UIKeyboardFrameBeginUserInfoKey]
	                       CGRectValue].size;
	return keyboardSize.width;
}

+ (void)addParameterFrom:(NSMutableDictionary *)source WithKey:(NSString *)sourceKey To:(NSMutableDictionary *)destination UnderKey:(NSString *)key OnMethodName:(NSString *)method {
	if ([self isNotNull:[source objectForKey:sourceKey]]) [destination setObject:[source objectForKey:sourceKey] forKey:key];
	else [AKSMethods reportMissingParameterWithName:sourceKey WhileRequestingWithMethodName:method];
}

+ (void)reportMissingParameterWithName:(NSString *)missingParameter WhileRequestingWithMethodName:(NSString *)method {
	NSString *report = [NSString stringWithFormat:@"\n\n\n PARAMETER MISSING\n\nPARAMETER NAME IS : %@ \n\nIN METHOD : %@ \n\n LATIKA , GAURAV AND ALOK...WHO EVER IS WATCHING THIS PLEASE CORRECT IT ASAP\n\n", missingParameter, method];
	NSLog(@"%@", report);
}

+ (void)reloadWithAnimationTableView:(UITableView *)tableView {
	[tableView setContentOffset:tableView.contentOffset animated:NO];
	[UIView transitionWithView:tableView duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations: ^(void) { [tableView reloadData]; } completion:NULL];
}

+ (void)scrollTableViewToLast:(UITableView *)tableView animated:(BOOL)animated withDelay:(float)delay {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
	    [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height - tableView.bounds.size.height) animated:animated];
	});
}

+ (void)blockScreenAndPerformBlockAfterDelay:(float)delay didFinished:(operationAKSFinishedBlock)block {
	[CommonFunctions showActivityIndicatorWithText:@""];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
	    [CommonFunctions removeActivityIndicator];
	    block();
	});
}

+ (NSString *)getContentAsString:(NSMutableDictionary *)dictionary {
	return [[[SBJsonWriter alloc]init] stringWithObject:dictionary];
}

+ (BOOL)isApplicationUpdated {
#define APPLICATION_BUILD_VERSION_IDENTIFIER_KEY @"APPLICATION_BUILD_VERSION"
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *savedBuildVersion = [standardUserDefaults objectForKey:APPLICATION_BUILD_VERSION_IDENTIFIER_KEY];
	NSString *currentBuildVersion = CURRENT_DEVICE_VERSION_STRING;
	if (savedBuildVersion) {
		if ([savedBuildVersion isEqualToString:currentBuildVersion]) {
			return NO;
		}
		else {
			[standardUserDefaults setObject:currentBuildVersion forKey:APPLICATION_BUILD_VERSION_IDENTIFIER_KEY];
		}
	}
	else {
		[standardUserDefaults setObject:CURRENT_DEVICE_VERSION_STRING forKey:APPLICATION_BUILD_VERSION_IDENTIFIER_KEY];
	}
	return YES;
}

+ (BOOL)isNeedToClearCache {
#define LAST_CACHE_CLEARED @"LAST_CACHE_CLEARED"
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSDate *lastDate = [standardUserDefaults objectForKey:LAST_CACHE_CLEARED];
	NSDate *currentDate = [NSDate date];
	if (lastDate) {
		if ([lastDate compare:[NSDate dateWithHoursBeforeNow:12]] == NSOrderedDescending) {
			return NO;
		}
		else {
			[standardUserDefaults setObject:currentDate forKey:LAST_CACHE_CLEARED];
		}
	}
	else {
		[standardUserDefaults setObject:currentDate forKey:LAST_CACHE_CLEARED];
	}
	return YES;
}

+ (BOOL)isUpdateNeededWithGapOf:(int)minutes {
#define GAP_KONSTANT @"UPDATION_AFTER_%d"

	NSString *key = [NSString stringWithFormat:GAP_KONSTANT, minutes];
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSDate *lastDate = [standardUserDefaults objectForKey:key];
	NSDate *currentDate = [NSDate date];

	if (lastDate) {
		if ([lastDate compare:[NSDate dateWithMinutesBeforeNow:minutes]] == NSOrderedDescending) {
			return NO;
		}
		else {
			[standardUserDefaults setObject:currentDate forKey:key];
		}
	}
	else {
		[standardUserDefaults setObject:currentDate forKey:key];
	}
	return YES;
}

+ (NSString *)replaceString:(NSString *)mainString startingFrom:(NSString *)startingFrom toString:(NSString *)toString WithString:(NSString *)stringToReplace {
	NSRange rangeS = [mainString rangeOfString:startingFrom];
	NSRange rangeE = [mainString rangeOfString:toString];
	NSRange actualRangeToReplace;
	actualRangeToReplace.location = rangeS.location;
	actualRangeToReplace.length = rangeE.location - rangeS.location;
	return [mainString stringByReplacingCharactersInRange:actualRangeToReplace withString:stringToReplace];
}

+ (void)setEnabled:(BOOL)isEnabled contentsUserInteractionForView:(UIView *)view {
#define TAG_FOR_VIEW_ADDED_FOR_PREVENTING_USER_INTERACTION 121110
	[[view viewWithTag:TAG_FOR_VIEW_ADDED_FOR_PREVENTING_USER_INTERACTION]removeFromSuperview];
	if (isEnabled == NO) {
		CGRect mainScreenRect = [[UIScreen mainScreen]bounds];
		UIView *temporaryView = [[UIView alloc]init];
		[temporaryView setTag:TAG_FOR_VIEW_ADDED_FOR_PREVENTING_USER_INTERACTION];
		[temporaryView setFrame:CGRectMake(mainScreenRect.origin.y, NAVIGATION_BAR_HEIGHT, mainScreenRect.size.width, mainScreenRect.size.height - NAVIGATION_BAR_HEIGHT)];
		[view addSubview:temporaryView];
		[view bringSubviewToFront:temporaryView];
	}
}

+ (void)addSingleTapGestureRecogniserTo:(UIView *)view forSelector:(SEL)action ofObject:(id)object {
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:object action:action];
	singleTap.numberOfTapsRequired = 1;
	[view addGestureRecognizer:singleTap];
	[view setUserInteractionEnabled:TRUE];
}

+ (UIViewController *)popToViewControllerOfKind:(Class)aClass from:(UINavigationController *)navController {
	TCSTART

	NSArray *arrayOfViewControllersInStack = navController.viewControllers;
	for (int i = 0; i < arrayOfViewControllersInStack.count; i++) {
		if ([[arrayOfViewControllersInStack objectAtIndex:i] isKindOfClass:aClass]) {
			int index = (i > 0) ? (i - 1) : i;
			[navController popToViewController:[arrayOfViewControllersInStack objectAtIndex:index] animated:FALSE];
			break;
		}
	}

	TCEND

	return [navController topViewController];
}

+ (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
	const char *data = [deviceToken bytes];
	NSMutableString *token = [NSMutableString string];
	for (int i = 0; i < [deviceToken length]; i++) {
		[token appendFormat:@"%02.2hhX", data[i]];
	}
	return token;
}

@end
