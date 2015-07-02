//
//  ELExchangeRate.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELExchangeRate.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELExchangeRate

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"currencyCode", @"CurrencyCode",
            @"rate", @"Rate",
            nil];
}

@end
