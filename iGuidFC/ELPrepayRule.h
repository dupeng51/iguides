//
//  ELPrepayRule.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELPrepayRule : NSObject

@property (nonatomic, retain) NSNumber * prepayRuleId;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * dateType;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * weekSet;
@property (nonatomic, retain) NSString * changeRule;
@property (nonatomic, retain) NSString * dateNum;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * deductFeesBefore;
@property (nonatomic, retain) NSNumber * deductNumBefore;
@property (nonatomic, retain) NSString * cashScaleFirstAfter;
@property (nonatomic, retain) NSNumber * deductFeesAfter;
@property (nonatomic, retain) NSNumber * deductNumAfter;
@property (nonatomic, retain) NSString * cashScaleFirstBefore;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSNumber * hour2;

+(NSDictionary *) mapedObject;

@end
