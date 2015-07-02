//
//  ELGuranteeRule.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GUARANTEETYPE_NONEED =1,
    GUARANTEETYPE_TIME,
    GUARANTEETYPE_ROOM,
    GUARANTEETYPE_NOCONDITION
} GUARANTEETYPE;


@interface ELGuranteeRule : NSObject

@property (nonatomic, retain) NSNumber * guranteeRuleId;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * dateType;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * weekSet;
@property  Boolean isTimeGuarantee;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSNumber * isTomorrow;
@property (nonatomic, retain) NSNumber * isAmountGuarantee;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * guaranteeType;
@property (nonatomic, retain) NSString * changeRule;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * hour;

+ (NSDictionary *) mapedObject;
-(BOOL) isGuarantee:(NSDate *) arriveDate departDate:(NSDate *) departDate;

@end
