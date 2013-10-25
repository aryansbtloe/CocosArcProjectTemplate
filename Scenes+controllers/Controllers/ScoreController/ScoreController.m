//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ScoreController.h"
#import "MessageController.h"


static ScoreController *scoreController_ = nil;

/**

 ScoreController:-

 ScoreController class will handle user scores.

 */

@implementation ScoreController

@synthesize currentScore, noOfTurtlesSaved;


#pragma mark - Methods for allocate and initialise the object of this class

+ (ScoreController *)sharedScoreController {
    TCSTART

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (scoreController_ == nil) {
            scoreController_ = [[ScoreController alloc]init];
        }
    });
    return scoreController_;

    TCEND
}

+ (id)alloc {
    NSAssert(scoreController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

#pragma mark - Methods for updating score

+ (void)addPointsToScoreWithUserMessage:(int)points {
    scoreController_.currentScore += points;

    if (scoreController_.currentScore < 0) scoreController_.currentScore = 0;

    [MessageController showPointsMessage:points];
}

+ (void)addPointsToScore:(int)points {
    scoreController_.currentScore += points;

    if (scoreController_.currentScore < 0) scoreController_.currentScore = 0;
}

+ (void)incrementNoOfTurtlesSaved {
    scoreController_.noOfTurtlesSaved++;
}

+ (void)reportScore {
    [[GameCenterController sharedGameCenterController] submitScore:scoreController_.currentScore];
    [OfflineScoreController reportScore:scoreController_.currentScore];
}

#pragma mark - Methods for report score to game centre manager

+ (void)reportAndResetScores {
    [ScoreController reportScore];

    scoreController_.currentScore        = 0;
    scoreController_.noOfTurtlesSaved    = 0;
}

#pragma mark - Methods for resert score

+ (void)resetScores {
    scoreController_.currentScore        = 0;
    scoreController_.noOfTurtlesSaved    = 0;
}

@end
