//
//  ELRoom.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELRoom.h"
#import "NSObject+JTObjectMapping.h"
#import "ELRatePlan.h"
#import "ELongSession.h"

@implementation ELRoom

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"roomTypeId", @"RoomTypeId",
            @"roomId", @"RoomId",
            @"name", @"Name",
            [ELRatePlan mappingWithKey:@"ratePlans" mapping:[ELRatePlan mapedObject]]
            , @"RatePlans",
            @"Description", @"Description",
            @"ImageUrl", @"ImageUrl",
            @"Floor", @"Floor",
            @"Broadnet", @"Broadnet",
            @"BedType", @"BedType",
            @"BedDesc", @"BedDesc",
            @"Comments", @"Comments",
            @"Area", @"Area",
            @"Capcity", @"Capcity",
            nil];
}

- (NSString *) lowestPrice
{
    int price = ((ELRatePlan *)self.ratePlans[0]).totalRate.intValue;
    NSString * currencyCode = ((ELRatePlan *)self.ratePlans[0]).currencyCode;
    for (ELRatePlan *ratePlan in self.ratePlans) {
        if (ratePlan.averageRate.intValue < price) {
            price = ratePlan.averageRate.intValue;
        }
    }
    NSString *lowestPrice = [NSString stringWithFormat:@"%@%d", [ELongSession currencyWithCode:currencyCode], price];
    return lowestPrice;
}

@end
