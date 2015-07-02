//
//  GuideArea.m
//  iGuidFC
//
//  Created by dampier on 15/3/27.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "GuideArea.h"

#import "DaoArticle.h"
#import "POCity.h"
#import "POSpot.h"

@implementation GuideArea


- (id)initWithID:(NSString*) pid leavel:(int) leavel
{
    self = [super init];
    if (self) {
        self.PID = pid;
        self.leavel = leavel;
    }
    return self;
}

-(void) dealloc {
    _PID = nil;
}

-(void) setMarginLocation
{
    DaoArticle *dao = [[DaoArticle alloc] init];
    switch (self.leavel) {
    case AREALEAVEL_SUBSPOT:
    {
        POSpot *spot =  [[dao getAllSpotsWithSpotid:self.PID] objectAtIndex:0];
        self.NorthEast = CLLocationCoordinate2DMake(spot.north, spot.east);
        self.SouthWest = CLLocationCoordinate2DMake(spot.south, spot.west);
        break;
    }
    case AREALEAVEL_SPOT: {
        POCity *city =  [[dao getAllSpotsWithSpotid:self.PID] objectAtIndex:0];
        self.NorthEast = CLLocationCoordinate2DMake(city.north, city.east);
        self.SouthWest = CLLocationCoordinate2DMake(city.south, city.west);
        break;
    }
    case AREALEAVEL_CITY:
        {
//            self.NorthEast = nil;
//            self.SouthWest = nil;
        }
    default:
        break;
    }
}

@end
