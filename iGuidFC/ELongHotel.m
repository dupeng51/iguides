//
//  ELongHotel.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongHotel.h"
#import "NSObject+JTObjectMapping.h"
#import "ELGuranteeRule.h"
#import "ELPrepayRule.h"
#import "ELValueAdd.h"
#import "ELDrrRule.h"
#import "ELRoom.h"
#import "ELongDetail.h"
#import "ELProduct.h"
#import "ELImage.h"
#import "ELGift.h"
#import "ELHAvailPolicys.h"
#import "ELLocation.h"
#import "ELRatePlan.h"

@implementation ELongHotel


+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"hotelId", @"HotelId",
            @"lowRate", @"LowRate",
            @"currencyCode", @"CurrencyCode",
            [ELongBookingRule mappingWithKey:@"bookingRules" mapping:[ELongBookingRule mapedObject]], @"BookingRules",
            [ELGuranteeRule mappingWithKey:@"guaranteeRules" mapping:[ELGuranteeRule mapedObject]], @"GuaranteeRules",
            [ELPrepayRule mappingWithKey:@"prepayRules" mapping:[ELPrepayRule mapedObject]], @"PrepayRules",
            [ELValueAdd mappingWithKey:@"valueAdds" mapping:[ELValueAdd mapedObject]], @"ValueAdds",
            [ELDrrRule mappingWithKey:@"drrRules" mapping:[ELDrrRule mapedObject]], @"DrrRules",
            @"facilities", @"Facilities",
            @"distance", @"Distance",
            @"poiName", @"PoiName",
            [ELRoom mappingWithKey:@"rooms" mapping:[ELRoom mapedObject]], @"Rooms",
            [ELongDetail mappingWithKey:@"detail" mapping:[ELongDetail mapedObject]], @"Detail",
            [ELImage mappingWithKey:@"images" mapping:[ELImage mapedObject]], @"Images",
            [ELGift mappingWithKey:@"gifts" mapping:[ELGift mapedObject]], @"Gifts",
            [ELHAvailPolicys mappingWithKey:@"HAvailPolicys" mapping:[ELHAvailPolicys mapedObject]], @"HAvailPolicys",
            [ELProduct mappingWithKey:@"products" mapping:[ELProduct mapedObject]], @"Products",
            nil];
}

- (NSString *) coverImageUrl
{
    for (ELImage *elImage in self.images) {
        if ([elImage.IsCoverImage isEqualToString:@"true"]) {
            for (ELLocation *location in elImage.Locations) {
                if (location.sizeType.intValue == 1) {
                    return location.url;
                }
            }
        }
    }
    return nil;
}

- (NSString *) roomImageUrl:(NSString *) roomid
{
    for (ELImage *elImage in self.images) {
        NSArray *roomids = [elImage.RoomId componentsSeparatedByString:@","];
        for (NSString *roomid1 in roomids) {
            if ([roomid1 isEqualToString:roomid]) {
                for (ELLocation *location in elImage.Locations) {
                    if (location.sizeType.intValue == 2) {
                        return location.url;
                    }
                }
            }
        }
    }
    return nil;
}

- (void) filterRooms
{
    NSMutableArray *rooms = [[NSMutableArray alloc] initWithArray:self.rooms];
    NSMutableArray *toDeleteRooms = [NSMutableArray array];
    for (ELRoom *room in rooms) {
        NSMutableArray *ratePlans = [[NSMutableArray alloc] initWithArray:room.ratePlans];
        room.ratePlans = ratePlans;
        
        NSMutableArray *toDeleteRatePlans = [NSMutableArray array];
        for (ELRatePlan *ratePlan in ratePlans) {
            if (ratePlan.averageRate.intValue == -1 || ratePlan.status.intValue== 0 || [ratePlan.customerType isEqualToString:@"Chinese"]) {
                [toDeleteRatePlans addObject:ratePlan];
            }
        }
        
        [ratePlans removeObjectsInArray:toDeleteRatePlans];
        NSString *imageURL = room.ImageUrl;
        if (!imageURL) {
            imageURL =[self roomImageUrl:room.roomId];
        }
        if (ratePlans.count == 0 || [room.name isEqualToString:@""] || (imageURL == nil && self.images)) {
            [toDeleteRooms addObject:room];
        }

        
        
    }
    [rooms removeObjectsInArray:toDeleteRooms];
    self.rooms = rooms;
}

- (ELGuranteeRule *) guranteeRuleByID:(NSNumber *) guranteeRuleID
{
    for (ELGuranteeRule *guranteeRule in self.guaranteeRules) {
        if (guranteeRule.guranteeRuleId.intValue == guranteeRuleID.intValue) {
            return guranteeRule;
        }
    }
    return nil;
}

- (ELongBookingRule *) bookRuleByID:(NSNumber *) bookRuleID
{
    for (ELongBookingRule *bookRule in self.bookingRules) {
        if (bookRuleID.intValue == bookRule.bookingRuleId.intValue) {
            return bookRule;
        }
    }
    return nil;
}

- (ELGift *) giftByID:(NSNumber *) giftID
{
    for (ELGift *gift in self.gifts) {
        if (gift.GiftId.intValue == giftID.intValue) {
            return gift;
        }
    }
    return nil;
}

- (BOOL) haveWifi
{
    NSArray *facilities = [self.facilities componentsSeparatedByString:@","];
    for (NSString *facility in facilities) {
        if ([facility isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL) haveParking
{
    NSArray *facilities = [self.facilities componentsSeparatedByString:@","];
    for (NSString *facility in facilities) {
        if ([facility isEqualToString:@"5"]) {
            return YES;
        }
    }
    return NO;
}

@end
