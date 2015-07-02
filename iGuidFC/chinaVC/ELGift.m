//
//  ELGift.m
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELGift.h"

@implementation ELGift

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"GiftId", @"GiftId",
            @"StartDate", @"StartDate",
            @"EndDate", @"EndDate",
            @"DateType", @"DateType",
            @"WeekSet", @"WeekSet",
            @"GiftContent", @"GiftContent",
            @"GiftTypes", @"GiftTypes",
            @"HourNumber", @"HourNumber",
            @"HourType", @"HourType",
            @"WayOfGiving", @"WayOfGiving",
            @"WayOfGivingOther", @"WayOfGivingOther",
            @"Description",@"Description",
            nil];
}

@end
