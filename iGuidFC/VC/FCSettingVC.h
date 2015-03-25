//
//  FCSettingVC.h
//  SpecialFC
//
//  Created by dampier on 14-3-30.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBPurchase.h"

@interface FCSettingVC : UITableViewController<EBPurchaseDelegate>

-(IBAction)switchPlayNext:(id)sender;
@property (nonatomic,retain) IBOutlet UISwitch *_switchNext;

-(IBAction)switchPlayNearby:(id)sender;
@property (nonatomic,retain) IBOutlet UISwitch *_switchNearby;

-(IBAction)switchPlayMusic:(id)sender;
@property (nonatomic,retain) IBOutlet UISwitch *_switchMusic;


-(IBAction)changeVoiceVolume:(id)sender;
@property IBOutlet UISlider *_VoiceSlider;

-(IBAction)changeMusicVolume:(id)sender;
@property IBOutlet UISlider *_MusicSlider;


-(IBAction)changeSatellite:(id)sender;
@property IBOutlet UISwitch *_satellite;


-(IBAction)switchMode:(id)sender;
@property IBOutlet UIButton *modeBtn;

-(IBAction)switchVoice:(id)sender;
@property IBOutlet UISwitch *voiceTypeSwitch;


-(IBAction)rateSelf:(id)sender;

@property IBOutlet UIButton *upgradeBtn;
-(IBAction)upgradeApp:(id)sender;

+(void) setSmartGuide;

+ (float) getfloatByKey:(NSString *) key;
+ (void) setKey:(NSNumber *) value key:(NSString *) key;
@end
