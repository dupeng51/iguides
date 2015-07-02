//
//  Itinerary.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Leg.h"

@interface Itinerary : NSObject

@property (nonatomic, retain) NSString * bookingDetailsLinkURI;
@property (nonatomic, retain) NSString * bookingDetailsLinkBody;
@property (nonatomic, retain) NSString * bookingDetailsLinkBodyMethod;
@property (nonatomic, retain) NSString *outboundLegId;
@property (nonatomic, retain) NSString *inboundLegId;
@property (nonatomic, retain) NSArray *pricingOptions;


//object convert from id
@property (nonatomic, retain) Leg * outboundLeg_;
@property (nonatomic, retain) Leg * inboundLeg_;

-(NSNumber *) getLowestPrice;

@end
