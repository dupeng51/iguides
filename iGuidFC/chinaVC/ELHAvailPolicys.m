//
//  ELHAvailPolicys.m
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELHAvailPolicys.h"

@implementation ELHAvailPolicys

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Id", @"Id",
            @"AvailPolicyText", @"AvailPolicyText",
            @"AvailPolicyStart", @"AvailPolicyStart",
            @"AvailPolicyEnd", @"AvailPolicyEnd",
            @"WeekSet", @"WeekSet",
            nil];
}
@end
