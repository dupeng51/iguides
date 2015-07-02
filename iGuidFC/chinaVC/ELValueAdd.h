//
//  ELValueAdd.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELValueAdd : NSObject

@property (nonatomic, retain) NSString * valueAddId;
@property (nonatomic, retain) NSString * typeCode;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * isInclude;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSString * priceOption;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * isExtAdd;
@property (nonatomic, retain) NSString * extOption;
@property (nonatomic, retain) NSNumber * extPrice;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * weekSet;

+(NSDictionary *) mapedObject;

@end
