#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
#import "AppDelegate.h"


@implementation GameCenterManager

@synthesize earnedAchievementCache, delegate;

- (id)init {
    self = [super init];
    if (self != NULL) {
        earnedAchievementCache = NULL;
    }
    return self;
}

- (void)dealloc {
    self.earnedAchievementCache = NULL;
}

- (void)callDelegate:(SEL)selector withArg:(id)arg error:(NSError *)err {
    TCSTART

    assert([NSThread isMainThread]);
    if ([delegate respondsToSelector:selector]) {
        if (arg != NULL) [delegate performSelector:selector withObject:arg withObject:err];
        else [delegate performSelector:selector withObject:err];
    } else NSLog(@"****************Missed Method********************");

    TCEND
}

- (void)callDelegateOnMainThread:(SEL)selector withArg:(id)arg error:(NSError *)err {
    TCSTART


    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self callDelegate:selector withArg:arg error:err];
                   });

    TCEND
}

+ (BOOL)isGameCenterAvailable {
    TCSTART


    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);

    TCEND
}

- (void)authenticateLocalUser {
    TCSTART

    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
         {
             [self callDelegateOnMainThread:@selector(processGameCenterAuth:) withArg:NULL error:error];
         }];
    }

    TCEND
}

- (void)reloadHighScoresForCategory:(NSString *)category {
    TCSTART


    GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
    leaderBoard.category = category;
    leaderBoard.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderBoard.range = NSMakeRange(1, 1);

    [leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
     {
         [self callDelegateOnMainThread:@selector(reloadScoresComplete:error:) withArg:leaderBoard error:error];
     }];

    TCEND
}

- (void)reportScore:(int64_t)score forCategory:(NSString *)category {
    TCSTART

    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error)
     {
         [self callDelegateOnMainThread:@selector(scoreReported:) withArg:NULL error:error];
     }];

    TCEND
}

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete {
    TCSTART


    if (self.earnedAchievementCache == NULL) {
        [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
         {
             if (error == NULL) {
                 NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:[scores count]];
                 for (GKAchievement * score in scores) {
                     [tempCache setObject:score forKey:score.identifier];
                 }
                 self.earnedAchievementCache = tempCache;
                 [self submitAchievement:identifier percentComplete:percentComplete];
             } else {
                 //Something broke loading the achievement list.  Error out, and we'll try again the next time achievements submit.
                 [self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:NULL error:error];
             }
         }];
    } else {
        //Search the list for the ID we're using...
        GKAchievement *achievement = [self.earnedAchievementCache objectForKey:identifier];
        if (achievement != NULL) {
            if ((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
                //Achievement has already been earned so we're done.
                achievement = NULL;
            }
            achievement.percentComplete = percentComplete;
        } else {
            achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
            achievement.percentComplete = percentComplete;
            //Add achievement to achievement cache...
            [self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
        }
        if (achievement != NULL) {
            //Submit the Achievement...
            [achievement reportAchievementWithCompletionHandler: ^(NSError *error)
             {
                 [self callDelegateOnMainThread:@selector(achievementSubmitted:error:) withArg:achievement error:error];
             }];
        }
    }

    TCEND
}

- (void)resetAchievements {
    TCSTART


    self.earnedAchievementCache = NULL;
    [GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error)
     {
         [self callDelegateOnMainThread:@selector(achievementResetResult:) withArg:NULL error:error];
     }];

    TCEND
}

- (void)mapPlayerIDtoPlayer:(NSString *)playerID {
    TCSTART


    [GKPlayer loadPlayersForIdentifiers :[NSArray arrayWithObject:playerID] withCompletionHandler :^(NSArray *playerArray, NSError *error)
     {
         GKPlayer *player = NULL;
         for (GKPlayer *tempPlayer in playerArray) {
             if ([tempPlayer.playerID isEqualToString:playerID]) {
                 player = tempPlayer;
                 break;
             }
         }
         [self callDelegateOnMainThread:@selector(mappedPlayerIDToPlayer:error:) withArg:player error:error];
     }];


    TCEND
}

ORIENTATION_SUPPORT_PORTRAIT_ONLY

@end