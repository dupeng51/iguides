//
//  MapVC.h
//  iGuidFC
//
//  Created by dampier on 15/3/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FCMapInfoWindow2.h"
#import "GuideArea.h"

@interface MapVC : UIViewController< CLLocationManagerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *citys;
@property (nonatomic, strong) NSArray *spots;
@property (nonatomic, strong) NSArray *subspots;

@property double x;
@property double y;
@property (nonatomic, strong) FCMapInfoWindow2 *butomView;
//外部被选中的spot index
@property (nonatomic, strong) NSNumber *selectedSpotIndex;
@property (nonatomic, strong) CLLocation *currentLocation;

@property int lineNo;

- (void)play;

- (void) highlightMarker:(NSInteger) index;

- (NSNumber *)getTheNeareastSpotIndex:(CLLocation *) mylocation exceptIndex:(int) exceptIndex;
-(void) showNearestSpot:(CLLocation *)location;

-(void) initData:(GuideArea *) guideArea;

+(CLLocationCoordinate2D) offsetCoordinate:(CLLocationCoordinate2D) position spotid:(NSString *) spotid;
+ (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations mapView:(MKMapView *) mapView;

@end
