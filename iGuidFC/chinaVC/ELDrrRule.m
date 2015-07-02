//
//  ELDrrRule.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELDrrRule.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELDrrRule


+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"drrRuleId", @"DrrRuleId",
            @"typeCode", @"TypeCode",
            @"Description", @"Description",
            @"dateType", @"DateType",
            @"startDate", @"StartDate",
            @"endDate", @"EndDate",
            @"dayNum", @"DayNum",
            @"checkInNum", @"CheckInNum",
            @"everyCheckInNum", @"EveryCheckInNum",
            @"lastDayNum", @"LastDayNum",
            @"whichDayNum", @"WhichDayNum",
            @"cashScale", @"CashScale",
            @"deductNum", @"DeductNum",
            @"weekSet", @"WeekSet",
            @"feeType", @"FeeType",
            nil];
}

@end
