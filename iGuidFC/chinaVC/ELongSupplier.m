//
//  ELongSupplier.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongSupplier.h"

@implementation ELongSupplier

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"WeekendStart", @"_WeekendStart",
            @"WeekendEnd", @"_WeekendEnd",
            @"InstantRoomTypes", @"_InstantRoomTypes",
            @"ID", @"_ID",
            @"HotelCode", @"_HotelCode",
            @"Status", @"_Status",
            nil];
}

@end
