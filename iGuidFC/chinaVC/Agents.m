//
//  Agents.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Agents.h"


@implementation Agents
{
    UIImage * agentImage;
}

-(void) dealloc{
    _bookingNumber = nil;
    _idString = nil;
    _imageUrl = nil;
    _name = nil;
    _optimisedForMobile = nil;
    _status = nil;
    _type = nil;
    
    agentImage = nil;
}

-(UIImage *) getAgentImage
{
    if (!agentImage) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        agentImage = [UIImage imageWithData:data];
    }
    return agentImage;
}

@end
