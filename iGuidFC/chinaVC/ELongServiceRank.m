//
//  ELongServiceRank.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongServiceRank.h"

@implementation ELongServiceRank

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"BookingSuccessRate", @"_BookingSuccessRate",
            @"BookingSuccessScore", @"_BookingSuccessScore",
            @"ComplaintRate", @"_ComplaintRate",
            @"ComplaintScore", @"_ComplaintScore",
            @"InstantConfirmRate", @"_InstantConfirmRate",
            @"InstantConfirmScore", @"_InstantConfirmScore",
            @"SummaryRate", @"_SummaryRate",
            @"SummaryScore", @"_SummaryScore",
            nil];
}

@end
