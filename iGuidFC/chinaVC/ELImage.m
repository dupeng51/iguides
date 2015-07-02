//
//  ELImage.m
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELImage.h"
#import "ELLocation.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELImage

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"AuthorType", @"AuthorType",
            @"IsCoverImage", @"IsCoverImage",
            @"Type", @"Type",
            @"RoomId", @"RoomId",
            [ELLocation mappingWithKey:@"Locations" mapping:[ELLocation mapedObject]], @"Locations",
            nil];
}

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"AuthorType", @"AuthorType",
            @"IsCoverImage", @"IsCoverImage",
            @"Type", @"Type",
            @"RoomId", @"RoomId",
            [ELLocation mappingWithKey:@"Locations" mapping:[ELLocation mapedXMLObject]], @"Locations.Location",
            nil];
}

@end
