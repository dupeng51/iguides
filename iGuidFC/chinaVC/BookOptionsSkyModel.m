//
//  BookOptionsSkyModel.m
//  iGuidFC
//
//  Created by dampier on 15/4/23.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "BookOptionsSkyModel.h"

@implementation BookOptionsSkyModel

- (void)dealloc
{
    _bookingOptions = nil;
    _carriers = nil;
    _places= nil;
    _query= nil;
    _segments= nil;
}

@end
