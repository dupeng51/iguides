//
//  ELongHotel.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongDetail.h"
#import "ELGuranteeRule.h"
#import "ELGift.h"
#import "ELongBookingRule.h"

@interface ELongHotel : NSObject

@property (nonatomic, retain) NSString * hotelId;
@property (nonatomic, retain) NSNumber * lowRate;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSArray * bookingRules;
@property (nonatomic, retain) NSArray * guaranteeRules;
@property (nonatomic, retain) NSArray * prepayRules;
@property (nonatomic, retain) NSArray * valueAdds;
@property (nonatomic, retain) NSArray * drrRules;
@property (nonatomic, retain) NSString * facilities;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * poiName;
@property (nonatomic, retain) NSArray * rooms;
@property (nonatomic, retain) ELongDetail * detail;
@property (nonatomic, retain) NSArray * images;
@property (nonatomic, retain) NSArray * gifts;
@property (nonatomic, retain) NSArray * HAvailPolicys;
@property (nonatomic, retain) NSArray * products;

- (NSString *) coverImageUrl;
- (void) filterRooms;
- (NSString *) roomImageUrl:(NSString *) roomid;

- (ELGuranteeRule *) guranteeRuleByID:(NSNumber *) guranteeRuleID;
- (ELGift *) giftByID:(NSNumber *) giftID;
- (ELongBookingRule *) bookRuleByID:(NSNumber *) bookRuleID;

- (BOOL) haveWifi;
- (BOOL) haveParking;


+(NSDictionary *) mapedObject;

@end
