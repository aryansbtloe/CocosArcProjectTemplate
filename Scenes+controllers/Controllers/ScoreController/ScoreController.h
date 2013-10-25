//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 ScoreController:-

 ScoreController class will handle user scores.

 */

@interface ScoreController : NSObject
{
    /**
     int variable to hold the current score.
     */
    int currentScore;

    /**
     int variable to hold the no of turtles saved.
     */
    int noOfTurtlesSaved;
}
/**
 int variable to hold the current score.
 */
@property (nonatomic, readwrite) int currentScore;

/**
 int variable to hold the no of turtles saved.
 */
@property (nonatomic, readwrite) int noOfTurtlesSaved;

/**
 singleton object for this class
 */
+ (ScoreController *)sharedScoreController;

/**
 method to add point to score with user info message
 */
+ (void)addPointsToScoreWithUserMessage:(int)points;

/**
 method to add point to score
 */
+ (void)addPointsToScore:(int)points;

/**
 method to increment no of turtles saved by one
 */
+ (void)incrementNoOfTurtlesSaved;

/**
 method to reset scores
 */
+ (void)resetScores;

/**
 method to report scores in game center
 */
+ (void)reportScore;

/**
 method to report scores and then reset the score
 */
+ (void)reportAndResetScores;



@end
