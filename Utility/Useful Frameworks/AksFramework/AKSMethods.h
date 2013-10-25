//
//  Project
//
//  Created by Alok on 4/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^operationAKSFinishedBlock)();

@interface AKSMethods : NSObject
+ (AKSMethods *)sharedAKSMethods;
+ (CGPoint)centerForRect:(CGRect)rect;
+ (void)printErrorMessage:(NSError *)error showit:(BOOL)show;
+ (void)showMessage:(NSString *)msg;
+ (void)showDebuggingMessage:(NSString *)msg;
+ (void)removeAllKeysHavingNullValue:(NSMutableDictionary *)dictionary;
+ (NSMutableString *)documentsDirectory;
+ (UIImage *)compressThisImage:(UIImage *)image;
+ (NSString *)limitThis:(NSString *)string ForLengthUpto:(int)maxLength;
+ (void)printFreeMemory;
+ (NSString *)getClassNameForObject:(id)object;
+ (void)highlightAllLabelsOfThisView:(UIView *)view;
+ (void)showThisAlertViewByWorkAroundForParallelButtons:(UIAlertView *)alertView;
+ (void)syncroniseNSUserDefaults;
+ (UIImage *)getScreenCapture;
+ (UIView *)getCapturedImageAsView;
+ (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification *)notification;
+ (float)keyboardHeightForNotification:(NSNotification *)notification;
+ (void)addParameterFrom:(NSMutableDictionary *)source WithKey:(NSString *)sourceKey To:(NSMutableDictionary *)destination UnderKey:(NSString *)key OnMethodName:(NSString *)method;
+ (void)reloadWithAnimationTableView:(UITableView *)tableView;
+ (BOOL)isApplicationUpdated;
+ (BOOL)isNeedToClearCache;
+ (BOOL)isUpdateNeededWithGapOf:(int)minutes;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;
+ (void)scrollTableViewToLast:(UITableView *)tableView animated:(BOOL)animated withDelay:(float)delay;
+ (void)blockScreenAndPerformBlockAfterDelay:(float)delay didFinished:(operationAKSFinishedBlock)block;
+ (NSString *)replaceString:(NSString *)mainString startingFrom:(NSString *)startingFrom toString:(NSString *)toString WithString:(NSString *)stringToReplace;
+ (void)setEnabled:(BOOL)isEnabled contentsUserInteractionForView:(UIView *)view;
+ (void)addSingleTapGestureRecogniserTo:(UIView *)view forSelector:(SEL)action ofObject:(id)object;
+ (UIViewController *)popToViewControllerOfKind:(Class)aClass from:(UINavigationController *)navController;
+ (NSString *)stringWithDeviceToken:(NSData *)deviceToken;
@end


@interface NSString (Helpers)
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set;
@end

@implementation NSString (Helpers)
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set {
	NSArray *components = [self componentsSeparatedByCharactersInSet:set];
	return [components componentsJoinedByString:@""];
}
@end


@implementation NSArray (Reverse)
- (NSArray *)reversedArray {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	for (id element in enumerator) {
		[array addObject:element];
	}
	return array;
}
@end

@implementation NSMutableArray (Reverse)
- (void)reverse {
	@try {
		if ([self count] == 0) return;
		NSUInteger i = 0;
		NSUInteger j = [self count] - 1;
		while (i < j) {
			[self exchangeObjectAtIndex:i
			          withObjectAtIndex:j];

			i++;
			j--;
		}
	}
	@catch (NSException *exception){}@finally{}
}
@end


@interface UIImage (scale)
- (UIImage *)scaleToSize:(CGSize)size;
@end
@implementation UIImage (scale)
- (UIImage *)scaleToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}
@end
