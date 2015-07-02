//
//  PriceOption.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "PriceOption.h"


@implementation PriceOption

-(void)dealloc{
    _agents = nil;
    _quoteAgeInMinutes = nil;
    _price = nil;
    _deeplinkUrl = nil;
}

@end
