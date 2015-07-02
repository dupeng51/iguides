//
//  ELongDetail.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongReview.h"

@interface ELongDetail : NSObject

@property (nonatomic, retain) NSString * hotelName;

@property (nonatomic, retain) NSNumber * starRate;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * thumbNailUrl;
@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * districtName;
@property (nonatomic, retain) NSString * businessZone;
@property (nonatomic, retain) NSString * businessZoneName;
@property (nonatomic, retain) ELongReview * review;

+(NSDictionary *) mapedObject;

@end
