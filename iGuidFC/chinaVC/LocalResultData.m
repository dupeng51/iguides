//
//  LocalResultData.m
//  iGuidFC
//
//  Created by dampier on 15/6/3.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "LocalResultData.h"

@implementation LocalResultData

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"code", @"code",
            @"msg", @"msg",
            @"username", @"username",
            @"email", @"email",
            nil];
}

@end
