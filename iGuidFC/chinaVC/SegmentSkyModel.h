//
//  SegmentSkyModel.h
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carriers.h"
#import "Station.h"

@interface SegmentSkyModel : NSObject

@property (nonatomic, retain) NSString * arrivalDateTime;
@property (nonatomic, retain) NSNumber * carrier;
@property (nonatomic, retain) NSString * departureDateTime;
@property (nonatomic, retain) NSNumber * destinationStation;
@property (nonatomic, retain) NSString * directionality;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * flightNumber;
@property (nonatomic, retain) NSNumber * idString;
@property (nonatomic, retain) NSString * journeyMode;
@property (nonatomic, retain) NSNumber * operatingCarrier;
@property (nonatomic, retain) NSNumber * originStation;

//object convert from id
@property (nonatomic, retain) Carriers * carrier_;
@property (nonatomic, retain) Carriers * operatingCarrier_;
@property (nonatomic, retain) Station * originStation_;
@property (nonatomic, retain) Station * destinationStation_;

-(NSString *) getFormatedDuration;
-(NSString *) getFormatedTime;
-(NSString *) getFormatedDepartureDate;

@end
