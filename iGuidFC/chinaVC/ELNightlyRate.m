//
//  ELNightlyRate.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELNightlyRate.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELNightlyRate

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"date", @"Date",
            @"member", @"Member",
            @"cost", @"Cost",
            @"status", @"Status",
            @"addBed", @"AddBed",
            nil];
}

@end
