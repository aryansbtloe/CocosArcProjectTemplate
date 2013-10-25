//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 OfflineScoreController:-

 OfflineScoreController class will handle user scores offline.

 */

@interface OfflineScoreController : NSObject

/**
 singleton object for this class
 */
+ (OfflineScoreController *)sharedOfflineScoreController;

/**
 method to reset scores
 */
+ (void)resetScores;

/**
 method to report scores in game center
 */
+ (void)reportScore:(int)score;

/**
 method to get highest score
 */
+ (int)highestScore;

/**
 method to get average score
 */

+ (float)averageScore;

/**
 method to get most recent score
 */

+ (int)mostRecentScore;

@end
