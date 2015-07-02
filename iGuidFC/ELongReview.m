//
//  ELongReview.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongReview.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELongReview

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"good", @"Good",
            @"poor", @"Poor",
            @"count", @"Count",
            @"score", @"Score",
            nil];
}

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"good", @"_Good",
            @"poor", @"_Poor",
            @"count", @"_Count",
            @"score", @"_Score",
            nil];
}

@end
