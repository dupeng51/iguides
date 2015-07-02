//
//  POSpot.m
//  iGuidFC
//
//  Created by dampier on 15/3/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "POSpot.h"

@implementation POSpot

-(void) dealloc
{
    _name = nil;
    _desc = nil;
    _imageName = nil;
    _cityID = nil;
    _downloadurl=nil;
    _downloadStatus = nil;
    
    _kmlFileName = nil;
}

@end
