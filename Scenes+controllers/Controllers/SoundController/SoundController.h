//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 SoundController:-

 SoundController class will handle game music and sounds.

 */


#define PERFORM_BUTTON_CLICK_SOUND_EFFECT [[SoundController sharedSoundController] playSound:ENUM_SOUND_EFFECT_______WHEN_CHOOSING_OPTIONS];



enum enumSounds {
    ENUM_BACKGROUND_MUSIC_______LEVEL_BACKGROUND_MUSIC,
    ENUM_BACKGROUND_MUSIC_______OTHER_SCREENS_BACKGROUND_MUSIC,
    ENUM_SOUND_EFFECT_______WHEN_CHOOSING_OPTIONS
};

@interface SoundController : NSObject
{
}

/**
 singleton object for this class
 */
+ (SoundController *)sharedSoundController;
- (void)playSound:(enum enumSounds)Sound;
- (void)pauseSound;
- (void)resumeSound;
- (void)muteSound;
- (void)unMuteSound;
- (BOOL)gameSoundsStatus;
- (void)stopAll;
@end
