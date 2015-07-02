//
//  ELValueAdd.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELValueAdd.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELValueAdd

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"valueAddId", @"ValueAddId",
            @"typeCode", @"TypeCode",
            @"Description", @"Description",
            @"isInclude", @"IsInclude",
            @"amount", @"Amount",
            @"currencyCode", @"CurrencyCode",
            @"priceOption", @"PriceOption",
            @"price", @"Price",
            @"isExtAdd", @"IsExtAdd",
            @"extOption", @"ExtOption",
            @"extPrice", @"ExtPrice",
            @"startDate", @"StartDate",
            @"endDate", @"EndDate",
            @"weekSet", @"WeekSet",
            nil];
}

@end
