//
//  ELNightlyRateWithBreakfast.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELNightlyRateWithBreakfast : NSObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * member;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * addBed;
@property (nonatomic, retain) NSNumber * breakfastAmount;
@property (nonatomic, retain) NSNumber * extraBreakfastPrice;

+(NSDictionary *) mapedObject;

@end
