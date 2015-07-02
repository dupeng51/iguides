//
//  ELongBookingRule.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongBookingRule.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELongBookingRule

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"typeCode", @"TypeCode",
            @"bookingRuleId", @"BookingRuleId",
            @"Description", @"Description",
            @"dateType", @"DateType",
            @"startDate", @"StartDate",
            @"endDate", @"EndDate",
            @"startHour", @"StartHour",
            @"endHour", @"EndHour",
            nil];
}

- (BOOL) needPhoneNo
{
    if ([self.typeCode isEqualToString:@"NeedPhoneNo"]) {
        return YES;
    }
    return NO;
}

@end
