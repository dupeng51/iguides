//
//  ELLocation.m
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELLocation.h"

@implementation ELLocation

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"sizeType", @"SizeType",
            @"waterMark", @"WaterMark",
            @"url", @"Url",
            nil];
}

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"sizeType", @"_Size",
            @"waterMark", @"_WaterMark",
            @"url", @"__text",
            nil];
}

@end
