//
//  ShopMapVC.h
//  iGuidFC
//
//  Created by dampier on 14-10-5.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PopoverView.h"
#import <AVFoundation/AVFoundation.h>
#import "FCMapInfoWindow2.h"

@interface ShopMapVC : UIViewController<GMSMapViewDelegate ,PopoverViewDelegate, CLLocationManagerDelegate>
//@property  (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property double x;
@property double y;
@property FCMapInfoWindow2 *butomView;
//外部被选中的spot index
@property NSNumber *selectedSpotIndex;
@property CLLocation *_currentLocation;

@property int lineNo;
-(IBAction)switchAction:(id)sender;

- (void)play;

- (void) highlightMarker:(NSInteger) index;

- (NSNumber *)getTheNeareastSpotIndex:(CLLocation *) mylocation exceptIndex:(int) exceptIndex;
-(void) showNearestSpot:(CLLocation *)location;

-(void) dismissPop;

+(BOOL)isAbsolutOut:(CLLocationCoordinate2D) position;
+(CLLocationCoordinate2D) offsetCoordinate:(CLLocationCoordinate2D) position;

- (void)popoverViewDidDismiss:(PopoverView *)popoverView;

@end
