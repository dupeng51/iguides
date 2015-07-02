//
//  ELRatePlan.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongHotel.h"

@interface ELRatePlan : NSObject

@property (nonatomic, retain) NSNumber * ratePlanId;
@property (nonatomic, retain) NSString * ratePlanName;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * roomTypeId;
@property (nonatomic, retain) NSString * suffixName;
@property (nonatomic, retain) NSString * hotelCode;
@property (nonatomic, retain) NSString * customerType;
@property (nonatomic, retain) NSNumber * currentAlloment;
@property (nonatomic, retain) NSString * instantConfirmation;
@property (nonatomic, retain) NSString * paymentType;
@property (nonatomic, retain) NSNumber * bookingRuleIds;
@property (nonatomic, retain) NSNumber * guaranteeRuleIds;
@property (nonatomic, retain) NSString * prepayRuleIds;
@property (nonatomic, retain) NSString * drrRuleIds;
@property (nonatomic, retain) NSString * valueAddIds;
@property (nonatomic, retain) NSString * GiftIds;
@property (nonatomic, retain) NSString * HAvailPolicyIds;
@property (nonatomic, retain) NSString * productTypes;
@property (nonatomic, retain) NSString * isLastMinuteSale;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSNumber * minAmount;
@property (nonatomic, retain) NSNumber * minDays;
@property (nonatomic, retain) NSNumber * maxDays;
@property (nonatomic, retain) NSNumber * totalRate;
@property (nonatomic, retain) NSNumber * averageRate;
@property (nonatomic, retain) NSNumber * averageBaseRate;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSString * coupon;
@property (nonatomic, retain) NSArray * nightlyRates;
@property (nonatomic, retain) NSString * invoiceMode;

+ (NSDictionary *) mapedObject;
- (NSString *) getPaymentType:(ELongHotel *) hotel arrivalDate:(NSDate *) arriveDate departDate:(NSDate *) departDate;
- (NSString *) priceStringWithRoomAmount:(NSNumber *) roomAmount isOneNight:(BOOL) isOneNight;

@end
