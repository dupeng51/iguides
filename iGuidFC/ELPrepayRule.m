//
//  ELPrepayRule.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELPrepayRule.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELPrepayRule

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"prepayRuleId", @"PrepayRuleId",
            @"Description", @"Description",
            @"dateType", @"DateType",
            @"startDate", @"StartDate",
            @"endDate", @"EndDate",
            @"weekSet", @"WeekSet",
            @"changeRule", @"ChangeRule",
            @"dateNum", @"DateNum",
            @"time", @"Time",
            @"deductFeesBefore", @"DeductFeesBefore",
            @"deductNumBefore", @"DeductNumBefore",
            @"cashScaleFirstAfter", @"CashScaleFirstAfter",
            @"deductFeesAfter", @"DeductFeesAfter",
            @"deductNumAfter", @"DeductNumAfter",
            @"cashScaleFirstBefore", @"CashScaleFirstBefore",
            @"hour", @"Hour",
            @"hour2", @"Hour2",
            nil];
}

@end
