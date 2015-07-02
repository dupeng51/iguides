//
//  Station.m
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Station.h"


@implementation Station

-(void)dealloc{
    _idString = nil;
    _parentId = nil;
    _code = nil;
    _type = nil;
    _name = nil;
}

@end
