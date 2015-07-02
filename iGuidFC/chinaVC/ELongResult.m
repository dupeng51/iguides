//
//  ELongResult.m
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongResult.h"
#import "NSObject+JTObjectMapping.h"
#import "ELExchangeRate.h"
#import "ELongHotel.h"

@implementation ELongResult

- (void)dealloc
{
    _count = nil;
    _hotels = nil;
    _exchangeRateList = nil;
}

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"count", @"Count",
            [ELongHotel mappingWithKey:@"hotels" mapping:[ELongHotel mapedObject]], @"Hotels",
            [ELExchangeRate mappingWithKey:@"exchangeRateList" mapping:[ELExchangeRate mapedObject]], @"ExchangeRateList",
            nil];
}

- (void) filterHotel
{
    NSMutableArray *hotels = [[NSMutableArray alloc] initWithArray:self.hotels];
    NSMutableArray *toDeleteHotels = [NSMutableArray array];
    for (ELongHotel *hotel in hotels) {
        [hotel filterRooms];
        if (hotel.rooms.count == 0) {
            [toDeleteHotels addObject:hotel];
        }
    }
    [hotels removeObjectsInArray:toDeleteHotels];
    
    self.hotels = hotels;
}

@end
