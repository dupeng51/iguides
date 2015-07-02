//
//  ELInvoice.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELRecipient.h"

@interface ELInvoice : NSObject

@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * ItemName;
@property (nonatomic, retain) NSNumber * Amount;
@property (nonatomic, retain) NSString * Status;
@property (nonatomic, retain) NSString * DeliveryStatus;
@property (nonatomic, retain) ELRecipient * Recipient;

+ (NSDictionary *) mapedObject;

@end
