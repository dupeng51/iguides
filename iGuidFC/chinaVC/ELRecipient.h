//
//  ELRecipient.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELRecipient : NSObject

@property (nonatomic, retain) NSString * Province;
@property (nonatomic, retain) NSString * City;
@property (nonatomic, retain) NSString * District;
@property (nonatomic, retain) NSString * Street;
@property (nonatomic, retain) NSString * PostalCode;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * Email;

+ (NSDictionary *) mapedObject;

@end
