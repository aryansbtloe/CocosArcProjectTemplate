//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "MessageController.h"
#import "cocos2d.h"
#import "RemoveNode.h"


/**

 MessageController:-

 MessageController class will handle user messages.

 */

static CCLabelTTF *labelToShowMessage = nil;
static CCLabelTTF *messageLabel =nil;

@implementation MessageController

#define MessageFontSize 48

+ (void)showMessage:(NSString *)message {
    [MessageController clearMessage];

    CCDirectorIOS *cocosDirector = (CCDirectorIOS *)[CCDirector sharedDirector];

    CCScene *scene = [cocosDirector runningScene];

    CGRect screenRect = [[UIScreen mainScreen]bounds];

    labelToShowMessage = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(screenRect.size.width, 120) hAlignment:kCCTextAlignmentCenter fontName:FONT_TYPE_2 fontSize:MessageFontSize];
    [labelToShowMessage setScale:0.6];
    labelToShowMessage.position = ccp(scene.contentSize.width / 2, scene.contentSize.height / 2);

    [scene addChild:labelToShowMessage z:10000 tag:1111];
    [labelToShowMessage runAction:[CCSequence actions:
                                   [CCScaleTo actionWithDuration:1 scale:1.0],
                                   [RemoveNode action],
                                   nil]];
}

+ (void)showMessageInAsSpeech:(NSString *)message WithRespectToSprite:(CCSprite *)speaker forDuration:(float)duration {
    [MessageController removeBubbleMessage];

    CGSize winSize = [[CCDirector sharedDirector]winSize];

    CGPoint center = CGPointMake(winSize.width / 2, winSize.height / 2);

    BOOL isBL = FALSE;
    BOOL isBR = FALSE;
    BOOL isTL = FALSE;
    BOOL isTR = FALSE;

    if (speaker.position.x < center.x && speaker.position.y < center.y) isBL = TRUE;
    else if (speaker.position.x < center.x && speaker.position.y > center.y) isTL = TRUE;
    else if (speaker.position.x > center.x && speaker.position.y > center.y) isTR = TRUE;
    else isBR = TRUE;

    messageLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"\n\n%@", message] fontName:FONT_TYPE_2 fontSize:16];
	
    [[speaker parent] addChild:messageLabel z:99];

#define VARIANCE 40
	
    if (isBL) { //done
		[messageLabel setPosition:CGPointMake([speaker position].x+VARIANCE,[speaker position].y+VARIANCE)];
    } else if (isBR) { //done
		[messageLabel setPosition:CGPointMake([speaker position].x,[speaker position].y+VARIANCE)];
    } else if (isTL) { //done
		[messageLabel setPosition:CGPointMake([speaker position].x+VARIANCE,[speaker position].y)];
    } else { //done
		[messageLabel setPosition:CGPointMake([speaker position].x,[speaker position].y)];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [MessageController removeBubbleMessage];
    });
}

+ (void)removeBubbleMessage {
    [messageLabel removeFromParentAndCleanup:YES];
    messageLabel = nil;
}

#define MESSAGE_STARTING_TIME 4
#define MESSAGE_TIME_GAP      5

+ (void)showGameCompletionSpecificMessage:(NSString *)message {
    [MessageController clearMessage];

    CCDirectorIOS *cocosDirector = (CCDirectorIOS *)[CCDirector sharedDirector];

    CCScene *scene = [cocosDirector runningScene];

    CGRect screenRect = [[UIScreen mainScreen]bounds];

    labelToShowMessage = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(screenRect.size.width, 120) hAlignment:kCCTextAlignmentCenter fontName:FONT_TYPE_2 fontSize:28];
    labelToShowMessage.position = ccp(scene.contentSize.width / 2, scene.contentSize.height / 2);

    [labelToShowMessage runAction:[CCScaleTo actionWithDuration:MESSAGE_TIME_GAP / 3 scale:1.1]];
    [labelToShowMessage runAction:[CCSequence actions:
                                   [CCFadeIn actionWithDuration:MESSAGE_TIME_GAP / 3],
                                   [CCFadeOut actionWithDuration:(2 * MESSAGE_TIME_GAP) / 3],
                                   nil]];

    [scene addChild:labelToShowMessage z:10000 tag:1111];
}

+ (void)clearMessage {
    [labelToShowMessage removeFromParentAndCleanup:YES];
}

@end
