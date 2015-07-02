//
//  ELGuranteeRule.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELGuranteeRule.h"
#import "NSObject+JTObjectMapping.h"
#import "ELongSession.h"

@implementation ELGuranteeRule

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"guranteeRuleId", @"GuranteeRuleId",
            @"Description", @"Description",
            @"dateType", @"DateType",
            @"startDate", @"StartDate",
            @"endDate", @"EndDate",
            @"weekSet", @"WeekSet",
            @"isTimeGuarantee", @"IsTimeGuarantee",
            @"startTime", @"StartTime",
            @"endTime", @"EndTime",
            @"isTomorrow", @"IsTomorrow",
            @"isAmountGuarantee", @"IsAmountGuarantee",
            @"amount", @"Amount",
            @"guaranteeType", @"GuaranteeType",
            @"changeRule", @"ChangeRule",
            @"day", @"Day",
            @"time", @"Time",
            @"hour", @"Hour",
            nil];
}

-(BOOL) isGuarantee:(NSDate *) arriveDate departDate:(NSDate *) departDate
{
    NSDate *startDate = [ELongSession dateFromString:self.startDate];
    NSDate *endDate = [ELongSession dateFromString:self.endDate];
    
    //check weekset
    BOOL weekValidate = NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp = [calendar components:NSWeekdayCalendarUnit fromDate:arriveDate];
    NSArray *days = [self.weekSet componentsSeparatedByString:@","];
    for (NSString *day in days) {
        if ([day isEqualToString:[NSString stringWithFormat:@"%ld", (long)comp.weekday]]) {
            weekValidate = YES;
            break;
        }
    }
    
    if (weekValidate) {
        if ([self.dateType isEqualToString:@"CheckInDay"]) {
            if ([startDate compare:arriveDate]==NSOrderedAscending && [arriveDate compare:endDate] == NSOrderedAscending) {
                return true;
            }
        } else {
            if (!([startDate compare:departDate]==NSOrderedDescending || [endDate compare:arriveDate] == NSOrderedAscending)) {
                return true;
            }
        }
    }
    
    return false;
}

@end
