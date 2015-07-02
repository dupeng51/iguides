//
//  PriceOption.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PriceOption : NSObject

@property (nonatomic, retain) NSArray * agents;
@property (nonatomic, retain) NSNumber * quoteAgeInMinutes;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * deeplinkUrl;

//object convert from id
@property (nonatomic, retain) NSArray * agents_;
@end
