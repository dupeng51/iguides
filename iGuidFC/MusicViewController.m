//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by 千里马LZZ on 13-10-19.
//  Copyright (c) 2013年 Lizizheng. All rights reserved.
//

#import "MusicViewController.h"
#import "DXSemiViewControllerCategory.h"
#import "FCSettingVC.h"
#import "IntroModel.h"
#import "IntroControll.h"
#import "UIViewController+AMSlideMenu.h"


@interface MusicViewController ()

@end
//用静态全局变量来保存这个单例
//static MusicViewController *instance = nil;


@implementation MusicViewController
{
    NSTimer *timer;
    FCSettingVC *settingsVC;
}

@synthesize progressSlider, playBtn, circleBtn, rightBtn, currentTimeLabel, totalTimeLabel, musicTableView, lrcTableView, musicArray, imageview, playImage;

#define keyVoiceVolume @"voicevolume"
#define KeyMode @"playmode"
#define photoNum 27

#define imageCyCle @"circle.png"
#define imageRandom @"random.png"
#define imageRepeat @"repeat.png"

//+ (id)sharemusicArray {
//    if (instance == nil) {
//        instance = [[[self class] alloc] init];
//    }
//    return instance;
//}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isPlay = YES;
    lrcLineNumber = 0;
    musicTableViewHidden = YES;//初始化隐藏歌曲目录
    musicTableView.hidden = YES;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //初始化要加载的曲目
    [self initDate];
//    musicArrayNumber = 0;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    session = nil;
    
    if (!appDelegate.backgroundPlayer) {
        NSURL *fileURL = [NSURL fileURLWithPath:[appDelegate.backgroundMusicList objectAtIndex:appDelegate.backgroundIndex]];
        appDelegate.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        currentMusic = musicArray[appDelegate.backgroundIndex];
        
        
        //初始化音量和音量进度条
        
        appDelegate.backgroundPlayer.volume = [FCSettingVC getfloatByKey:keyVoiceVolume];
    } else {
        
    }
    //接管音乐播放代理Delegate
    appDelegate.backgroundPlayer.delegate = self;
    [self updateView];
//    soundSlider.hidden = YES;
    
    //初始化歌词词典
//    timeArray = [[NSMutableArray alloc] initWithCapacity:10];
//    LRCDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    //初始化播放进度条
    [progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateNormal];
    [progressSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateHighlighted];
    
//    [self initLRC];
    
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
}
- (void) dealloc
{
    appDelegate.backgroundPlayer.delegate = appDelegate;
    
    progressSlider= nil;
    playBtn = nil;
    circleBtn = nil;
    rightBtn = nil;
    currentTimeLabel = nil;
    totalTimeLabel = nil;
    musicTableView = nil;
    lrcTableView = nil;
    musicArray = nil;
    
    currentMusic = nil;
    timeArray = nil;
    LRCDictionary = nil;
    appDelegate = nil;
    timer = nil;
    imageview = nil;
    playImage = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    //设置监控 每秒刷新一次时间
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                 target:self
                                               selector:@selector(showTime)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    [self initView];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}

- (void)initView
{
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    int i = 1;
    for (NSString *path in appDelegate.backgroundMusicList) {
        NSString *desc = [[path lastPathComponent] stringByDeletingPathExtension];
        NSString *preName = @"photo";
#ifdef SP_VERSION
        preName = @"Summer Palace";
#endif
#ifdef TH
        preName = @"templeHeaven";
#endif
#ifdef Yu
        preName = @"YuGarden";
#endif
#ifdef LT
        preName = @"Lama";
#endif
        IntroModel *model = [[IntroModel alloc] initWithTitle:@"" description:desc image:[NSString stringWithFormat:@"%@%d", preName, i] type:@"jpg"];
        [pages addObject:model];
        i++;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    introControll = [[IntroControll alloc] initWithFrame:rect pages:pages email:NO];
    [imageview addSubview:introControll];
    [introControll scrollTo:appDelegate.backgroundIndex];
}

- (void) updateView{
    if (appDelegate.backgroundPlayer.isPlaying) {
        [playImage setImage:[UIImage imageNamed:@"pause.png"]];
        isPlay = NO;
    } else {
        [playImage setImage:[UIImage imageNamed:@"play.png"]];
        isPlay = YES;
    }
    float value = [FCSettingVC getfloatByKey:KeyMode];
    if (value == 0.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageCyCle] forState:UIControlStateNormal];
    }
    if (value == 1.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageRandom] forState:UIControlStateNormal];
    }
    if (value == 2.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageRepeat] forState:UIControlStateNormal];
    }
    
}

#pragma mark 载入歌曲数组
- (void)initDate {
    musicArray = [[NSMutableArray alloc]initWithCapacity:appDelegate.backgroundMusicList.count];
    for (NSString *path in appDelegate.backgroundMusicList) {
        
        Music *music = [[Music alloc] initWithName:[[path lastPathComponent] stringByDeletingPathExtension] andType:@"mp3"];
        [musicArray addObject:music];
    }
}
#pragma mark 0.1秒一次更新 播放时间 播放进度条 歌词 歌曲 自动播放下一首
- (void)showTime {
    //动态更新进度条时间
    if ((int)appDelegate.backgroundPlayer.currentTime % 60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)appDelegate.backgroundPlayer.currentTime / 60, (int)appDelegate.backgroundPlayer.currentTime % 60];
    } else {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)appDelegate.backgroundPlayer.currentTime / 60, (int)appDelegate.backgroundPlayer.currentTime % 60];
    }
    //
    if ((int)appDelegate.backgroundPlayer.duration % 60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)appDelegate.backgroundPlayer.duration / 60, (int)appDelegate.backgroundPlayer.duration % 60];
    } else {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)appDelegate.backgroundPlayer.duration / 60, (int)appDelegate.backgroundPlayer.duration % 60];
    }
    progressSlider.value = appDelegate.backgroundPlayer.currentTime / appDelegate.backgroundPlayer.duration;
    
    if (appDelegate.backgroundPlayer.isPlaying) {
        [playImage setImage:[UIImage imageNamed:@"pause.png"] ];
        isPlay = NO;
    } else {
        [playImage setImage:[UIImage imageNamed:@"play.png"] ];
        isPlay = YES;
    }
//    [self displaySondWord:audioPlayer.currentTime];//调用歌词函数
    
//    //如果播放完，调用自动播放下一首
//    if (progressSlider.value > 0.999) {
//            [self autoPlay];
//    }

    //    NSLog(@"%f",audioPlayer.volume);
}
#pragma mark 动态显示歌词
- (void)displaySondWord:(NSUInteger)time {
    //    NSLog(@"time = %u",time);
    for (int i = 0; i < [timeArray count]; i++) {
        
        NSArray *array = [timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        if (i == [timeArray count]-1) {
            //求最后一句歌词的时间点
            NSArray *array1 = [timeArray[timeArray.count-1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            if (time > currentTime1) {
                [self updateLrcTableView:i];
                break;
            }
        } else {
            //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
            NSArray *array2 = [timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
            if (time < currentTime2) {
                [self updateLrcTableView:0];
//                NSLog(@"马上到第一句");
                break;
            }
            //求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [timeArray[i+1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            if (time >= currentTime && time <= currentTime3) {
                [self updateLrcTableView:i];
                break;
            }
            
        }
    }
}
   
#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber {
//    NSLog(@"lrc = %@", [LRCDictionary objectForKey:[timeArray objectAtIndex:lineNumber]]);
    //重新载入 歌词列表lrcTabView
    lrcLineNumber = lineNumber;
    [lrcTableView reloadData];
    //使被选中的行移到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber inSection:0];
    [lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    NSLog(@"%i",lineNumber);
}


#pragma mark 播放目前的音乐
- (IBAction)play:(id)sender {
    if (isPlay) {
        [appDelegate.backgroundPlayer play];
        appDelegate.isBackMusicMode = YES;
        [playImage setImage:[UIImage imageNamed:@"pause.png"]];
        isPlay = NO;
    } else {
        [appDelegate.backgroundPlayer pause];
        [playImage setImage:[UIImage imageNamed:@"play.png"]];
        isPlay = YES;
    }
//    audioPlayer.volume = soundSlider.value;//重置音量,(每次播放的默认音量好像是1.0)
}
#pragma mark 上一首
- (IBAction)aboveMusic:(id)sender {
    if (appDelegate.backgroundIndex == 0) {
        appDelegate.backgroundIndex = musicArray.count;
    }
    appDelegate.backgroundIndex --;
    
    [self updatePlayerSetting];
    [introControll scrollTo:appDelegate.backgroundIndex];
}
#pragma mark 下一首
- (IBAction)nextMusic:(id)sender {
    [self autoPlay];
}
#pragma mark 自动进入下一首
- (void)autoPlay {
    //判断是否允许循环播放
    int value = [FCSettingVC getfloatByKey:KeyMode];
    if (value == 1.0f) {
        int randomIndex = arc4random_uniform(appDelegate.backgroundMusicList.count);
        while (appDelegate.backgroundIndex == randomIndex) {
            randomIndex = arc4random_uniform(appDelegate.backgroundMusicList.count);
        }
        appDelegate.backgroundIndex = randomIndex;
    }
    //顺序播放
    if (value == 0.0f) {
        if (appDelegate.backgroundIndex == musicArray.count - 1) {
            appDelegate.backgroundIndex = -1;
        }
        appDelegate.backgroundIndex ++;
    }
    [self updatePlayerSetting];
    //单曲循环播放
    if (value == 2.0f) {
        [appDelegate.backgroundPlayer play];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay = NO;
    }
    
    [introControll scrollTo:appDelegate.backgroundIndex];
}
#pragma mark 摇一摇 换歌
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (appDelegate.backgroundIndex == musicArray.count - 1) {
            appDelegate.backgroundIndex = -1;
        }
        appDelegate.backgroundIndex ++;
        
        [self updatePlayerSetting];
    }
}
//更新播放器设置
- (void)updatePlayerSetting {
    //更新播放按钮状态
        [playImage setImage:[UIImage imageNamed:@"pause.png"]];
    isPlay = NO;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    session = nil;
    //更新曲目
    NSURL *fileURL = [NSURL fileURLWithPath:[appDelegate.backgroundMusicList objectAtIndex:appDelegate.backgroundIndex]];
    appDelegate.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
    currentMusic = musicArray[appDelegate.backgroundIndex];
    appDelegate.backgroundPlayer.delegate = self;
    
    [appDelegate.backgroundPlayer play];
}



- (IBAction)progressChange:(id)sender {
    appDelegate.backgroundPlayer.currentTime = progressSlider.value * appDelegate.backgroundPlayer.duration;
}

- (IBAction)circle:(id)sender {
    float value = [FCSettingVC getfloatByKey:KeyMode];
    value ++;
    if (value == 3.0f) {
        value = 0.0f;
    }
    if (value == 0.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageCyCle] forState:UIControlStateNormal];
    }
    if (value == 1.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageRandom] forState:UIControlStateNormal];
    }
    if (value == 2.0f) {
        [circleBtn setImage:[UIImage imageNamed:imageRepeat] forState:UIControlStateNormal];
    }
    
    [FCSettingVC setKey:[NSNumber numberWithFloat:value] key:KeyMode];
}

#pragma mark 表视图
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return [musicArray count];
    } else {
        return [timeArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LRCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//该表格选中后没有颜色
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == lrcLineNumber) {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    } else {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //        cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //        [cell.contentView addSubview:lable];//往列表视图里加 label视图，然后自行布局
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}
//选中后的响应函数
- (void)playTable:(NSUInteger)tableNumber {
    appDelegate.backgroundIndex = tableNumber;
    [self updatePlayerSetting];
    [introControll scrollTo:tableNumber];
}
#pragma mark 播放目录 按钮
- (IBAction)rightView:(id)sender {
    RightViewController *rightView = [[RightViewController alloc] init];
    rightView.myMusic = self;
    rightView.semiTitleLabel.text = @"";
    self.rightSemiViewController = rightView;
    
}
#pragma mark 打开左侧菜单 按钮
- (IBAction)openLeftMenu:(id)sender
{
    [[self mainSlideMenu] openLeftMenu];
}

#pragma mark 播放指定曲目 按钮
- (void)playWithIndex:(int) index
{
    if (index != appDelegate.backgroundIndex) {
        appDelegate.backgroundIndex = index;
        [self updatePlayerSetting];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self autoPlay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)openSettings:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iGuide Music(Full Version)"
                                                    message:@"Chinese beautiful light music with no ad, get it?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",
                          nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-music/id881391239";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    
}

@end
