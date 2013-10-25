//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//


#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameControllers.h"


@implementation AppDelegate

@synthesize cocosDirector;
@synthesize navigationController;
@synthesize window;
@synthesize gamePausedIntentionally;


#pragma mark - application entry point

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initialiseCocosDirector];
    [self initialiseNavigationController];
    [self initialiseWindow];
    [self startupScene];
    [self setUpGameCenter];
    [self setUpOthers];
    return YES;
}

#pragma mark - methods to initialise contents of this application

- (void)setUpOthers {

	double delayInSeconds = 6.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];

		//seeding the random number generator
		int count = arc4random() % 100;
		for (int i = 0; i < count; i++) {
			random();
		}

		gamePausedIntentionally = NO;

	});
}

- (void)initialiseWindow {
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
}

- (void)initialiseNavigationController {
    navigationController = [[UINavigationController alloc] initWithRootViewController:cocosDirector];
    navigationController.navigationBarHidden = YES;
}

- (void)initialiseCocosDirector {
    CCGLView *glView = [CCGLView viewWithFrame:[[UIScreen mainScreen] bounds]
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];

    cocosDirector = (CCDirectorIOS *)[CCDirector sharedDirector];
    cocosDirector.wantsFullScreenLayout = YES;
    [cocosDirector setAnimationInterval:MAX_ANIMATION_FREQUENCY];
    [cocosDirector setView:glView];
    [cocosDirector setDelegate:self];
    [cocosDirector setProjection:kCCDirectorProjection2D];
    [cocosDirector enableRetinaDisplay:YES];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];

    [sharedFileUtils setEnableFallbackSuffixes:NO];
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
    [sharedFileUtils setiPadSuffix:@"-ipad"];
    [sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];

    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
}

- (void)startupScene {
    [FrameCacheController prepareGameSpriteSheets];
//    [[CCDirector sharedDirector] pushScene:[MenuScene node]];
}

- (void)setUpGameCenter {
	double delayInSeconds = 7.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[GameCenterController sharedGameCenterController];
	});
}

#pragma mark - application life cycle delegate Methods

- (void)applicationWillResignActive:(UIApplication *)application {
	if(!(gamePausedIntentionally=[cocosDirector isPaused]))
    if ([navigationController visibleViewController] == cocosDirector) [cocosDirector pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(!gamePausedIntentionally)
    if([navigationController visibleViewController] == cocosDirector) [cocosDirector resume];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([navigationController visibleViewController] == cocosDirector) [cocosDirector stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([navigationController visibleViewController] == cocosDirector) [cocosDirector startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    CC_DIRECTOR_END();
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark - Memory management methods

- (void)clearApplicationCaches {
    [[CCDirector sharedDirector] purgeCachedData];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Application just receives a memory warning\nplease try to optimise the memory usage\n As of now app will clear some of its caches");
    [self clearApplicationCaches];
}

#pragma mark - application orientaion support delegate methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

ORIENTATION_SUPPORT_PORTRAIT_ONLY

@end
