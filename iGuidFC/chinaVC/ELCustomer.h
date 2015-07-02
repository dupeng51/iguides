//
//  ELCustomer.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCustomer : NSObject

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * Mobile;
@property (nonatomic, retain) NSNumber * Phone;
@property (nonatomic, retain) NSString * Fax;
@property (nonatomic, retain) NSString * Gender;
@property (nonatomic, retain) NSString * IdType;
@property (nonatomic, retain) NSNumber * IdNo;
@property (nonatomic, retain) NSString * Nationality;
@property (nonatomic, retain) NSNumber * ConfirmationNumber;

+ (NSDictionary *) mapedObject;

@end
