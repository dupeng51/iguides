//
//  ELExchangeRate.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELExchangeRate : NSObject

@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSNumber * rate;

+(NSDictionary *) mapedObject;

@end
