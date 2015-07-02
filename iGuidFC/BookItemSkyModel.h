//
//  BookItemSkyModel.h
//  iGuidFC
//
//  Created by dampier on 15/4/23.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Agents.h"

@interface BookItemSkyModel : NSObject

@property (nonatomic, retain) NSNumber * agentid;
@property (nonatomic, retain) NSString * alternativeCurrency;
@property (nonatomic, retain) NSString * alternativePrice;
@property (nonatomic, retain) NSString * deeplink;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSArray * segmentIds;
@property (nonatomic, retain) NSString * status;

//object convert from id
@property (nonatomic, retain) Agents * agents_;

@end
