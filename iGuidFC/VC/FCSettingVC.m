//
//  FCSettingVC.m
//  SpecialFC
//
//  Created by dampier on 14-3-30.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FCSettingVC.h"
#import "AppDelegate.h"
#import "iRate.h"
#import "POArticle.h"
#import "POSection.h"
#import "DaoArticle.h"

@interface FCSettingVC ()

@end
#define APP_ID "856108271" //id from iTunesConnect

#define plistFileName @"guidesetting.plist"
#define keyVoiceVolume @"voicevolume"
#define keyPlayNearby @"playnearby"
#define keyMusic @"backgroundmusic"
#define keyMusicVolume @"musicvolume"
#define keyPlayNext @"playnext"
#define keySatellite @"satelite"
#define KeyMode @"playmode"
#define KeyFullVersion @"fullversion"
#define KeyVoiceType @"voicetype"

#define SUB_PRODUCT_ID @"com.suntrip.iGuidFC.fullVersion"
#ifdef SP_VERSION
#define SUB_PRODUCT_ID @"com.suntrip.iGuideSP.fullversion"
#endif

#define imageCyCle @"circle2.png"
#define imageRandom @"random2.png"
#define imageRepeat @"repeat2.png"

@implementation FCSettingVC
{
    EBPurchase* demoPurchase;
    BOOL isPurchased;
}

@synthesize _switchNext, _switchMusic, _switchNearby, _MusicSlider, _VoiceSlider, _satellite, modeBtn, upgradeBtn, voiceTypeSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    [self initView];
//    BOOL play_next = [[NSUserDefaults standardUserDefaults] boolForKey:@"play_next"];
//    [_switchNext setOn:play_next];
//    BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:@"background_music"];
//    [_switchMusic setOn:on];
//    [_switchNearby setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"play_nearby"]];
    // Create an instance of EBPurchase.
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;
    isPurchased = NO; // default.
}

- (void) dealloc
{
    _switchNext = nil;
    _switchMusic = nil;
    _switchNearby = nil;
    _MusicSlider = nil;
    _VoiceSlider = nil;
    _satellite = nil;
    modeBtn = nil;
    upgradeBtn = nil;
    demoPurchase.delegate = nil;
    demoPurchase = nil;
    voiceTypeSwitch = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    upgradeBtn.hidden = NO; // Only enable after populated with IAP price.
    if (![demoPurchase requestProduct:SUB_PRODUCT_ID])
    {
        UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Issue" message:@"Purchase Disabled in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [restoreAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)switchPlayNext:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    NSNumber *num = [NSNumber numberWithBool:((UISwitch *)sender).on];
    [dict setValue:num forKey:keyPlayNext];
    
    [dict writeToFile:path atomically:YES];
}

-(IBAction)switchPlayNearby:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithBool:((UISwitch *)sender).on];
    [dict setValue:num forKey:keyPlayNearby];
    
    [dict writeToFile:path atomically:YES];

    if (num.floatValue == 1.0) {
        NSString *alartString = @"Please make sure to turn on Location Service for this app while you are in the Forbidden City!";
#ifdef SP_VERSION
        alartString = @"Please make sure to turn on Location Service for this app while you are in the Summer Palace!";
#endif
#ifdef TH
        alartString = @"Please make sure to turn on Location Service for this app while you are in the Temple of Heaven!";
#endif
#ifdef Yu
        alartString = @"Please make sure to turn on Location Service for this app while you are in the Yu Garden!";
#endif
#ifdef LT
        alartString = @"Please make sure to turn on Location Service for this app while you are in the Lama Temple!";
#endif
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:alartString
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)switchPlayMusic:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithBool:((UISwitch *)sender).on];
    [dict setValue:num forKey:keyMusic];
    _MusicSlider.enabled = (num.intValue == 1);
    
    [dict writeToFile:path atomically:YES];

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundPlayer.isPlaying && (num.intValue != 1)) {
        [appDelegate.backgroundPlayer pause];
    }
    if (appDelegate.audioPlayer.isPlaying && (num.intValue == 1)) {
        [appDelegate.backgroundPlayer play];
    }
}

-(IBAction)changeVoiceVolume:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithFloat:((UISlider *)sender).value];
    [dict setValue:num forKey:keyVoiceVolume];
    NSLog(@"Voice Voilume %f", [num floatValue]);
    
    [dict writeToFile:path atomically:YES];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.audioPlayer.volume = [num floatValue];
}

-(IBAction)changeMusicVolume:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithFloat:((UISlider *)sender).value];
    [dict setValue:num forKey:keyMusicVolume];
    NSLog(@"Music Voilume %f", [num floatValue]);
    
    [dict writeToFile:path atomically:YES];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.backgroundPlayer.volume = [num floatValue];
}

-(IBAction)changeSatellite:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithFloat:((UISwitch *)sender).on];
    [dict setValue:num forKey:keySatellite];
    
    [dict writeToFile:path atomically:YES];
}

-(IBAction)switchMode:(id)sender
{
    float value = [FCSettingVC getfloatByKey:KeyMode];
    value ++;
    if (value == 3.0f) {
        value = 0.0f;
    }
    if (value == 0.0f) {
        [modeBtn setImage:[UIImage imageNamed:imageCyCle] forState:UIControlStateNormal];
    }
    if (value == 1.0f) {
        [modeBtn setImage:[UIImage imageNamed:imageRandom] forState:UIControlStateNormal];
    }
    if (value == 2.0f) {
        [modeBtn setImage:[UIImage imageNamed:imageRepeat] forState:UIControlStateNormal];
    }
    
    [FCSettingVC setKey:[NSNumber numberWithFloat:value] key:KeyMode];
}

-(IBAction)switchVoice:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *num = [NSNumber numberWithFloat:((UISwitch *)sender).on];
    [dict setValue:num forKey:KeyVoiceType];
    
    [dict writeToFile:path atomically:YES];
}

-(IBAction)rateSelf:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-forbidden-city/id856108271?mt=8";
#ifdef SP_VERSION
    iTunesLink = @"https://itunes.apple.com/us/app/iguide-summer-palace/id898181716";
#endif
#ifdef TH
    iTunesLink = @"https://itunes.apple.com/us/app/iguide-temple-of-heaven/id923892964";
#endif
#ifdef Yu
    iTunesLink = @"https://itunes.apple.com/us/app/iguide-yu-garden/id931802054";
#endif
#ifdef LT
    iTunesLink = @"https://itunes.apple.com/us/app/iguide-lama-temple/id944119184";
#endif
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

-(IBAction)upgradeApp:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Full Version"
                                                    message:@"Upgrade to Full Version with all audio guide and no limited function."
                                                   delegate:self
                                          cancelButtonTitle:@"Restore"
                                          otherButtonTitles:@"Purchase",
                          nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1) {
        return;
    }
    if (buttonIndex == 1) {
        if ([FCSettingVC getfloatByKey:KeyFullVersion] == 1) {
            NSLog(@"It's already full version!");
        } else {
            
            
                if (demoPurchase.validProduct != nil)
                {
                    // Then, call the purchase method.
                    
                    if (![demoPurchase purchaseProduct:demoPurchase.validProduct])
                    {
                        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
                        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [settingsAlert show];
                    }
                }
        }
    }
    if (buttonIndex == 0) {
        if (![demoPurchase restorePurchase])
        {
            NSLog(@"Restore Purchase");
        }
    }
}

- (void) openAppStore
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-forbidden-city/id856108271?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    NSLog(@"打开appStore");
}

//-(IBAction)rateApp:(id)sender
//{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",APP_ID];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
//    } else {
//        NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APP_ID];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
//    }
//}

#pragma mark - methods
-(void) initView
{
    //从Document目录读取数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    // Find out the path of recipes.plist
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"guidesetting" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    float play_next = [[dict objectForKey:keyPlayNext] floatValue];
    [_switchNext setOn:play_next];
    float on = [[dict objectForKey:keyMusic] floatValue];
    [_switchMusic setOn:on];
    _MusicSlider.enabled = (on == 1);
    
    [_switchNearby setOn:[[dict objectForKey:keyPlayNearby] floatValue]];
    
    [_MusicSlider setValue:[[dict objectForKey:keyMusicVolume] floatValue]];
    [_VoiceSlider setValue:[[dict objectForKey:keyVoiceVolume] floatValue]];
    [_satellite setOn:[[dict objectForKey:keySatellite] floatValue]];
    
    [voiceTypeSwitch setOn:[[dict objectForKey:KeyVoiceType] floatValue]];
    
    if ([[dict objectForKey:KeyMode] intValue] == 0) {
        modeBtn.imageView.image = [UIImage imageNamed:imageCyCle];
    }
    if ([[dict objectForKey:KeyMode] intValue] == 1) {
        modeBtn.imageView.image = [UIImage imageNamed:imageRandom];
    }
    if ([[dict objectForKey:KeyMode] intValue] == 2) {
        modeBtn.imageView.image = [UIImage imageNamed:imageRepeat];
    }
    if ([[dict objectForKey:KeyFullVersion] intValue] == 1) {
        upgradeBtn.enabled = NO;
        [upgradeBtn setTitle:@"Full Version" forState:UIControlStateNormal];
        [upgradeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
+ (float) getfloatByKey:(NSString *) key
{
    float result = 0;
    //从Document目录读取数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    // Find out the path of recipes.plist
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"guidesetting" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    result = [[dict objectForKey:key] floatValue];

    return result;
}

+ (void) setKey:(NSNumber *) value key:(NSString *) key
{
    //从Document目录读取数据
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    // Find out the path of recipes.plist
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"guidesetting" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [dict setValue:value forKey:key];
    [dict writeToFile:path atomically:YES];
}

+(void) setSmartGuide
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    
    // Load the file content and read the data into arrays
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSNumber *yes = [NSNumber numberWithInt:1];
    NSNumber *no = [NSNumber numberWithInt:0];
    [dict setValue:no forKey:keyPlayNext];
    [dict setValue:yes forKey:keyPlayNearby];
    [dict setValue:yes forKey:keyMusic];
    
    [dict writeToFile:path atomically:YES];
}

#pragma mark EBPurchaseDelegate Methods

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    if (productPrice != nil)
    {
        
        
    } else {
        
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!isPurchased)
    {
        // If paid status has not yet changed, then do so now. Checking
        // isPurchased boolean ensures user is only shown Thank You message
        // once even if multiple transaction receipts are successfully
        // processed (such as past subscription renewals).
        
        isPurchased = YES;
        
        //-------------------------------------
        
        // 1 - Unlock the purchased content and update the app's stored settings.
        [FCSettingVC setKey:[NSNumber numberWithInt:1] key:KeyFullVersion];
        upgradeBtn.enabled = NO;
        [upgradeBtn setTitle:@"Full Version" forState:UIControlStateNormal];
        [upgradeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //-------------------------------------
        
        // 2 - Notify the user that the transaction was successful.
        
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Your purhase was successful and it's avilable for full version, enjoy it!." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
    }
    
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

-(void) incompleteRestore:(EBPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}
/*
- (NSNumber *)getVoiceStarttime:(BOOL) male {
    NSNumber *result;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer.isPlaying && appDelegate.audioPlayer.currentTime > 0) {
        NSArray *spots = [[DaoArticle alloc] findAllSpotsByLineNo:0];
        POArticle *spot = [spots objectAtIndex:appDelegate.currentPlayingIndex];
        NSNumber *pid = spot.primaryid;
        NSArray *sections = [[DaoArticle alloc] findAllArticleSectionsByID:pid];
        for (POSection *section in sections) {
            if (section.starttime && !(section.endtime)) {
                if (appDelegate.audioPlayer.currentTime > [section.starttime doubleValue]) {
                    if (male) {
                        result = section.starttime;
                    } else {
                        result = section.starttime1;
                    }
                    //切换声音文件
                    
                    break;
                }
            } else if (section.starttime && section.endtime) {
                if (appDelegate.audioPlayer.currentTime > [section.starttime doubleValue] && appDelegate.audioPlayer.currentTime < [section.endtime doubleValue]) {
                    if (male) {
                        result = section.starttime;
                    } else {
                        result = section.starttime1;
                    }
                    break;
                }
            }
        }
    }
    return result;
}
*/
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

@end
