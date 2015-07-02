//
//  ELongHotelXML.m
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongHotelXML.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELongHotelXML

+(NSDictionary *) mapedXMLObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Name", @"Name",
            @"Address", @"Address",
            @"PostalCode", @"PostalCode",
            @"StarRate", @"StarRate",
            @"Category", @"Category",
            @"Phone", @"Phone",
            @"Fax", @"Fax",
            @"EstablishmentDate", @"EstablishmentDate",
            @"GroupId", @"GroupId",
            @"BrandId", @"BrandId",
            @"IsEconomic", @"IsEconomic",
            @"IsApartment", @"IsApartment",
            @"GoogleLat", @"GoogleLat",
            @"GoogleLon", @"GoogleLon",
            @"BaiduLat", @"BaiduLat",
            @"BaiduLon", @"BaiduLon",
            @"CityId", @"CityId",
            @"BusinessZone", @"BusinessZone",
            @"District", @"District",
            @"CreditCards", @"CreditCards",
            @"IntroEditor", @"IntroEditor",
            @"GeneralAmenities", @"GeneralAmenities",
            @"ConferenceAmenities", @"ConferenceAmenities",
            @"DiningAmenities", @"DiningAmenities",
            @"Traffic", @"Traffic",
            @"Facilities", @"Facilities",
            [ELongSupplier mappingWithKey:@"Suppliers" mapping:[ELongSupplier mapedXMLObject]], @"Suppliers.Supplier",
            [ELongServiceRank mappingWithKey:@"ServiceRank" mapping:[ELongServiceRank mapedXMLObject]], @"ServiceRank",
            @"HasCoupon", @"HasCoupon",
            [ELongFacilitiesV2 mappingWithKey:@"FacilitiesV2" mapping:[ELongFacilitiesV2 mapedXMLObject]], @"FacilitiesV2",
            @"Themes", @"Themes",
            
            nil];
}

@end
