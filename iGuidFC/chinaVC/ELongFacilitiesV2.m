//
//  ELongFacilitiesV2.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongFacilitiesV2.h"

@implementation ELongFacilitiesV2

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"GeneralAmenities", @"GeneralAmenities",
            @"RecreationAmenities", @"RecreationAmenities",
            @"ServiceAmenities", @"ServiceAmenities",
            nil];
}

@end
