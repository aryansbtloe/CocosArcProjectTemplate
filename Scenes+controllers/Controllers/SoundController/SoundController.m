//
//  Turtle
//
//  Created by Alok on 18/04/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "SoundController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#define backgroundMusicVolumeWhenWantedToPlay 0.60
#define backgroundMusicVolumeWhenWantedToStop 0.00
#define soundEffectsVolumeWhenWantedToPlay    1.00
#define soundEffectsVolumeWhenWantedToStop    0.00
#define isGameSoundsOn                        @"IS_GAME_SOUNDS_ON"

static SoundController *soundController_ = nil;

/**

 SoundController:-

 SoundController class will handle game music and sounds.

 */

@implementation SoundController

#pragma mark - Methods for allocate and initialise the object of this class

+ (SoundController *)sharedSoundController {
    TCSTART

    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (soundController_ == nil) {
            soundController_ = [[SoundController alloc]init];

            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

            if ([standardUserDefaults objectForKey:isGameSoundsOn])
			{
                if ([[standardUserDefaults objectForKey:isGameSoundsOn]boolValue] == NO)
					[soundController_ muteSound];
                else
					[soundController_ unMuteSound];
            } else {
                [standardUserDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:isGameSoundsOn];
                [soundController_ unMuteSound];
            }
        }
    });
    return soundController_;

    TCEND
}

+ (id)alloc {
    NSAssert(soundController_ == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

- (void)playSound:(enum enumSounds)Sound {
    TCSTART

    NSString *SoundToPlay = nil;

    BOOL tForEffectfForBackground = TRUE;

    if (Sound == ENUM_BACKGROUND_MUSIC_______LEVEL_BACKGROUND_MUSIC) {
        SoundToPlay = @"backGroundMusic.mp3";
        tForEffectfForBackground = FALSE;
    } else if (Sound == ENUM_BACKGROUND_MUSIC_______OTHER_SCREENS_BACKGROUND_MUSIC) {
        SoundToPlay = @"backGroundMusic.mp3";
        tForEffectfForBackground = FALSE;
    }
    else if (Sound == ENUM_SOUND_EFFECT_______WHEN_CHOOSING_OPTIONS) SoundToPlay = @"optionSelect.mp3";

    dispatch_async(dispatch_get_main_queue(), ^{
        if (tForEffectfForBackground) [[SimpleAudioEngine sharedEngine]playEffect:SoundToPlay];
        else [[CDAudioManager sharedManager] playBackgroundMusic:SoundToPlay loop:YES];
    });

    TCEND
}

- (void)pauseSound {
    TCSTART

    [self muteSound];
    [[CDAudioManager sharedManager] pauseBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:soundEffectsVolumeWhenWantedToStop];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:FALSE] forKey:isGameSoundsOn];

    TCEND
}

- (void)resumeSound {
    TCSTART

    [self unMuteSound];
    [[CDAudioManager sharedManager] resumeBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:soundEffectsVolumeWhenWantedToPlay];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:TRUE] forKey:isGameSoundsOn];

    TCEND
}

- (void)muteSound {
    TCSTART

    [[CDAudioManager sharedManager] setMute : TRUE];
    [[SimpleAudioEngine sharedEngine] setMute:TRUE];

    TCEND
}

- (void)unMuteSound {
    TCSTART

    [[CDAudioManager sharedManager] setMute : FALSE];
    [[SimpleAudioEngine sharedEngine] setMute:FALSE];

    TCEND
}

- (BOOL)isBackgroundMusicIsPlaying {
    return [[CDAudioManager sharedManager] isBackgroundMusicPlaying];
}

- (BOOL)gameSoundsStatus {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:isGameSoundsOn]boolValue];
}

- (void)stopAll {
	[[CDAudioManager sharedManager] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}


@end
