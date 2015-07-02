//
//  Leg.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Station.h"

@interface Leg : NSObject

@property (nonatomic, retain) NSString * idString;
@property (nonatomic, retain) NSArray * segmentIds;
@property (nonatomic, retain) NSString * departure;
@property (nonatomic, retain) NSString * arrival;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * journeyMode;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSArray *operatingCarriers;
@property (nonatomic, retain) NSArray *carriers;
@property (nonatomic, retain) NSString * directionality;
@property (nonatomic, retain) NSArray * flightNumbers;
@property (nonatomic, retain) NSNumber *originStation;
@property (nonatomic, retain) NSNumber *destinationStation;

//object convert from id
@property (nonatomic, retain) NSArray * segments_;
@property (nonatomic, retain) NSArray * stops_;
@property (nonatomic, retain) NSArray * operatingCarriers_;
@property (nonatomic, retain) NSArray * carriers_;
@property (nonatomic, retain) Station * originStation_;
@property (nonatomic, retain) Station * destinationStation_;

-(NSString *) getFormatedTime;
-(NSString *) getFormatedDuration;
-(NSString *) getFormatedStartDate;

@end
