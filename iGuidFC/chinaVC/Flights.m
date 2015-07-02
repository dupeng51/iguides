//
//  Flights.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Flights.h"

@implementation Flights

-(void) dealloc {
    _itinerarys = nil;
    _agents = nil;
    _carriers = nil;
    _currencies = nil;
    _legs = nil;
    _places = nil;
    _query = nil;
    _segments = nil;
    _sessionKey = nil;
    _status = nil;
}

@end
