//
//  Flights.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuerySkyModel.h"

@interface Flights : NSObject

@property (nonatomic, retain) NSArray * itinerarys;
@property (nonatomic, retain) NSArray * agents;
@property (nonatomic, retain) NSArray * carriers;
@property (nonatomic, retain) NSArray * currencies;
@property (nonatomic, retain) NSArray * legs;
@property (nonatomic, retain) NSArray * places;
@property (nonatomic, retain) QuerySkyModel * query;
@property (nonatomic, retain) NSArray * segments;
@property (nonatomic, retain) NSString * sessionKey;
@property (nonatomic, retain) NSString * status;


@end
