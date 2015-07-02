//
//  HotelCreateResult.h
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelCreateResult : NSObject

@property (nonatomic, retain) NSNumber * OrderId;
@property (nonatomic, retain) NSString * CancelTime;
@property (nonatomic, retain) NSNumber * GuaranteeAmount;
@property (nonatomic, retain) NSString * CurrencyCode;

+ (NSDictionary *) mapedObject;

@end
