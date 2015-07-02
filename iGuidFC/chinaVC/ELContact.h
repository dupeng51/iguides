//
//  ELContact.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELContact : NSObject

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * Mobile;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * Fax;
@property (nonatomic, retain) NSString * Gender;
@property (nonatomic, retain) NSString * IdType;
@property (nonatomic, retain) NSString * IdNo;

+ (NSDictionary *) mapedObject;

@end
