//
//  RoutsMapVC.h
//  iGuidFC
//
//  Created by dampier on 14-4-8.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PopoverView.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface RoutsMapVC : UIViewController<GMSMapViewDelegate ,PopoverViewDelegate, CLLocationManagerDelegate>
@property  (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property double x;
@property double y;
//@property FCMapInfoWindow2 *butomView;
//外部被选中的spot index
@property NSNumber *selectedSpotIndex;

@property int lineNo;
-(IBAction)switchAction:(id)sender;

- (void)play;
@end
