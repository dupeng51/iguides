//
//  ELRatePlan.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELRatePlan.h"
#import "NSObject+JTObjectMapping.h"
#import "ELNightlyRate.h"
#import "ELongSession.h"

@implementation ELRatePlan

- (void)dealloc
{
    _ratePlanId = nil;
    _ratePlanName = nil;
    _status = nil;
    _roomTypeId = nil;
    _suffixName = nil;
    _hotelCode = nil;
    _customerType = nil;
    _currentAlloment = nil;
    _instantConfirmation = nil;
    _paymentType = nil;
    _bookingRuleIds = nil;
    _guaranteeRuleIds = nil;
    _prepayRuleIds = nil;
    _drrRuleIds = nil;
    _valueAddIds = nil;
    _productTypes = nil;
    _isLastMinuteSale = nil;
    _startTime = nil;
    _endTime = nil;
    _minAmount = nil;
    _minDays = nil;
    _maxDays = nil;
    _totalRate = nil;
    _averageRate = nil;
    _averageBaseRate = nil;
    _currencyCode = nil;
    _coupon = nil;
    _nightlyRates = nil;
    _invoiceMode = nil;
}

+(NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"ratePlanId", @"RatePlanId",
            @"ratePlanName", @"RatePlanName",
            @"status", @"Status",
            @"roomTypeId", @"RoomTypeId",
            @"suffixName", @"SuffixName",
            @"hotelCode", @"GotelCode",
            @"customerType", @"CustomerType",
            @"currentAlloment", @"CurrentAlloment",
            @"instantConfirmation", @"InstantConfirmation",
            @"paymentType", @"PaymentType",
            @"bookingRuleIds", @"BookingRuleIds",
            @"guaranteeRuleIds", @"GuaranteeRuleIds",
            @"prepayRuleIds", @"PrepayRuleIds",
            @"drrRuleIds", @"DrrRuleIds",
            @"valueAddIds", @"ValueAddIds",
            @"GiftIds", @"GiftIds",
            @"HAvailPolicyIds", @"HAvailPolicyIds",
            @"productTypes", @"ProductTypes",
            @"isLastMinuteSale", @"IsLastMinuteSale",
            @"startTime", @"StartTime",
            @"endTime", @"EndTime",
            @"minAmount", @"MinAmount",
            @"minDays", @"MinDays",
            @"maxDays", @"MaxDays",
            @"totalRate", @"TotalRate",
            @"averageRate", @"AverageRate",
            @"averageBaseRate", @"AverageBaseRate",
            @"currencyCode", @"CurrencyCode",
            @"coupon", @"Coupon",
            [ELNightlyRate mappingWithKey:@"nightlyRates" mapping:[ELNightlyRate mapedObject]], @"NightlyRates",
            @"invoiceMode", @"InvoiceMode",
            nil];
}

- (NSString *) getPaymentType:(ELongHotel *) hotel arrivalDate:(NSDate *) arriveDate departDate:(NSDate *) departDate
{
    ELGuranteeRule * guaranteeRule = [hotel guranteeRuleByID:self.guaranteeRuleIds];
    NSString * displayPay = @"";
    if (guaranteeRule) {
        if ([guaranteeRule isGuarantee:arriveDate departDate:departDate]) {
            displayPay = @"Guarantee";
        }
    }
    
    if ([self.paymentType isEqualToString:@"SelfPay"])
    {
//        displayPay =  [displayPay stringByAppendingString: @"Self Pay"];
    } else{
        if (displayPay.length == 0) {
            displayPay = [displayPay stringByAppendingString: @", Prepay"];
        } else {
            displayPay = [displayPay stringByAppendingString: @"Prepay"];
        }
    }
    return displayPay;
}

- (NSString *) priceStringWithRoomAmount:(NSNumber *) roomAmount isOneNight:(BOOL) isOneNight
{
    int price ;
    if (isOneNight) {
        price = self.averageRate.intValue * roomAmount.intValue;
    } else {
        price = self.totalRate.intValue * roomAmount.intValue;
    }
    NSString *priceString = [NSString stringWithFormat:@"%@%d", [ELongSession currencyWithCode:self.currencyCode], price];
    return priceString;
}

@end
