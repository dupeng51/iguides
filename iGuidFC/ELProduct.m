//
//  ELProduct.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELProduct.h"
#import "NSObject+JTObjectMapping.h"
#import "ELNightlyRateWithBreakfast.h"

@implementation ELProduct

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"roomId", @"RoomId",
            @"roomTypeId", @"RoomTypeId",
            @"roomName", @"RoomName",
            @"ratePlanId", @"RatePlanId",
            @"ratePlanName", @"RatePlanName",
            @"paymentType", @"PaymentType",
            @"breakfastAmount", @"BreakfastAmount",
            @"extraBreakfastPrice", @"ExtraBreakfastPrice",
            @"roomAmenityIds", @"RoomAmenityIds",
            @"averageRate", @"AverageRate",
            @"extraBedPrice", @"ExtraBedPrice",
            @"averageBaseRate", @"AverageBaseRate",
            @"coupon", @"Coupon",
            @"currencyCode", @"CurrencyCode",
            @"currentAlloment", @"CurrentAlloment",
            @"cancelRuleType", @"CancelRuleType",
            @"latestCancelTime", @"LatestCancelTime",
            @"productTypes", @"ProductTypes",
            @"giftIds", @"GiftIds",
            [ELNightlyRateWithBreakfast mappingWithKey:@"nights" mapping:[ELNightlyRateWithBreakfast mapedObject]], @"Nights",
            @"status", @"Status",
            nil];
}

@end
