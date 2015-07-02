//
//  SkySession.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flights.h"
#import "Agents.h"
#import "QuerySkyModel.h"
#import "SegmentSkyModel.h"
#import "CurrencySkyModel.h"
#import "Leg.h"
#import "BookOptionsSkyModel.h"
#import "BookItemSkyModel.h"
#import "BookOptionSkyModel.h"

@protocol SkySessionDelegation <NSObject>

@optional
- (void)sessionCreated;
- (void)returnItinerarys:(NSArray *)itinerarys pageIndex:(int) index;

@end

@protocol BookDelegation <NSObject>

@optional

- (void)bookSessionCreated;
- (void)returnBooks:(NSArray *) books;

@end

typedef enum {
    SESSIONSTATUS_NOTCREATE =1,
    SESSIONSTATUS_CREATING,
    SESSIONSTATUS_CREATED,
    SESSIONSTATUS_SEARCHING,
    SESSIONSTATUS_SEARCHED,
    
    SESSIONSTATUS_BOOKCREATING,
    SESSIONSTATUS_BOOKCREATED,
    SESSIONSTATUS_BOOKSEARCHING,
    SESSIONSTATUS_BOOKSEARCHED
} SESSIONSTATUS;

@interface SkySession : NSObject

@property id<SkySessionDelegation> delegate;
@property id<BookDelegation> bookDelegate;

@property (retain, strong) Flights * flights;

@property (readonly) SESSIONSTATUS status;

-(Agents *) getAgentByID:(NSNumber *) agentid;
-(Leg *) getLegByLegid:(NSString *) legid;
-(Station *) getStationByID:(NSNumber *) stationid;
-(Carriers *) getCarrierByID:(NSNumber *) carrierid;
-(SegmentSkyModel *) getSegmentByID:(NSNumber *) segmentid;
-(CurrencySkyModel *) getCurrency;
-(Station *) getCityByID:(NSNumber *) stationid;

-(NSString *) getFormatedDate:(NSString *) dateString;

-(NSString *) getQuerySortTypeName;

- (instancetype)initWithParams:(NSDictionary *) params;
-(void) searchItinerariesWithSortType:(NSString *) sortName page:(int) pageIndex stops:(int) stopcount;

//book
-(void) createBookSession:(NSDictionary *) params;
-(void) pollBookSession;

@end
