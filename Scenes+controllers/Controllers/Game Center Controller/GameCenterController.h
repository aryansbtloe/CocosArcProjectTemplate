//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>

/**

 GameCenterController:-

 GameCenterController class will game center.

 */

@interface GameCenterController : NSObject <GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate>
{
    GameCenterManager *gameCenterManager;
    GKLeaderboardViewController *leaderboardController;
}

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) GKLeaderboardViewController *leaderboardController;


+ (GameCenterController *)sharedGameCenterController;

- (BOOL)showScoreBoard;

- (void)submitScore:(int64_t)score;

- (void)openGameCenterLoginPage;

@end
