//
//  ELongHotelData.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongHotelData.h"
#import "NSObject+JTObjectMapping.h"
#import "ELongRoomXML.h"
#import "ELImage.h"

@implementation ELongHotelData

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Id", @"_Id",
            [ELongHotelXML mappingWithKey:@"Detail" mapping:[ELongHotelXML mapedXMLObject]], @"Detail",
            [ELongRoomXML mappingWithKey:@"Rooms" mapping:[ELongRoomXML mapedXMLObject]], @"Rooms.Room",
            [ELImage mappingWithKey:@"Images" mapping:[ELImage mapedXMLObject]], @"Images.Image",
            [ELongReview mappingWithKey:@"Review" mapping:[ELongReview mapedXMLObject]], @"Review",
            nil];
}

@end
