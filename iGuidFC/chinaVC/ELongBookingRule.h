//
//  ELongBookingRule.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongBookingRule : NSObject


@property (nonatomic, retain) NSString * typeCode;
@property (nonatomic, retain) NSNumber * bookingRuleId;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * dateType;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * startHour;
@property (nonatomic, retain) NSString * endHour;

+(NSDictionary *) mapedObject;

- (BOOL) needPhoneNo;

@end
