//
//  ELCustomer.m
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELCustomer.h"

@implementation ELCustomer

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Name", @"Name",
            @"Email", @"Email",
            @"Mobile", @"Mobile",
            @"Phone", @"Phone",
            @"Fax", @"Fax",
            @"Gender", @"Gender",
            @"IdType", @"IdType",
            @"IdNo", @"IdNo",
            @"Nationality", @"Nationality",
            @"ConfirmationNumber", @"ConfirmationNumber",
            nil];
}

@end
