//
//  FCSmartPlayingVC.h
//  iGuidFC
//
//  Created by dampier on 14-5-5.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "POArticle.h"

@interface FCSmartPlayingVC : UIViewController<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, AVAudioPlayerDelegate>

@property IBOutlet UIImageView *spotImage;

@property IBOutlet UILabel *englishName;
@property IBOutlet UILabel *chineseName;

@property IBOutlet UITableView *spotsTableView;

@property IBOutlet UIButton *playBtn;
@property IBOutlet UIButton *listBtn;
@property IBOutlet UIButton *mapBtn;

@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property BOOL isPlay;

@property POArticle *currentPlayingSpot;
@property POArticle *currentSpot;

-(IBAction)play:(id)sender;

- (IBAction)nearbyList:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *voiceTypeBtn;
- (IBAction)voiceTypeTaped:(id)sender;

@end
