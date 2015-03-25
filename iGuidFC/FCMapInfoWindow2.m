//
//  FCMapInfoWindow2.m
//  AMSlideMenu
//
//  Created by dampier on 14-2-25.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FCMapInfoWindow2.h"
#import "FCMapController.h"
#import "AppDelegate.h"
#import "ArticleSectionController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>
#import "panoramaVC.h"
#import "FCSettingVC.h"
#import "DaoArticle.h"
#import "POSection.h"

@implementation FCMapInfoWindow2
{
    Boolean isNewSpot;
    NSInteger currentIndex;
//    NSInteger currentPlayingIndex;
    NSArray *voiceSpots;
    AppDelegate *appDelegate;
    NSTimer *timer;
}
//背景音乐数量
#define keyVoiceVolume @"voicevolume"
#define keyPlayNearby @"playnearby"
#define keyMusic @"backgroundmusic"
#define keyMusicVolume @"musicvolume"
#define keyPlayNext @"playnext"
#define KeyFullVersion @"fullversion"
#define KeyVoiceType @"voicetype"

@synthesize playBtn, isPlay, progressSlider, currentTimeLabel, totalTimeLabel, titleLabel, ZHLabel, currentPlayingSpot, image, nextButton, previousButton, userData, playImage, voiceTypeBtn;

//通过代码创建时调用，如[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        FCMapInfoWindow2 *view =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow2" owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
    }
    
    return self;
}
 */

//通过Xib文件初始化时调用，如[[NSBundle mainBundle] loadNibNamed...
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        isPlay = YES;
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        audioPlayer = appDelegate.audioPlayer;
//        if (!(appDelegate.isSmartMode)) {
            audioPlayer.delegate = self;
//        }
        [self initData:appDelegate];
        
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//        [audioPlayer prepareToPlay];
        
        //注册后台播放
//        [[AVAudioSession  sharedInstance] setCategory: AVAudioSessionCategoryPlayback  error: nil];
//        // Activates the audio session.
//        NSError *activationError = nil;
//        [[AVAudioSession  sharedInstance] setActive: YES   error: &activationError];
    }
    
    return self;
}


- (void) initData:(AppDelegate *) appDelegate
{

}

-(void)dealloc
{
    audioPlayer.delegate = nil;
    
    appDelegate = nil;
    voiceSpots = nil;
    currentPlayingSpot = nil;
    audioPlayer= nil;
    [timer invalidate];
    timer = nil;
    currentSpot = nil;
    
    playBtn = nil;
    progressSlider = nil;
    currentTimeLabel = nil;
    totalTimeLabel = nil;
//    controlPanel = nil;
    titleLabel = nil;
    image = nil;
    nextButton = nil;
    ZHLabel = nil;
    previousButton = nil;
    userData = nil;
    playImage = nil;
    voiceTypeBtn = nil;
}

- (IBAction)play:(id)sender {
    //验证是否允许播放,是否受限制版本
    int limitedNum = appDelegate.limiteNum;
    float isFullVersion = [FCSettingVC getfloatByKey:KeyFullVersion];
    if ((currentIndex >= limitedNum) && (isFullVersion ==0)) {
        [self showUpgrade];
        return;
    }
    
    if (isPlay) {
        if (!audioPlayer || isNewSpot) {
            NSURL *fileURL;
            if ([FCSettingVC getfloatByKey:KeyVoiceType]) {
                //female voice
                fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename1) ofType:(currentSpot.voice_filetype)]];
            } else {
                // male voice
                fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename) ofType:(currentSpot.voice_filetype)]];
            }
            if (audioPlayer) {
                if (audioPlayer.isPlaying) {
                    [audioPlayer stop];
                }
            }
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            [session setActive:YES error:nil];
            
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            appDelegate.audioPlayer = audioPlayer;
//            if (!(appDelegate.isSmartMode)) {
                audioPlayer.delegate = self;
//            }
        }
        
        float voice_volume = [FCSettingVC getfloatByKey:keyVoiceVolume];
        
        audioPlayer.volume = voice_volume;//重置音量,(每次播放的默认音量好像是1.0)
        [audioPlayer setNumberOfLoops:0];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
//        if (!appDelegate.isSmartMode) {
//            appDelegate.isSmartMode = NO;
//        }
        
        [appDelegate playBackground];
        
        currentPlayingSpot = currentSpot;
        appDelegate.currentPlayingIndex = currentIndex;
        
        //添加播放的index到回放序列，用于回放
        if (!appDelegate.previousVoice) {
            appDelegate.previousVoice = [[NSMutableArray alloc] init];
        }
        [appDelegate.previousVoice addObject:[NSNumber numberWithInt:appDelegate.currentPlayingIndex]];
    
        //设置待机封面
        POArticle *spot = [voiceSpots objectAtIndex:appDelegate.currentPlayingIndex];
        [FCMapInfoWindow2 configPlayingInfo:spot];
        //设置暂停图标
        [playImage setImage:[UIImage imageNamed:@"f04c.png"]];
        FCMapController *mapController = (FCMapController *)[self viewController];
        
        //注册后台播放
        [[AVAudioSession  sharedInstance] setCategory: AVAudioSessionCategoryPlayback  error: nil];
        // Activates the audio session.
        NSError *activationError = nil;
        [[AVAudioSession  sharedInstance] setActive: YES   error: &activationError];
        
        [mapController play];
        
        [timer setFireDate: [NSDate distantPast]];
        isPlay = NO;
        isNewSpot = NO;
        
        activationError = nil;
        mapController = nil;
    } else {
        [audioPlayer pause];
        [appDelegate.backgroundPlayer pause];
        //设置播放图标
        [playImage setImage:[UIImage imageNamed:@"f04b.png"]];
//        controlPanel.backgroundColor = [UIColor grayColor];
        isPlay = YES;
        isNewSpot = NO;
    }
    //更新按钮状态
    float isNear = [FCSettingVC getfloatByKey:keyPlayNearby];
    if (isNear == 1) {
        nextButton.enabled = YES;
    } else {
        if (appDelegate.currentPlayingIndex + 1 == voiceSpots.count) {
            nextButton.enabled = NO;
        } else {
            nextButton.enabled = YES;
        }
    }
    
    if (appDelegate.previousVoice.count >= 2) {
        previousButton.enabled = YES;
    } else {
        previousButton.enabled = NO;
    }
}

- (IBAction)specialBtnClick:(id)sender
{
//    UIButton *btn = (UIButton *) sender;
//    if (appDelegate.isSpecial) {
////        btn.titleLabel.backgroundColor = [UIColor redColor];
//        [btn setTitle:@"General" forState:UIControlStateNormal] ;
////        btn setTitleColor:<#(UIColor *)#> forState:<#(UIControlState)#>
//        appDelegate.isSpecial = NO;
//    } else {
////        btn.titleLabel.backgroundColor = [UIColor redColor];
//        [btn setTitle:@"Special" forState:UIControlStateNormal] ;
//        appDelegate.isSpecial = YES;
//    }
//    btn = nil;
    [self showSpot:nil];

}

- (IBAction)progressChange:(id)sender {
    audioPlayer.currentTime = progressSlider.value * audioPlayer.duration;
}

- (void)showTime {
    if (!audioPlayer || !currentTimeLabel) {
        return;
    }
    if (isPlay) {
        return;
    }
    //动态更新进度条时间
//    if ((int)audioPlayer.currentTime % 60 < 10) {
//        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
//    } else {
//        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
//    }
    int leftSecond = audioPlayer.duration - audioPlayer.currentTime;
    if ((int)leftSecond % 60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"-%d:0%d",leftSecond / 60, leftSecond % 60];
    } else {
        currentTimeLabel.text = [NSString stringWithFormat:@"-%d:%d",leftSecond / 60, leftSecond % 60];
    }
    //
    if ((int)audioPlayer.duration % 60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    } else {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    }
    progressSlider.value = audioPlayer.currentTime / audioPlayer.duration;
    
    //如果播放完，调用自动播放下一首
//    if (progressSlider.value > 0.999) {
//        [self nextVoice: nil];
//    }
    
    //    NSLog(@"%f",audioPlayer.volume);
}
- (void) disapear
{
//    [audioPlayer pause];
//    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    timer = nil;
}
- (void) apear
{
    //设置监控 每秒刷新一次时间
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector(showTime)
                                           userInfo:nil
                                            repeats:YES];
    //    [audioPlayer pause];
//    [timer setFireDate:[NSDate distantPast]];
    [self initView];
}
- (UIViewController*)viewController {
    UIViewController *currentViewController;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
        nextResponder = nil;
    }
    return currentViewController;
}

- (void) changeTaxi:(POArticle *) atm
{
    titleLabel.text = atm.title;
    ZHLabel.text = atm.remark;
    image.image = [UIImage imageNamed: atm.imagename];
    nextButton.hidden = YES;
    previousButton.hidden = YES;
    playBtn.hidden = YES;
}
//根据当前地图选择景点，显示相关信息和控制按钮
- (void) changeSpot:(NSArray *)spots currentIndex:(NSInteger)index
{
    nextButton.hidden = NO;
    previousButton.hidden = NO;
    playBtn.hidden = NO;
    POArticle *spot = [spots objectAtIndex:index];
    currentIndex = index;
    voiceSpots = spots;
//    if (!appDelegate.currentPlayingIndex) {
//        appDelegate.currentPlayingIndex = index;
//    }
    //如果当前景点和地图选择的景点不一致
    if (currentSpot.primaryid != spot.primaryid) {
        //显示新的景点的信息，显示播放图标
        titleLabel.text = spot.title;
        ZHLabel.text = spot.remark;
        image.image = [UIImage imageNamed: spot.imagename];
        
//        NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(spot.voice_filename) ofType:(spot.voice_filetype)]];
//        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//        [audioPlayer play];
        //设置播放图标
        [playImage setImage:[UIImage imageNamed:@"f04b.png"]];
        nextButton.enabled = NO;
        previousButton.enabled = NO;
        isPlay = YES;
        isNewSpot = YES;
        currentSpot = spot;
    } else {
        //重复点击则返回，不做任何操作
        
//        return;
    }
    //如果currentPlayingSpot为空，则说明是视图消失引起，
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!currentPlayingSpot) {
        currentPlayingSpot = [voiceSpots objectAtIndex:appDelegate.currentPlayingIndex];
    }
    //如果当前正在播放的景点和地图选择的景点一致
    if (currentPlayingSpot.primaryid == spot.primaryid) {
        
        [timer setFireDate:[NSDate distantPast]];
        if (audioPlayer.isPlaying) {
            //设置暂停图标
            [playImage setImage:[UIImage imageNamed:@"f04c.png"]];
            isPlay = NO;
        } else {
            //设置播放图标
            [playImage setImage:[UIImage imageNamed:@"f04b.png"]];
            isPlay = YES;
        }
        nextButton.enabled = YES;
        previousButton.enabled = YES;
    }
    else if (currentPlayingSpot) {
        //终止timer
        [timer setFireDate:[NSDate distantFuture]];
        //重置播放进度和时间
        currentTimeLabel.text = @"0:00";
        totalTimeLabel.text = @"0:00";
        progressSlider.value = 0;
        
    }
    spot = nil;
}

- (IBAction)previousVoice:(id)sender
{
    if (appDelegate.previousVoice && appDelegate.previousVoice.count < 2) {
        previousButton.enabled = NO;
        return;
    }
    [appDelegate.previousVoice removeLastObject];
    NSNumber *previousIndex = (NSNumber *)appDelegate.previousVoice.lastObject;
    [appDelegate.previousVoice removeLastObject];
    appDelegate.currentPlayingIndex = previousIndex.integerValue;
    
    [self changeSpot:voiceSpots currentIndex:appDelegate.currentPlayingIndex];
    [(FCMapController *)[self viewController] highlightMarker:appDelegate.currentPlayingIndex];
    
    isPlay = YES;
    [self play:sender];
    
    previousIndex = nil;
}

- (IBAction)voiceTypeTaped:(id)sender
{
    float female = [FCSettingVC getfloatByKey:KeyVoiceType];
    NSNumber *startTime = 0;
    if (appDelegate.audioPlayer.isPlaying && appDelegate.audioPlayer.currentTime > 0) {
        POArticle *spot = [voiceSpots objectAtIndex:appDelegate.currentPlayingIndex];
        NSNumber *pid = spot.primaryid;
        NSArray *sections = [[DaoArticle alloc] findAllArticleSectionsByID:pid];
        for (POSection *section in sections) {
            if (section.starttime && !(section.endtime)) {
                if (appDelegate.audioPlayer.currentTime > [section.starttime doubleValue]) {
                    if (female) {
                        startTime = section.starttime;
                    } else {
                        startTime = section.starttime1;
                    }
                    //切换声音文件
                    
                    break;
                }
            } else if (section.starttime && section.endtime) {
                if (appDelegate.audioPlayer.currentTime > [section.starttime doubleValue] && appDelegate.audioPlayer.currentTime < [section.endtime doubleValue]) {
                    if (female) {
                        startTime = section.starttime;
                    } else {
                        startTime = section.starttime1;
                    }
                    break;
                }
            }
        }
    }
    NSURL *fileURL;
    if (female) {
        fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename) ofType:(currentSpot.voice_filetype)]];
        
        [voiceTypeBtn setImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
        
    } else {
        fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename1) ofType:(currentSpot.voice_filetype)]];
        [voiceTypeBtn setImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateNormal];
    }
    [FCSettingVC setKey:[NSNumber numberWithBool:!female] key:KeyVoiceType];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    audioPlayer.delegate = self;
    
    float voice_volume = [FCSettingVC getfloatByKey:keyVoiceVolume];
    audioPlayer.volume = voice_volume;//重置音量,(每次播放的默认音量好像是1.0)
    audioPlayer.currentTime = [startTime doubleValue];
    if (appDelegate.audioPlayer.isPlaying) {
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
    appDelegate.audioPlayer = audioPlayer;
}

- (IBAction)nextVoice:(id)sender
{
    //验证是否允许播放,是否受限制版本
    int limitedNum = appDelegate.limiteNum;
    float isFullVersion = [FCSettingVC getfloatByKey:KeyFullVersion];
    if ((appDelegate.currentPlayingIndex >= limitedNum-1) && (isFullVersion ==0)) {
        [self showUpgrade];
        return;
    }
    
    float isNear = [FCSettingVC getfloatByKey:keyPlayNearby];
    NSNumber *nearIndex;
    if (isNear == 1) {
        nearIndex = [(FCMapController *)[self viewController] getTheNeareastSpotIndex:nil exceptIndex:appDelegate.currentPlayingIndex];
        if (nearIndex) {
            appDelegate.currentPlayingIndex = [nearIndex integerValue];
        }
    }
    if ((isNear==0) || !nearIndex) {
        if (appDelegate.currentPlayingIndex == voiceSpots.count - 1) {
            return;
        } else {
            appDelegate.currentPlayingIndex += 1;
        }
    }
    
    [self changeSpot:voiceSpots currentIndex:appDelegate.currentPlayingIndex];
    [(FCMapController *)[self viewController] highlightMarker:appDelegate.currentPlayingIndex];
    
    isPlay = YES;
    [self play:sender];
}

- (IBAction)detailedWindow:(id)sender
{
    if (currentSpot) {
        UIViewController *viewController = [self viewController];
        ArticleSectionController *childController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
        
        childController.masterkeyid = currentSpot.primaryid;
        
        if (currentSpot.primaryid == currentPlayingSpot.primaryid) {
            [childController playMode:audioPlayer];
        }
        
        childController.title = currentSpot.title;
        childController.articleTitle = currentSpot.title;
        [viewController.navigationController pushViewController: childController animated:(true)];
    }
}
//设置待机图案
+ (void)configPlayingInfo:(POArticle *) spot;
{
//    POArticle *spot = [voiceSpots objectAtIndex:appDelegate.currentPlayingIndex];
    if (!spot.title || !spot.imagename){
        return;
    }
	if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
		NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
		[dict setObject: spot.title forKey:MPMediaItemPropertyTitle];
		[dict setObject:@"iGuide" forKey:MPMediaItemPropertyArtist];
		[dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:spot.imagename]] forKey:MPMediaItemPropertyArtwork];
        
//		[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
		[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
        dict = nil;
	}
    spot = nil;
}

- (void) initView
{
    //兼容IOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [playBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    //设置图片圆角
    [image.layer setMasksToBounds:YES];
    [image.layer setCornerRadius:4];
    
    UITapGestureRecognizer * regnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSpot:)];
    [image addGestureRecognizer:regnizer];
    
    BOOL female = [FCSettingVC getfloatByKey:KeyVoiceType];
    if (!female) {
        [voiceTypeBtn setImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
    } else {
        [voiceTypeBtn setImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateNormal];
        
    }
}

-(void) showUpgrade
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limited for Free Version"
                                                    message:@"Upgrade to Full Version with all audio guide and no limited function."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",
                          nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIViewController *childController = [[self viewController].storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
        [[self viewController].navigationController pushViewController:childController animated:YES];
    }
}


#pragma mark - Audio method

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([appDelegate.audioPlayer isEqual:player]) {
        //验证是否允许播放,是否受限制版本
        int limitedNum = appDelegate.limiteNum;
        float isFullVersion = [FCSettingVC getfloatByKey:KeyFullVersion];
        if ((appDelegate.currentPlayingIndex >= limitedNum-1) && (isFullVersion ==0)) {
            [self showUpgrade];
            [self changeSpot:voiceSpots currentIndex:appDelegate.currentPlayingIndex];
            return;
        }
        
        float on = [FCSettingVC getfloatByKey:keyPlayNext];
        if (on == 1) {
            [self nextVoice:nil];
        } else {
            [appDelegate.backgroundPlayer stop];
            [self changeSpot:voiceSpots currentIndex:appDelegate.currentPlayingIndex];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Image Typed
-(void) showSpot:(UITapGestureRecognizer *)sender
{
    UIViewController *viewController = [self viewController];
    panoramaVC *childController = [[panoramaVC alloc] initWithCoder:nil];
    

    
    childController.title = currentSpot.title;
    [viewController.navigationController pushViewController: childController animated:(true)];
    
    childController = nil;
    viewController = nil;
}
//测试使用
- (void) updatePos:(CLLocationCoordinate2D) pos
{
    titleLabel.text = [NSString stringWithFormat:@"%f, %f",pos.latitude, pos.longitude ];
}

@end
