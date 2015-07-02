//
//  ELCreditCard.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCreditCard : NSObject

@property (nonatomic, retain) NSString * Number;
@property (nonatomic, retain) NSString * ProcessType;
@property (nonatomic, retain) NSString * Status;
@property (nonatomic, retain) NSNumber * Amount;

+ (NSDictionary *) mapedObject;

@end
