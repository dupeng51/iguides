//
//  ELInvoice.m
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELInvoice.h"
#import "ELRecipient.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELInvoice

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Title", @"Title",
            @"ItemName", @"ItemName",
            @"Amount", @"Amount",
            @"Status", @"Status",
            @"DeliveryStatus", @"DeliveryStatus",
            [ELRecipient mappingWithKey:@"Recipient" mapping:[ELRecipient mapedObject]], @"Recipient",
            nil];
}

@end
