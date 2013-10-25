//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "GameCenterController.h"

static GameCenterController *gameCenterController_ = nil;

/**

 GameCenterController:-

 GameCenterController class will game center.

 */

#define LOGIN_CONFIRMATION_TAG 100

#define GAME_CENTER_CATEGORY   @"turtle_mayhem1"

@implementation GameCenterController

@synthesize gameCenterManager, leaderboardController;

#pragma mark - Methods for allocate and initialise the object of this class

+ (GameCenterController *)sharedGameCenterController {
    TCSTART

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (gameCenterController_ == nil) {
            gameCenterController_ = [[GameCenterController alloc]init];
            gameCenterController_.gameCenterManager = [[GameCenterManager alloc]init];
            [gameCenterController_.gameCenterManager setDelegate:gameCenterController_];
            [gameCenterController_.gameCenterManager authenticateLocalUser];
        }
    });
    return gameCenterController_;

    TCEND
}

+ (id)alloc {
    NSAssert(gameCenterController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

#pragma mark MethodToLeaderBoard as score board

- (BOOL)showScoreBoard {
    if ([GKLocalPlayer localPlayer].authenticated) {
        [self showLeaderboard];
        return TRUE;
    } else return FALSE;
}

- (void)showLeaderboard;
{
    TCSTART

    if (!leaderboardController) {
        leaderboardController = [[GKLeaderboardViewController alloc] init];
        leaderboardController.category = GAME_CENTER_CATEGORY;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }

    [APPDELEGATE.navigationController.topViewController presentModalViewController:leaderboardController animated:YES];

    TCEND
}










#pragma mark MethodToSubmitHighScore

- (void)submitScore:(int64_t)score {
    TCSTART

    if (score > 0) [self.gameCenterManager reportScore:score forCategory:GAME_CENTER_CATEGORY];

    TCEND
}

#pragma mark GKLeaderboardViewControllerDelegate

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    TCSTART

    [APPDELEGATE.navigationController dismissModalViewControllerAnimated : YES];

    TCEND
}

#pragma mark GKAchievementViewControllerDelegate

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    TCSTART


	TCEND
}

#pragma mark GameCenterManagerDelegate

- (void)processGameCenterAuth:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];

    TCEND
}

- (void)scoreReported:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];


    TCEND
}

- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];

    TCEND
}

- (void)achievementSubmitted:(GKAchievement *)ach error:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];

    TCEND
}

- (void)achievementResetResult:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];

    TCEND
}

- (void)mappedPlayerIDToPlayer:(GKPlayer *)player error:(NSError *)error {
    TCSTART

    [AKSMethods printErrorMessage : error showit : NO];

    TCEND
}

- (void)openGameCenterLoginPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
}

@end
