//
//  GuideArea.h
//  iGuidFC
//
//  Created by dampier on 15/3/27.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    AREALEAVEL_SUBSPOT = 1,
    AREALEAVEL_SPOT,
    AREALEAVEL_CITY
} AREA_LEAVEL;

@interface GuideArea : NSObject

@property int leavel;
@property (nonatomic, strong) NSString *PID;

@property (nonatomic) CLLocationCoordinate2D NorthEast;
@property (nonatomic) CLLocationCoordinate2D SouthWest;

-(void) setMarginLocation;

- (id)initWithID:(NSString*) pid leavel:(int) leavel;

@end
