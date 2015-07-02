//
//  FlightsVC.h
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkySession.h"
#import "QueryModel.h"
#import "Itinerary.h"

typedef enum {
    SORTTYPE_PRICE = 1,
    SORTTYPE_DURATION,
    SORTTYPE_TAKEOFFTIME,
    SORTTYPE_LANDINGTIME
} SORTTYPE;

@protocol FlightsVCDelegation <NSObject>

@optional
- (void)didSelectItinerary:(Itinerary *) itinerary;
-(void) beginLoadingAnimation;
-(void) endLoadingAnimation;

@end

@interface FlightsVC : UITableViewController<SkySessionDelegation>

@property id<FlightsVCDelegation> delegate;
@property int stopcount;

-(void) initDataWithSortString:(SORTTYPE) sortType return:(BOOL) isReturn session:(SkySession *) session limited:(NSArray *) itinerarys;

-(void) activeView;
-(void) setLimitedOutItinerarys:(NSArray *) limitedItinerarys;
-(void) setLimitedInItinerarys:(NSArray *) limitedItinerarys;

+(void) drawItinarery:(UIView *) contentView itinerary:(Itinerary *) itinerary;

@end
