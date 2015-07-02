//
//  ELHAvailPolicys.h
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELHAvailPolicys : NSObject

@property (nonatomic, retain) NSNumber * Id;
@property (nonatomic, retain) NSString * AvailPolicyText;
@property (nonatomic, retain) NSString * AvailPolicyStart;
@property (nonatomic, retain) NSString * AvailPolicyEnd;

+(NSDictionary *) mapedObject;

@end
