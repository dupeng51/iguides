//
//  AllFlightsVC.h
//  iGuidFC
//
//  Created by dampier on 15/4/21.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkySession.h"
#import "QueryModel.h"
#import "FlightsVC.h"

@interface AllFlightsVC : UIViewController<FlightsVCDelegation, SkySessionDelegation>

@property (retain, strong) NSArray *allItinerarys;
@property int stopcount;

@property IBOutlet UIView *outBoundView;

-(void) initData:(QueryModel *) searchParams isReturn:(BOOL) isReturn itinerary:(Itinerary *) itinerary limitedItinerarys:(NSArray *) limitedItinerarys allsession:(SkySession *) allSession;

+ (NSDictionary *) getParams:(QueryModel *) query isReturn:(BOOL) isReturn isALL:(BOOL) roundWay;

@end
