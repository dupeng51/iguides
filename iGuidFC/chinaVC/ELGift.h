//
//  ELGift.h
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELGift : NSObject

@property (nonatomic, retain) NSNumber * GiftId;
@property (nonatomic, retain) NSString * StartDate;
@property (nonatomic, retain) NSString * EndDate;
@property (nonatomic, retain) NSString * DateType;
@property (nonatomic, retain) NSString * WeekSet;
@property (nonatomic, retain) NSString * GiftContent;
@property (nonatomic, retain) NSString * GiftTypes;
@property (nonatomic, retain) NSNumber * HourNumber;
@property (nonatomic, retain) NSString * HourType;
@property (nonatomic, retain) NSString * WayOfGiving;
@property (nonatomic, retain) NSString * WayOfGivingOther;
@property (nonatomic, retain) NSString * Description;

+(NSDictionary *) mapedObject;

@end
