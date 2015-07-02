//
//  ELongHotelXML.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongServiceRank.h"
#import "ELongFacilitiesV2.h"
#import "ELongSupplier.h"

@interface ELongHotelXML : NSObject

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Address;
@property (nonatomic, retain) NSString * PostalCode;
@property (nonatomic, retain) NSNumber * StarRate;
@property (nonatomic, retain) NSNumber * Category;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * Fax;
@property (nonatomic, retain) NSString * EstablishmentDate;
@property (nonatomic, retain) NSString * GroupId;
@property (nonatomic, retain) NSString * BrandId;
@property (nonatomic, retain) NSString * IsEconomic;
@property (nonatomic, retain) NSString * IsApartment;
@property (nonatomic, retain) NSNumber * GoogleLat;
@property (nonatomic, retain) NSNumber * GoogleLon;
@property (nonatomic, retain) NSNumber * BaiduLat;
@property (nonatomic, retain) NSNumber * BaiduLon;
@property (nonatomic, retain) NSString * CityId;
@property (nonatomic, retain) NSString * BusinessZone;
@property (nonatomic, retain) NSString * District;
@property (nonatomic, retain) NSString * CreditCards;
@property (nonatomic, retain) NSString * IntroEditor;
@property (nonatomic, retain) NSString * GeneralAmenities;
@property (nonatomic, retain) NSString * ConferenceAmenities;
@property (nonatomic, retain) NSString * DiningAmenities;
@property (nonatomic, retain) NSString * Traffic;
@property (nonatomic, retain) NSString * Facilities;
@property (nonatomic, retain) ELongSupplier * Suppliers;
@property (nonatomic, retain) ELongServiceRank * ServiceRank;
@property (nonatomic, retain) NSString * HasCoupon;
@property (nonatomic, retain) ELongFacilitiesV2 * FacilitiesV2;
@property (nonatomic, retain) NSString * Themes;

+(NSDictionary *) mapedXMLObject;

@end
