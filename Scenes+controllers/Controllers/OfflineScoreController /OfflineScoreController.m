//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "OfflineScoreController.h"
#import "MessageController.h"


static OfflineScoreController *offlineScoreController_ = nil;

/**

 OfflineScoreController:-

 OfflineScoreController class will handle user scores offline.

 */

@implementation OfflineScoreController


#pragma mark - Methods for allocate and initialise the object of this class

+ (OfflineScoreController *)sharedOfflineScoreController {
    TCSTART

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (offlineScoreController_ == nil) {
            offlineScoreController_ = [[OfflineScoreController alloc]init];
        }
    });
    return offlineScoreController_;

    TCEND
}

+ (id)alloc {
    NSAssert(offlineScoreController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

+ (void)reportScore:(int)score {
    if (score > 0) {
        NSMutableArray *scoreArray = [OfflineScoreController getScoreArray];
        [scoreArray addObject:[NSNumber numberWithInt:score]];
        [OfflineScoreController setScoreArray:scoreArray];
    }
}

+ (int)highestScore {
    NSMutableArray *scoreArray = [OfflineScoreController getScoreArray];
    int highestScore = 0;
    for (int i = 0; i < scoreArray.count; i++) {
        if ([[scoreArray objectAtIndex:i]integerValue] > highestScore) highestScore = [[scoreArray objectAtIndex:i]integerValue];
    }
    return highestScore;
}

+ (float)averageScore {
    NSMutableArray *scoreArray = [OfflineScoreController getScoreArray];
    float average = 0;
    for (int i = 0; i < scoreArray.count; i++) {
        average += [[scoreArray objectAtIndex:i]integerValue];
    }
    if ([scoreArray count] > 0) average = average / [scoreArray count];
    return average;
}

+ (int)mostRecentScore {
    NSMutableArray *scoreArray = [OfflineScoreController getScoreArray];
    if ([scoreArray count] > 0) return [[scoreArray objectAtIndex:[scoreArray count]-1]integerValue];
    return 0;
}

#pragma mark - Methods for resert score

#define SCORE_ARRAY_KEY_NAME @"savedArray"

+ (NSMutableArray *)getScoreArray {
    NSData *savedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedArray"];
    if (savedArray != nil) return [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:savedArray]];
    else return [[NSMutableArray alloc]init];
}

+ (void)setScoreArray:(NSMutableArray *)scoreArray {
    if (scoreArray) [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:scoreArray] forKey:@"savedArray"];
}

@end
