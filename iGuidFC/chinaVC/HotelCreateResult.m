//
//  HotelCreateResult.m
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelCreateResult.h"

@implementation HotelCreateResult

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"OrderId", @"OrderId",
            @"CancelTime", @"CancelTime",
            @"GuaranteeAmount", @"GuaranteeAmount",
            @"CurrencyCode", @"CurrencyCode",
            nil];
}

@end
