//
//  ELRecipient.m
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELRecipient.h"

@implementation ELRecipient

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Province", @"Province",
            @"City", @"City",
            @"District", @"District",
            @"Street", @"Street",
            @"PostalCode", @"PostalCode",
            @"Name", @"Name",
            @"Phone", @"Phone",
            @"Email", @"Email",
            nil];
}

@end
