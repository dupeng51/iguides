//
//  AppDelegate.m
//  AMSlideMenu
//
//  Created by Artur Mkrtchyan on 12/24/13.
//  Copyright (c) 2013 Artur Mkrtchyan. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "iRate.h"
#import "FCSettingVC.h"
#import "POSpot.h"
#import "DownloadListVC.h"

@implementation AppDelegate

#define plistFileName @"guidesetting.plist"
#define keyVoiceVolume @"voicevolume"
#define keyPlayNearby @"playnearby"
#define keyMusic @"backgroundmusic"
#define keyMusicVolume @"musicvolume"
#define keyPlayNext @"playnext"
#define KeyMode @"playmode"

static sqlite3 *db;
@synthesize audioPlayer, backgroundPlayer, isSpecial, window, articleID, previousVoice, backgroundIndex, currentPlayingIndex, backgroundMusicList, limiteNum;

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
//    [iRate sharedInstance].applicationBundleID = @"com.suntrip.iGuidFC";
    
	[iRate sharedInstance].onlyPromptIfLatestVersion = YES;
    
    //enable preview mode
//    [iRate sharedInstance].previewMode = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    limiteNum = 1000;
#ifdef SP_VERSION
    limiteNum = 1000;
#endif
#ifdef TH
    limiteNum = 1000;
#endif
#ifdef Yu
    limiteNum = 1000;
#endif
#ifdef LT
    limiteNum = 1000;
#endif
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [[UINavigationBar appearance] setBarTintColor: [UIColor yellowColor]];
//    [[UINavigationBar appearance] setTintColor: [UIColor redColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [GMSServices provideAPIKey:@"AIzaSyAEnUaVmR0a6IA1NKhcN_vtpWrNHFXh_Kc"];
    
    
    isSpecial = NO;
    //初始化audioPlayer对象
//    audioPlayer = [AVAudioPlayer alloc];
//    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"情非得已" ofType:@"mp3"]];
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//    [audioPlayer prepareToPlay];
//    //后台播放音频设置
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    //让app支持接受远程控制事件
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //resource目录是只读的，要拷贝到Document目录
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *documentsDirectory= NSTemporaryDirectory();
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"guidesetting" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    //初始化背景音乐播放列表
    if (!backgroundMusicList) {
        backgroundMusicList = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"music"];
#ifdef TH
        backgroundMusicList = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"THMusic"];
#endif
#ifdef LT
        backgroundMusicList = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"LamaMusic"];
#endif
#ifdef China
//        backgroundMusicList = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"THMusic"];
#endif
    }
    
    //copy database for iGuide China
#ifdef China
    NSString *dateTmpPath = [documentsDirectory stringByAppendingPathComponent:@"china.sqlite"];
    if (![fileManager fileExistsAtPath: dateTmpPath])
    {
        NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"china" ofType:@"sqlite"];
        [fileManager copyItemAtPath:dataPath toPath: dateTmpPath error:&error];
    }
#endif
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Parse the incoming URL to look for a target_url parameter
                                      NSString *query = [url fragment];
                                      if (!query) {
                                          query = [url query];
                                      }
                                      NSDictionary *params = [self parseURLParams:query];
                                      // Check if target URL exists
                                      NSString *targetURLString = [params valueForKey:@"target_url"];
                                      if (targetURLString) {
                                          // Show the incoming link in an alert
                                          // Your code to direct the user to the appropriate flow within your app goes here
//                                          [[[UIAlertView alloc] initWithTitle:@"Received link:"
//                                                                      message:targetURLString
//                                                                     delegate:self
//                                                            cancelButtonTitle:@"OK"
//                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
    
    return urlWasHandled;
}
+ (sqlite3 *)openDB
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"fc" ofType:@"sqlite"];
#ifdef SP_VERSION
    dataPath = [[NSBundle mainBundle] pathForResource:@"sp" ofType:@"sqlite"];
#endif
    
#ifdef TH
    dataPath = [[NSBundle mainBundle] pathForResource:@"th" ofType:@"sqlite"];
#endif
    
#ifdef Yu
    dataPath = [[NSBundle mainBundle] pathForResource:@"yu" ofType:@"sqlite"];
#endif
    
#ifdef LT
    dataPath = [[NSBundle mainBundle] pathForResource:@"lamaTemple" ofType:@"sqlite"];
#endif
    
#ifdef China
    NSString *documentsDirectory= NSTemporaryDirectory();
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"china.sqlite"];
//    dataPath = [[NSBundle mainBundle] pathForResource:@"china" ofType:@"sqlite"];
#endif
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([dataPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    return db;
}
//黑屏和home键都会进入该方法
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers,
     
     and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    if (audioPlayer) {
//        [audioPlayer pause];
//    }
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    if (audioPlayer) {
//        [audioPlayer play];
//    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    audioPlayer = nil;
    backgroundPlayer = nil;
    window = nil;
    articleID = nil;
    previousVoice = nil;
    _downloadOperations = nil;
    _currentPlayingSpotID = nil;
    NSLog(@"退出app");
    
}
/*----------------------------------------------------*/
#pragma mark - Audio -
/*----------------------------------------------------*/
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    int value = [FCSettingVC getfloatByKey:KeyMode];
    if (value == 1.0f) {
        int randomIndex = arc4random_uniform(backgroundMusicList.count);
        while (backgroundIndex == randomIndex) {
            randomIndex = arc4random_uniform(backgroundMusicList.count);
        }
        backgroundIndex = randomIndex;
    }
    //顺序播放
    if (value == 0.0f) {
        if (backgroundIndex == backgroundMusicList.count - 1) {
            backgroundIndex = -1;
        }
        backgroundIndex ++;
    }
    //单曲循环播放
    if (value == 2.0f) {
        
    } //更新曲目
    NSURL *fileURL = [NSURL fileURLWithPath:[backgroundMusicList objectAtIndex:backgroundIndex]];
    backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
    backgroundPlayer.delegate = self;
    
    [backgroundPlayer play];
}

- (void) playBackground:(NSString *) spotid
{
    //从Document目录读取数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *documentsDirectory= NSTemporaryDirectory();
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    float on = [[dict objectForKey:keyMusic] floatValue];
    float backVolume = [[dict objectForKey:keyMusicVolume] floatValue];
    
    if (on == 1) {
        if (!backgroundPlayer) {
            int beganIndex = arc4random_uniform(backgroundMusicList.count);
            
            NSURL *fileURL = [NSURL fileURLWithPath:[backgroundMusicList objectAtIndex:beganIndex]];
#ifdef China
            NSArray *musicPaths = [DownloadListVC getBackgroundPaths:spotid];
            if (musicPaths) {
                backgroundMusicList = musicPaths;
                beganIndex = arc4random_uniform(musicPaths.count);
                
                fileURL = [NSURL fileURLWithPath:[musicPaths objectAtIndex:beganIndex]];
            }
#endif
            backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            //            if (!(appDelegate.isSmartMode)) {
            backgroundPlayer.delegate = self;
            //            }
            backgroundIndex = beganIndex;
            fileURL = nil;
        }
        if (!backgroundPlayer.isPlaying) {
            backgroundPlayer.volume = backVolume;
            [backgroundPlayer setNumberOfLoops:0];
            [backgroundPlayer prepareToPlay];
            [backgroundPlayer play];
        }
    }
}

/*----------------------------------------------------*/
#pragma mark - public method -
/*----------------------------------------------------*/
- (void) resumeOrPlay
{
    if (audioPlayer) {
        if (audioPlayer.isPlaying) {
            [audioPlayer pause];
        } else {
            [audioPlayer play];
        }
    }
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void) addDownloadOperationsObject:(AFDownloadRequestOperation *)object
{
    if (!_downloadOperations) {
        _downloadOperations = [[NSMutableArray alloc] init];
    }
    AFDownloadRequestOperation * operation = [self getOperationWithSpotid:((POSpot *)object.userData).pid.intValue];
    if (operation) {
        return;
    }
    [self.downloadOperations addObject:object];
}

-(void) removeOperation:(int) spotid
{
    AFDownloadRequestOperation * operation = [self getOperationWithSpotid:spotid];
    if (operation) {
        [self.downloadOperations removeObject:operation];
    }
}

-(AFDownloadRequestOperation *) getOperationWithSpotid:(int) spotid
{
    for (AFDownloadRequestOperation *operation in self.downloadOperations) {
        if (((POSpot *)operation.userData).pid.intValue == spotid) {
            return operation;
        }
    }
    return nil;
}

@end
