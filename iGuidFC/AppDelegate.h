//
//  AppDelegate.h
//  AMSlideMenu
//
//  Created by Artur Mkrtchyan on 12/24/13.
//  Copyright (c) 2013 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>
{

}
@property (strong, nonatomic) UIWindow *window;

@property AVAudioPlayer *audioPlayer;
@property AVAudioPlayer *backgroundPlayer;

@property BOOL isSpecial;

@property NSNumber *articleID;
//当前正在播放的Index
@property NSInteger currentPlayingIndex;
@property BOOL femaleVoiceType;
@property NSInteger backgroundIndex;
@property NSMutableArray *previousVoice;
@property BOOL isShowAlarm;//控制标志，只显示一次提示，防止定位反复出现提示多次情况
@property BOOL isShowSmartHint;//控制标志，只显示一次提示，防止定位反复出现提示多次情况
@property BOOL isSmartMode;
@property BOOL isBackMusicMode;

@property NSArray *backgroundMusicList;

@property int limiteNum;//免费版的限制语音数量

+(sqlite3 *)openDB;

- (void) resumeOrPlay;

- (void) playBackground;

@end
