//
//  ELDrrRule.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELDrrRule : NSObject

@property (nonatomic, retain) NSString * drrRuleId;
@property (nonatomic, retain) NSString * typeCode;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * dateType;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSNumber * dayNum;
@property (nonatomic, retain) NSNumber * checkInNum;
@property (nonatomic, retain) NSNumber * everyCheckInNum;
@property (nonatomic, retain) NSNumber * lastDayNum;
@property (nonatomic, retain) NSNumber * whichDayNum;
@property (nonatomic, retain) NSString * cashScale;
@property (nonatomic, retain) NSNumber * deductNum;
@property (nonatomic, retain) NSString * weekSet;
@property (nonatomic, retain) NSString * feeType;

+(NSDictionary *) mapedObject;

@end
