//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "CommonFunctions.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@implementation CommonFunctions


+ (NSString *)documentsDirectory {
	NSArray *paths =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										NSUserDomainMask,
										YES);
	return [paths objectAtIndex:0];
}

+ (void)openEmail:(NSString *)address {
	NSString *url = [NSString stringWithFormat:@"mailto://%@", address];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openPhone:(NSString *)number {
	NSString *url = [NSString stringWithFormat:@"tel://%@", number];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openSms:(NSString *)number {
	NSString *url = [NSString stringWithFormat:@"sms://%@", number];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openBrowser:(NSString *)url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openMap:(NSString *)address {
	NSString *addressText = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (BOOL)isRetinaDisplay {
	if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
	    ([UIScreen mainScreen].scale == 2.0)) {
		return YES;
	}
	else {
		return NO;
	}
}

+ (int)getDeviceType {
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

	static int deviceType = 0;
	if (deviceType == 0) {
		if (IS_IPAD) deviceType = IPAD;
		else if (IS_IPHONE && IS_IPHONE_5) deviceType = IPHONE4INCH;
		else if (IS_IPHONE) deviceType = IPHONE3P5INCH;
	}
	return deviceType;
}

+ (NSString *)getImageNameForName:(NSString *)name {
	return [NSString stringWithFormat:IS_IPAD ? @"%@_iPad":@"%@", name];
}

+ (NSString *)getNibNameForName:(NSString *)name {
	if (IsiPhone4Inch) {
		NSString *possibleNibName = [NSString stringWithFormat:@"%@_iPhone4Inch", name];
		if ([[NSBundle mainBundle] pathForResource:possibleNibName ofType:@"nib"] != nil) {
			return possibleNibName;
		}
	}

	return [NSString stringWithFormat:IS_IPAD ? @"%@_iPad":@"%@", name];
}

+ (void)setNavigationTitle:(NSString *)title ForNavigationItem:(UINavigationItem *)navigationItem {
	float width = 320.0f;

	if (navigationItem.leftBarButtonItem.customView && navigationItem.rightBarButtonItem.customView) {
		width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width + navigationItem.rightBarButtonItem.customView.frame.size.width + 20);
	}
	else if (navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView) {
		width = 320 - (navigationItem.leftBarButtonItem.customView.frame.size.width * 2);
	}
	else if (!navigationItem.leftBarButtonItem.customView && !navigationItem.rightBarButtonItem.customView) {
		width = 320 - (2 * navigationItem.rightBarButtonItem.customView.frame.size.width);
	}

	// find the text width; so that btn width can be calculate
	CGSize textSize = [title   sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:23.0]
	                      constrainedToSize:CGSizeMake(320.0f, 32.0f)
	                          lineBreakMode:NSLineBreakByWordWrapping];

	if (textSize.width < width)
		width = textSize.width;

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 44.0f)];

	UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 6.0f, width, 32.0f)];

	[titleLbl setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:23.0]];
	[titleLbl setTextColor:[UIColor colorWithRed:(113 / 255.0) green:(113 / 255.0) blue:(113 / 255.0) alpha:1]];

	[titleLbl setBackgroundColor:[UIColor clearColor]];
	[titleLbl setTextAlignment:NSTextAlignmentCenter];

	[titleLbl setTextColor:[UIColor darkGrayColor]];
	[titleLbl setShadowColor:[UIColor whiteColor]];
	[titleLbl setShadowOffset:CGSizeMake(0.0f, 1.0f)];

	[titleLbl setText:title];

	[view addSubview:titleLbl];

	[navigationItem setTitleView:view];
}

#pragma mark - common method for setting navigation bar background image

+ (void)setNavigationBarBackgroundImage:(NSString *)imageName fromViewController:(UIViewController *)viewController {
	if ([self isNotNull:imageName] && [viewController.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
		[viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[CommonFunctions getImageNameForName:imageName]]
		                                                        forBarMetrics:UIBarMetricsDefault];
	}
}

#pragma mark - common method for setting navigation bar  title image view

+ (void)setNavigationBarTitleImage:(NSString *)imageName WithViewController:(UIViewController *)caller {
	UIImage *imageToUse =   [UIImage imageNamed:[CommonFunctions getImageNameForName:imageName]];
	UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageToUse.size.width, imageToUse.size.height)];
	[titleView setImage:imageToUse];
	[caller.navigationItem setTitleView:titleView];
}

#pragma mark - Common method to add navigation bar buttons

/**
 common method to add navigation bar buttons
 */
+ (void)addLeftNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithNegativeSpacerValue:(int)value {
	UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[leftBarButton setImage:[UIImage imageNamed:[CommonFunctions getImageNameForName:imageName]] forState:UIControlStateNormal];
	[leftBarButton setImage:[UIImage imageNamed:[CommonFunctions getImageNameForName:[NSString stringWithFormat:@"%@_hover", imageName]]] forState:UIControlStateHighlighted];
	[leftBarButton setFrame:CGRectMake(0.0f, 0.0f, leftBarButton.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];

	if ([caller respondsToSelector:@selector(onClickOfLeftNavigationBarButton:)]) [leftBarButton addTarget:caller action:@selector(onClickOfLeftNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
	else {
		NSLog(@"\n\n%@ class forgets to implement onClickOfLeftNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
	}

	UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
	                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
									   target:nil action:nil];
	negativeSpacer.width = value;
	caller.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftBarButton], nil];
}

+ (void)addRightNavigationBarButton:(UIViewController *)caller withImageName:(NSString *)imageName WithNegativeSpacerValue:(int)value {
	UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightBarButton setImage:[UIImage imageNamed:[CommonFunctions getImageNameForName:imageName]] forState:UIControlStateNormal];
	[rightBarButton setImage:[UIImage imageNamed:[CommonFunctions getImageNameForName:[NSString stringWithFormat:@"%@_hover", imageName]]] forState:UIControlStateHighlighted];
	[rightBarButton setFrame:CGRectMake(0.0f, 0.0f, rightBarButton.imageView.image.size.width, NAVIGATION_BAR_HEIGHT)];

	if ([caller respondsToSelector:@selector(onClickOfRightNavigationBarButton:)]) [rightBarButton addTarget:caller action:@selector(onClickOfRightNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
	else {
		NSLog(@"\n\n%@ class forgets to implement onClickOfRightNavigationBarButton method\n", [AKSMethods getClassNameForObject:caller]);
	}

	UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
	                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
									   target:nil action:nil];
	negativeSpacer.width = value;
	caller.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightBarButton], nil];
}

+ (void)clearApplicationCaches {
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[AKSMethods syncroniseNSUserDefaults];
}

#pragma mark - common method to show toast messages

+ (void)showNotificationInViewController:(UIViewController *)viewController
                               withTitle:(NSString *)title
                             withMessage:(NSString *)message
                                withType:(TSMessageNotificationType)type
                            withDuration:(NSTimeInterval)duration {
	[TSMessage showNotificationInViewController:viewController title:title subtitle:message image:nil type:type duration:duration callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionTop canBeDismisedByUser:NO];
}

#pragma mark - common method to show toast messages

+ (void)showToastMessageWithMessage:(NSString *)message {
	[APPDELEGATE.window.rootViewController.view makeToast:message
				duration:3.0
				position:@"top"
				   title:Nil];
}

#pragma mark - common method for showing MBProgressHUD Activity Indicator

/*!
 @function	showActivityIndicatorWithText
 @abstract	shows the MBProgressHUD with custom text for information to user.
 @discussion
 MBProgressHUD will be added to window . hence complete ui will be blocked from any user interaction.
 @param	text
 the text which will be shown while showing progress
 */

+ (void)showActivityIndicatorWithText:(NSString *)text {
	[self removeActivityIndicator];

	MBProgressHUD *hud   = [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
	hud.labelText        = text;
	hud.detailsLabelText = NSLocalizedString(@"Please Wait...", @"");
}

/*!
 @function	removeActivityIndicator
 @abstract	removes the MBProgressHUD (if any) from window.
 */

+ (void)removeActivityIndicator {
	[MBProgressHUD hideHUDForView:APPDELEGATE.window animated:YES];
}

#pragma mark - common method for Internet reachability checking

/*!
 @function	getStatusForNetworkConnectionAndShowUnavailabilityMessage
 @abstract	get internet reachability status and optionally can show network unavailability message.
 @param	showMessage
 to decide whether to show network unreachability message.
 */

+ (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage {
	if (([[Reachability reachabilityWithHostname:[[NSURL URLWithString:BASE_URL]host]] currentReachabilityStatus] == NotReachable)) {
		if (showMessage == NO) return NO;

		UIViewController *viewController = nil;

		if ([APPDELEGATE.window.rootViewController isKindOfClass:[UINavigationController class]]) viewController = ((UINavigationController *)(APPDELEGATE.window.rootViewController)).topViewController;
		else if ([APPDELEGATE.window.rootViewController isKindOfClass:[UIViewController class]]) viewController = APPDELEGATE.window.rootViewController;
		else viewController = APPDELEGATE.window.rootViewController;

		[self showNotificationInViewController:viewController withTitle:nil withMessage:@"Application requires an active internet connection.\nPlease check your network settings and try again." withType:TSMessageNotificationTypeError withDuration:MIN_DUR];
		return NO;
	}
	return YES;
}

+ (BOOL)isSuccess:(NSMutableDictionary *)response {
	if ([response isKindOfClass:[NSDictionary class]]) {
		if ([[[response objectForKey:@"replyCode"] uppercaseString]isEqualToString:@"SUCCESS"]) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL)validateEmailWithString:(NSString *)email WithIdentifier:(NSString *)identifier {
	if ((email == nil) || (email.length == 0)) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter %@", identifier]];
		return FALSE;
	}
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if (![emailTest evaluateWithObject:email]) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter valid %@", identifier]];
		return FALSE;
	}
	else return TRUE;
}

+ (BOOL)validateNameWithString:(NSString *)name WithIdentifier:(NSString *)identifier {
	if ((name == nil) || (name.length == 0)) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter %@", identifier]];
		return FALSE;
	}
	NSString *nameRegex = @"[a-zA-Z0-9_. ]+$";
	NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
	if (![nameTest evaluateWithObject:name]) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter valid %@", identifier]];
		return FALSE;
	}
	else return TRUE;
}

+ (BOOL)validatePhoneNumberWithString:(NSString *)number WithIdentifier:(NSString *)identifier {
	TCSTART

	if ((number == nil) || (number.length == 0)) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter %@", identifier]];
		return FALSE;
	}

	if (number.length != 10) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter valid %@", identifier]];
		return FALSE;
	}

	NSString *numberRegex = @"[0-9]+$";
	NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];

	if (![numberTest evaluateWithObject:number]) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter valid %@", identifier]];
		return FALSE;
	}
	else return TRUE;

	TCEND
}

+ (BOOL)validatePinCodeWithString:(NSString *)number WithIdentifier:(NSString *)identifier {
	TCSTART

	if ((number == nil) || (number.length == 0)) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter %@", identifier]];
		return FALSE;
	}

	if (number.length != 6) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter 6 digit %@", identifier]];
		return FALSE;
	}

	NSString *numberRegex = @"[0-9]+$";
	NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];

	if (![numberTest evaluateWithObject:number]) {
		[CommonFunctions showToastMessageWithMessage:[NSMutableString stringWithFormat:@"please enter valid %@", identifier]];
		return FALSE;
	}
	else
		return TRUE;

	TCEND
}

@end
