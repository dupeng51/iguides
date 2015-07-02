//
//  ELProduct.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELProduct : NSObject

@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * roomId;
@property (nonatomic, retain) NSString * roomTypeId;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSNumber * ratePlanId;
@property (nonatomic, retain) NSString * ratePlanName;
@property (nonatomic, retain) NSString * paymentType;
@property (nonatomic, retain) NSNumber * breakfastAmount;
@property (nonatomic, retain) NSNumber * extraBreakfastPrice;
@property (nonatomic, retain) NSString * roomAmenityIds;
@property (nonatomic, retain) NSNumber * averageRate;
@property (nonatomic, retain) NSNumber * extraBedPrice;
@property (nonatomic, retain) NSNumber * averageBaseRate;
@property (nonatomic, retain) NSNumber * coupon;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSNumber * currentAlloment;
@property (nonatomic, retain) NSNumber * cancelRuleType;
@property (nonatomic, retain) NSString * latestCancelTime;
@property (nonatomic, retain) NSString * productTypes;
@property (nonatomic, retain) NSString * giftIds;
@property (nonatomic, retain) NSArray * nights;
@property (nonatomic, retain) NSString * status;

+(NSDictionary *) mapedObject;

@end
