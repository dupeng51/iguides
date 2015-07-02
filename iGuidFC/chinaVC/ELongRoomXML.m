//
//  ELongRoomXML.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongRoomXML.h"

@implementation ELongRoomXML

+ (NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Id", @"_Id",
            @"Name", @"_Name",
            @"Area", @"_Area",
            @"Floor", @"_Floor",
            @"BroadnetAccess", @"_BroadnetAccess",
            @"BroadnetFee", @"_BroadnetFee",
            @"BedType", @"_BedType",
            @"Description", @"_Description",
            @"Comments", @"_Comments",
            @"Capacity", @"_Capacity",
            @"Facilities", @"_Facilities",
            nil];
}

- (NSString *) roomFacilitySummary
{
    NSString *summary = @"";
    // wifi
    if (self.BroadnetAccess.intValue == 1 && self.BroadnetFee.intValue ==0) {
        summary = [summary stringByAppendingString:@"Free Wi-Fi"];
    }
    // window, 代码为677
    NSArray *facilities = [self.Facilities componentsSeparatedByString:@","];
    for (NSString *facility in facilities) {
        if ([facility isEqualToString:@"677"]) {
            if (summary.length > 0) {
                summary = [summary stringByAppendingString:@", "];
            }
            summary = [summary stringByAppendingString:@"Window"];
            break;
        }
    }
    return summary;
}

@end
