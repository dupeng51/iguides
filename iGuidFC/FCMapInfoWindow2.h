//
//  FCMapInfoWindow2.h
//  AMSlideMenu
//
//  Created by dampier on 14-2-25.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "POArticle.h"
#import <GoogleMaps/GoogleMaps.h>

@interface FCMapInfoWindow2 : UIView <AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    //当前地图选择的景点数据
    POArticle *currentSpot;
}
//@property (strong, nonatomic) NSTimer * timer;


@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIImageView *playImage;
@property BOOL isPlay;
//@property AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;

//@property (strong, nonatomic) IBOutlet UIView *controlPanel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ZHLabel;

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;

@property (strong, nonatomic) IBOutlet UIButton *voiceTypeBtn;
- (IBAction)voiceTypeTaped:(id)sender;

//当前正在播放的景点数据
@property POArticle *currentPlayingSpot;

@property POArticle *userData;

- (UIViewController*) viewController;

- (void) changeSpot:(NSArray *)spots currentIndex:(NSInteger)index;

- (void) changeTaxi:(POArticle *) atm;

//@property NSTimer *timer;

- (void) disapear;
- (void) apear;
- (void) updatePos:(CLLocationCoordinate2D) pos;

- (IBAction)play:(id)sender;
- (IBAction)progressChange:(id)sender;
- (IBAction)nextVoice:(id)sender;
- (IBAction)previousVoice:(id)sender;
- (IBAction)detailedWindow:(id)sender;
- (IBAction)specialBtnClick:(id)sender;

+ (void) configPlayingInfo:(POArticle *) spot;
+ (BOOL) voiceExistWithSubspot:(POArticle *) subSpot;
+ (void) showDownloadAlarm:(id) delegete;

@end
