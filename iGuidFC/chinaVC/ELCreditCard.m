//
//  ELCreditCard.m
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELCreditCard.h"

@implementation ELCreditCard

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Number", @"Number",
            @"ProcessType", @"ProcessType",
            @"Status", @"Status",
            @"Amount", @"Amount",
            nil];
}

@end
