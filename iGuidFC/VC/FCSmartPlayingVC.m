//
//  FCSmartPlayingVC.m
//  iGuidFC
//
//  Created by dampier on 14-5-5.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FCSmartPlayingVC.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import "KMLParser.h"
#import "KMLPoint.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "FCMapInfoWindow2.h"
#import "FCMapController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FCSettingVC.h"
#import "POSection.h"

@interface FCSmartPlayingVC ()

@end

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation FCSmartPlayingVC
{
    NSArray *spots;
    CLLocationManager *myLocationManager;
    CLLocation *_currentLocation;
    AVAudioPlayer *alarmPlayer;
    
    NSArray *topNeareastSpots;
    KMLParser *kmlParser;
    double radians;
    AppDelegate *appDelegate;
//    AVAudioPlayer *audioPlayer;
    
    NSTimer *timer;
    NSTimer * restartTimer;
    
    float isFullVersion;
}
#define minDistance_ 1200
#define numOfOtherSpot 3
#define labelWith 280
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define offsetAngle 90

#define numberOfMusic 10
#define plistFileName @"guidesetting.plist"
#define keyVoiceVolume @"voicevolume"
#define keyPlayNearby @"playnearby"
#define keyMusic @"backgroundmusic"
#define keyMusicVolume @"musicvolume"
#define keyPlayNext @"playnext"
#define KeyFullVersion @"fullversion"
#define KeyVoiceType @"voicetype"

@synthesize spotImage, spotsTableView, englishName, chineseName, playBtn, isPlay, currentPlayingSpot, progressSlider, currentTimeLabel, totalTimeLabel, currentSpot, listBtn ,mapBtn, voiceTypeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    
    [self initData];
    [self initView];
    //提示Smart Guide的作用
    if (appDelegate.isShowSmartHint == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Guide"
                                                        message:@"Please plug in headphones and keep your screen unlocked, our location service will activate the audio guide automatically. Only available on spot."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        appDelegate.isShowSmartHint = YES;
    }
    
    
	// Do any additional setup after loading the view.
}

- (void) dealloc
{
    appDelegate.audioPlayer.delegate = nil;
    spots = nil;
    myLocationManager = nil;
    _currentLocation = nil;
    currentSpot = nil;
    topNeareastSpots = nil;
    kmlParser = nil;
    spotImage = nil;
    spotsTableView = nil;
    englishName = nil;
    chineseName = nil;
    playBtn = nil;
    timer = nil;
    currentPlayingSpot = nil;
    progressSlider = nil;
    currentTimeLabel = nil;
    totalTimeLabel = nil;
    alarmPlayer = nil;
    listBtn = nil;
    mapBtn = nil;
    voiceTypeBtn = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if([CLLocationManager locationServicesEnabled]) {
        if (!myLocationManager) {
            myLocationManager = [[CLLocationManager alloc] init];
            myLocationManager.delegate = self;
            myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
            myLocationManager.distanceFilter = 3.0f;
            myLocationManager.pausesLocationUpdatesAutomatically = YES;
//            myLocationManager.activityType = CLActivityTypeOther
            if ([myLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [myLocationManager requestAlwaysAuthorization];
            }
            [myLocationManager startUpdatingLocation];
//            [myLocationManager startMonitoringSignificantLocationChanges];
            /*
            // If the overlay's radius is too large, registration fails automatically,
            // so clamp the radius to the max value.
            CLLocationDegrees radius = 1000;
            if (radius > myLocationManager.maximumRegionMonitoringDistance) {
                radius = myLocationManager.maximumRegionMonitoringDistance;
            }
            
            // Create the geographic region to be monitored.
            CLCircularRegion *geoRegion = [[CLCircularRegion alloc]
                                           initWithCenter:CLLocationCoordinate2DMake(39.916813,116.390655)
                                           radius:radius
                                           identifier:@"FC"];
            [myLocationManager startMonitoringForRegion:geoRegion];
             */
        }
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
//    spotsTableView.backgroundColor = [UIColor clearColor];
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(showTime)
                                               userInfo:nil
                                                repeats:YES];
    }

    if (!restartTimer) {
        restartTimer = [NSTimer scheduledTimerWithTimeInterval:480.0f
                                                        target:self
                                                      selector:@selector(tryRestartLocationManager)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    
    isFullVersion = [FCSettingVC getfloatByKey:KeyFullVersion];
//    if (isFullVersion == 0) {
//        [self showUpgrade];
//    }

    [self refreshView];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    myLocationManager.delegate = nil;
//    myLocationManager = nil;
    
    [timer invalidate];
    timer = nil;
    
    [restartTimer invalidate ];
    restartTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
//    CGSize constraint = CGSizeMake(2000.0f, 20000.0f);
//    NSString *text = englishName.text;
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeCharacterWrap];
//    CGRect frame = englishName.frame;
//	frame.size.width = size.width;
//	englishName.frame = frame;
//    if (frame.size.width > labelWith) {
//        [UIView beginAnimations:@"testAnimation" context:NULL];
//        [UIView setAnimationDuration:5.0f];
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationRepeatAutoreverses:NO];
//        [UIView setAnimationRepeatCount:3];
//        
//        frame.origin.x = labelWith - frame.size.width;
//        englishName.frame = frame;
//        [UIView commitAnimations];
//    }
}

- (void)tryRestartLocationManager;
{
    NSLog(@"Restart Location Manager...");
    [myLocationManager stopUpdatingLocation];
    [myLocationManager startUpdatingLocation];
}

- (void)initData
{
    spots = [[DaoArticle alloc] findAllSpotsByLineNo:0];
    
    // Locate the path to the gugong.kml file in the application's bundle
    // and parse it with the KMLParser.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gugong" ofType:@"kml"];
#ifdef SP_VERSION
    path = [[NSBundle mainBundle] pathForResource:@"summerpalace" ofType:@"kml"];
#endif
#ifdef TH
    path = [[NSBundle mainBundle] pathForResource:@"th" ofType:@"kml"];
#endif
#ifdef Yu
    path = [[NSBundle mainBundle] pathForResource:@"YuGarden" ofType:@"kml"];
#endif
#ifdef LT
    path = [[NSBundle mainBundle] pathForResource:@"LamaTemple" ofType:@"kml"];
#endif
    NSURL *url = [NSURL fileURLWithPath:path];
    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    
    isPlay = YES;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.audioPlayer.delegate = self;
    
//    appDelegate.audioPlayer.delegate = self;
    
//    NSMutableArray *marks = [kmlParser marks];
}

/*----------------------------------------------------*/
#pragma mark - location Event -
/*----------------------------------------------------*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Update Location...");
    _currentLocation = [locations lastObject];
    CLLocationCoordinate2D location = _currentLocation.coordinate;
#ifdef Yu
    location =[FCMapController offsetCoordinate: _currentLocation.coordinate];
#endif
    
    if ([FCMapController isAbsolutOut:location]) {
        [manager stopUpdatingLocation];
    }
    
    if (_currentLocation) {
//        playBtn.enabled = YES;
        POArticle *theNearestSpot = [self getTheNeareastSpot];
        if (theNearestSpot) {
            int maxNumLimited = appDelegate.limiteNum;
            if (isFullVersion == 0 && theNearestSpot.orderno >= maxNumLimited) {
//                [self showSpot:theNearestSpot];
                [self showUpgrade];
                return;
            }
            
            currentSpot = theNearestSpot;
            [self showSpot:currentSpot];
            
            topNeareastSpots = [self getNearSpots:currentSpot];
            [spotsTableView reloadData];
            
            if (appDelegate.audioPlayer.isPlaying) {
                if (![currentSpot.primaryid isEqual:currentPlayingSpot.primaryid]) {
                    if (currentPlayingSpot) {
                        playBtn.enabled = NO;
                        [appDelegate.audioPlayer stop];
                        
                        //播放切换音效
                        NSURL *fileURL1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dd" ofType:@"wav"]];
                        alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL1 error:nil];
                        alarmPlayer.delegate = self;
                        alarmPlayer.volume = 2;//重置音量,(每次播放的默认音量好像是1.0)
                        [alarmPlayer setNumberOfLoops:0];
                        [alarmPlayer prepareToPlay];
                        [alarmPlayer play];
                        playBtn.enabled = YES;
                    } else {
                        if ([spots indexOfObject:currentSpot]!= appDelegate.currentPlayingIndex) {
                            isPlay = YES;
                            [self play:nil];
                        }
                    }
                }
            } else {
                if (isPlay) {
                    [self play:nil];
                }
            }
            
            [self refreshView];
            
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"did Enter Region: %@", region.identifier);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // Use the true heading if it is valid.
    CLLocationDirection direction = newHeading.magneticHeading;
    radians = - (direction + offsetAngle) / 180.0 * M_PI;
    [spotsTableView reloadData];
    
//    self.strAccuracy = [NSString stringWithFormat:@"%.1fmi",newHeading.headingAccuracy];
//    [lblAccuracy setText:self.strAccuracy];
//    
//    //Rotate Bearing View
//    [self rotateBearingView:bearingView radians:radians];
//    
//    //For Rotate Niddle
//    CGFloat angle = RadiansToDegrees(radians);
//    [self setLatLonForDistanceAndAngle];
//    [self rotateArrowView:arrowView degrees:(angle + fltAngle)];
}

#pragma mark - Audio method

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([alarmPlayer isEqual:player])
    {
//        [self refreshView];
        isPlay = YES;
        [self play:nil];
        
//        [appDelegate.backgroundPlayer pause];
    }
    
//    if ([appDelegate.audioPlayer isEqual:player]) {
//        //音效播放结束
//        [appDelegate.backgroundPlayer stop];
//    }
    
}

#pragma mark - Action

- (IBAction)nearbyList:(id)sender
{
    CGRect rect = spotsTableView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    if (rect.origin.x >= self.view.frame.size.width) {
        rect.origin.x = 0;
        [spotsTableView setFrame:rect];
        //开始获取方向传感器
        [myLocationManager startUpdatingHeading];
    } else {
        rect.origin.x = self.view.frame.size.width;
        [spotsTableView setFrame:rect];
        [myLocationManager stopUpdatingHeading];
    }
    [UIView commitAnimations];
}

-(IBAction)play:(id)sender
{
    if (isPlay) {
        if (currentPlayingSpot.primaryid != currentSpot.primaryid) {
            NSURL *fileURL;
            if ([FCSettingVC getfloatByKey:KeyVoiceType]) {
                fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename1) ofType:(currentSpot.voice_filetype)]];
            } else {
                fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:(currentSpot.voice_filename) ofType:(currentSpot.voice_filetype)]];
            }
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            [session setActive:YES error:nil];
            appDelegate.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            appDelegate.audioPlayer.delegate = self;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//        NSString *documentsDirectory = [paths objectAtIndex:0]; //2
        NSString *documentsDirectory= NSTemporaryDirectory();
        NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        float voice_volume = [[dict objectForKey:keyVoiceVolume] floatValue];
        
        appDelegate.audioPlayer.volume = voice_volume;//重置音量,(每次播放的默认音量好像是1.0)
        [appDelegate.audioPlayer setNumberOfLoops:0];
        [appDelegate.audioPlayer prepareToPlay];
        [appDelegate.audioPlayer play];
        appDelegate.isSmartMode = YES;
        [appDelegate playBackground:currentSpot.spotID.stringValue];
        
        currentPlayingSpot = currentSpot;
        appDelegate.currentPlayingIndex = [spots indexOfObject:currentSpot];
        
        //添加播放的index到回放序列，用于回放
        if (!appDelegate.previousVoice) {
            appDelegate.previousVoice = [[NSMutableArray alloc] init];
        }
        [appDelegate.previousVoice addObject:[NSNumber numberWithInt:appDelegate.currentPlayingIndex]];
        
        //设置待机封面
        [FCMapInfoWindow2 configPlayingInfo:currentSpot];
        //设置暂停图标
        [playBtn setBackgroundImage:[UIImage imageNamed:@"f04c.png"] forState:UIControlStateNormal];
        
        //注册后台播放
        [[AVAudioSession  sharedInstance] setCategory: AVAudioSessionCategoryPlayback  error: nil];
        // Activates the audio session.
        NSError *activationError = nil;
        [[AVAudioSession  sharedInstance] setActive: YES   error: &activationError];
        
        
        [timer setFireDate: [NSDate distantPast]];
        isPlay = NO;
        
        activationError = nil;
    } else {
        [appDelegate.audioPlayer pause];
        [appDelegate.backgroundPlayer pause];
        //设置播放图标
        [playBtn setBackgroundImage:[UIImage imageNamed:@"f04b.png"] forState:UIControlStateNormal];
        //        controlPanel.backgroundColor = [UIColor grayColor];
        isPlay = YES;
    }
}

- (IBAction)voiceTypeTaped:(id)sender
{
    float female = [FCSettingVC getfloatByKey:KeyVoiceType];
    NSNumber *startTime = 0;
    if (appDelegate.audioPlayer.isPlaying && appDelegate.audioPlayer.currentTime > 0) {
        POArticle *spot = [spots objectAtIndex:appDelegate.currentPlayingIndex];
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
    BOOL isPlaying = appDelegate.audioPlayer.isPlaying;
    appDelegate.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    appDelegate.audioPlayer.delegate = self;
    
    float voice_volume = [FCSettingVC getfloatByKey:keyVoiceVolume];
    appDelegate.audioPlayer.volume = voice_volume;//重置音量,(每次播放的默认音量好像是1.0)
    appDelegate.audioPlayer.currentTime = [startTime doubleValue];
    if (isPlaying) {
        [appDelegate.audioPlayer prepareToPlay];
        [appDelegate.audioPlayer play];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FCMapController *mapVC = ((FCMapController *)segue.destinationViewController);
    if ([sender isKindOfClass:[UIButton class]]) {
        mapVC.selectedSpotIndex = [NSNumber numberWithInt: [spots indexOfObject:currentSpot]];
    }
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [spotsTableView indexPathForCell:sender];
        [spotsTableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        int row = indexPath.row;
        POArticle *spot = [topNeareastSpots objectAtIndex:row];
        mapVC.selectedSpotIndex = [NSNumber numberWithInt: [spots indexOfObject:spot]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (topNeareastSpots) {
        return [topNeareastSpots count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取缓存的Cell
    NSString *CellIdentifier = @"spotCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    POArticle *spot = (POArticle *)[topNeareastSpots objectAtIndex:indexPath.row];
    
//    UIImageView *imageView = [cell viewWithTag:1];
//    imageView.image = [UIImage imageNamed:spot.imagename];
    
    UILabel *label = [cell viewWithTag:2];
    label.text = spot.title;
    
    UIImageView *arrowImage = [cell viewWithTag:1];
    double relatedAngle = [self getAngle:_currentLocation.coordinate  spot:CLLocationCoordinate2DMake(spot.positionx, spot.positiony)];
    arrowImage.transform = CGAffineTransformMakeRotation(radians + relatedAngle);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //背景透明
//    cell.backgroundColor = [UIColor clearColor];
//    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Method


//获取最近的景点index，空则说明不在故宫附近，或定位关闭
- (POArticle *)getTheNeareastSpot{
    //先判断是否落入某景点的范围
    POArticle *neareastSpot = [self theNeareastSpot];
//    //如果没有则选择最近的景点
//    if (!neareastSpot) {
//        double minDistance = minDistance_;
//        if (_currentLocation) {
//            for (POArticle *spot in spots) {
//                CLLocation *spotLocation =  [[CLLocation alloc] initWithLatitude:spot.positionx longitude: spot.positiony];
//                double distance = [_currentLocation distanceFromLocation:spotLocation];
//                if (distance < minDistance) {
//                    minDistance = distance;
//                    neareastSpot = spot;
//                }
//                spotLocation = nil;
//            }
//        }
//    }
    return neareastSpot;
}


#pragma mark - Private Method
- (void) refreshView
{
//    POArticle *spot =[spots objectAtIndex:appDelegate.currentPlayingIndex];
    
    //如果当前正在播放的景点和地图选择的景点一致
//    if (currentSpot.primaryid == spot.primaryid) {
    
//        [timer setFireDate:[NSDate distantPast]];
    int limitedNum = appDelegate.limiteNum;
    if (isFullVersion == 0 && currentSpot.orderno >= limitedNum) {
        playBtn.enabled = NO;
        listBtn.enabled = NO;
        mapBtn.enabled = NO;
        voiceTypeBtn.enabled = NO;
    } else {
        if (currentSpot) {
            playBtn.enabled = YES;
            listBtn.enabled = YES;
            mapBtn.enabled = YES;
            voiceTypeBtn.enabled = YES;
        } else {
            playBtn.enabled = NO;
            listBtn.enabled = NO;
            mapBtn.enabled = NO;
            voiceTypeBtn.enabled = NO;
        }
    }
    
    //set voice type (male/female)
    BOOL female = [FCSettingVC getfloatByKey:KeyVoiceType];
    if (!female) {
        [voiceTypeBtn setImage:[UIImage imageNamed:@"female.png"] forState:UIControlStateNormal];
    } else {
        [voiceTypeBtn setImage:[UIImage imageNamed:@"male.png"] forState:UIControlStateNormal];
        
    }
    
    if (appDelegate.audioPlayer.isPlaying) {
        //设置暂停图标
        [playBtn setBackgroundImage:[UIImage imageNamed:@"f04c.png"] forState:UIControlStateNormal];
        isPlay = NO;
    } else {
        //设置播放图标
        [playBtn setBackgroundImage:[UIImage imageNamed:@"f04b.png"] forState:UIControlStateNormal];
        isPlay = YES;
    }
//    }
    if (spotsTableView.frame.origin.x == 0) {
        [myLocationManager startUpdatingHeading];
    } else {
        [myLocationManager stopUpdatingHeading];
    }
}
//根据定位的位置，寻找符合范围内的景点
- (POArticle *)theNeareastSpot
{
    POArticle *neareastSpot;
    if (_currentLocation) {
        CLLocationCoordinate2D tmpCoordinate =_currentLocation.coordinate;
#ifdef LT
        tmpCoordinate =[FCMapController offsetCoordinate:_currentLocation.coordinate];
#endif
        NSString * primaryID;
        for (KMLPlacemark * placeMark in kmlParser.marks) {
            if ([((KMLPolygon *)placeMark.geometry) pointinPolygon:tmpCoordinate]) {
                primaryID = placeMark.name;
                break;
            }
        }
        
        for (POArticle *spot in spots) {
            if ([[spot.primaryid stringValue] isEqual: primaryID]) {
                neareastSpot = spot;
            }
        }
    }
    return neareastSpot;
}

- (NSArray *)getNearSpots:(POArticle *) exceptSpot{
    NSMutableArray *nearSpots = [[NSMutableArray alloc] init];
    NSMutableArray *tmpSpots = [[NSMutableArray alloc] initWithArray: spots];
    if (exceptSpot) {
        for (POArticle *spot in tmpSpots) {
            if ([spot.primaryid isEqual:exceptSpot.primaryid]) {
                [tmpSpots removeObject:spot];
                break;
            }
        }
    }
    
    for (int i = 0; i < numOfOtherSpot; i++) {
        POArticle *spot = [self getNeareastSpots:tmpSpots];
        if (spot) {
            [nearSpots addObject:spot];
        }
    }
    
    return nearSpots;
}

- (POArticle *)getNeareastSpots:(NSMutableArray *) tmpArray{
    POArticle *neareastSpot;
    double minDistance = minDistance_;
    if (_currentLocation) {
        CLLocationCoordinate2D mylocation = [FCMapController offsetCoordinate:_currentLocation.coordinate];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mylocation.latitude longitude:mylocation.longitude];
        for (POArticle *spot in tmpArray) {
            CLLocation *spotLocation =  [[CLLocation alloc] initWithLatitude:spot.positionx longitude: spot.positiony];
            double distance = [location distanceFromLocation:spotLocation];
            if (distance < minDistance) {
                minDistance = distance;
                neareastSpot = spot;
            }
            spotLocation = nil;
        }
    }
    if (neareastSpot) {
        [tmpArray removeObject:neareastSpot];
    }
    return neareastSpot;
}

- (void)showSpot:(POArticle *)spot
{
    chineseName.text = spot.remark;
    englishName.text = spot.title;
    spotImage.image = [UIImage imageNamed:spot.imagename];
    [self initView];
}

- (double) getAngle:(CLLocationCoordinate2D) myLocation spot:(CLLocationCoordinate2D) spotLocation
{
    CLLocationCoordinate2D newLocation = myLocation;
#ifdef SP_VERSION
    newLocation = [FCMapController offsetCoordinate:myLocation];
#endif
#ifdef Yu
    newLocation = [FCMapController offsetCoordinate:myLocation];
#endif
#ifdef LT
    newLocation = [FCMapController offsetCoordinate:myLocation];
#endif
    double offsetLongitude = spotLocation.longitude - newLocation.longitude;
    double offsetLatitude = spotLocation.latitude - newLocation.latitude;
    
    double relatedAngle = atan(offsetLongitude/offsetLatitude);
    if (offsetLatitude < 0) {
        if (relatedAngle > 0) {
            relatedAngle = 180 -relatedAngle;
        } else {
            relatedAngle = -(180 + relatedAngle);
        }
        
    }
    return relatedAngle;
}

- (void)showTime {
    if (!appDelegate.audioPlayer || !currentTimeLabel) {
        return;
    }
    
    
    
    //动态更新进度条时间
    //    if ((int)audioPlayer.currentTime % 60 < 10) {
    //        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    //    } else {
    //        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    //    }
//    int leftSecond = appDelegate.audioPlayer.duration - appDelegate.audioPlayer.currentTime;
    int leftSecond = appDelegate.audioPlayer.currentTime;
    if ((int)leftSecond % 60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",leftSecond / 60, leftSecond % 60];
    } else {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",leftSecond / 60, leftSecond % 60];
    }
    //
    if ((int)appDelegate.audioPlayer.duration % 60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)appDelegate.audioPlayer.duration / 60, (int)appDelegate.audioPlayer.duration % 60];
    } else {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)appDelegate.audioPlayer.duration / 60, (int)appDelegate.audioPlayer.duration % 60];
    }
    progressSlider.value = appDelegate.audioPlayer.currentTime / appDelegate.audioPlayer.duration;
    
    
    if (isPlay) {
        [timer setFireDate:[NSDate distantFuture]];
    }
    //如果播放完，调用自动播放下一首
    //    if (progressSlider.value > 0.999) {
    //        [self nextVoice: nil];
    //    }
    
    //    NSLog(@"%f",audioPlayer.volume);
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
        UIViewController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
        [self.navigationController pushViewController:childController animated:YES];
    }
    if (buttonIndex == 0) {
        if (currentSpot) {
            [self showSpot:currentSpot];
        }
    }
}

@end
