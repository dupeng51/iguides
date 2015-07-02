//
//  Itinerary.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Itinerary.h"
#import "Leg.h"
#import "PriceOption.h"


@implementation Itinerary

-(void)dealloc{
    _bookingDetailsLinkURI = nil;
    _bookingDetailsLinkBody= nil;
    _bookingDetailsLinkBodyMethod= nil;
    _outboundLegId= nil;
    _inboundLegId= nil;
    _pricingOptions= nil;
    
    _outboundLeg_ = nil;
    _inboundLeg_ = nil;
}

-(NSNumber *) getLowestPrice
{
    NSNumber *lowestPrice;
    for (PriceOption *priceOption in self.pricingOptions) {
        if (!lowestPrice) {
            lowestPrice = priceOption.price;
        }
        if (lowestPrice.floatValue > priceOption.price.floatValue) {
            lowestPrice = priceOption.price;
        }
    }
    return lowestPrice;
}

@end
