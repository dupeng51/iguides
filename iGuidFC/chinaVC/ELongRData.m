//
//  ELongRData.m
//  iGuidFC
//
//  Created by dampier on 15/5/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongRData.h"
#import "ELongResult.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELongRData

- (void)dealloc
{
    _code = nil;
    _result = nil;
}

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
     @"code", @"Code",
     [ELongResult mappingWithKey:@"result" mapping:[ELongResult mapedObject]], @"Result",
     nil];
}

@end
