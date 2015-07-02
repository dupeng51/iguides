//
//  QuerySkyModel.h
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencySkyModel.h"

@interface QuerySkyModel : NSObject

@property (nonatomic, retain) NSNumber * adults;
@property (nonatomic, retain) NSString * cabinClass;
@property (nonatomic, retain) NSNumber * children;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSNumber * destinationPlace;
@property (nonatomic, retain) NSNumber * groupPricing;
@property (nonatomic, retain) NSNumber * infants;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * locationSchema;
@property (nonatomic, retain) NSNumber * originPlace;
@property (nonatomic, retain) NSString * outboundDate;
@property (nonatomic, retain) NSString * inboundDate;

@end
