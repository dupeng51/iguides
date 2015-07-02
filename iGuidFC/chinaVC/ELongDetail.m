//
//  ELongDetail.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongDetail.h"
#import "ELongReview.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELongDetail

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"hotelName", @"HotelName",
            @"starRate", @"StarRate",
            @"category", @"Category",
            @"latitude", @"Latitude",
            @"longitude", @"Longitude",
            @"address", @"Address",
            @"phone", @"Phone",
            @"thumbNailUrl", @"ThumbNailUrl",
            @"city", @"City",
            @"cityName", @"CityName",
            @"district", @"District",
            @"districtName", @"DistrictName",
            @"businessZone", @"BusinessZone",
            @"businessZoneName", @"BusinessZoneName",
            [ELongReview mappingWithKey:@"review" mapping:[ELongReview mapedObject]], @"Review",
            nil];
}

@end
