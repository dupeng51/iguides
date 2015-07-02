//
//  ELongServiceRank.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongServiceRank : NSObject

@property (nonatomic, retain) NSNumber * SummaryScore;
@property (nonatomic, retain) NSString * SummaryRate;
@property (nonatomic, retain) NSString * InstantConfirmScore;
@property (nonatomic, retain) NSString * InstantConfirmRate;
@property (nonatomic, retain) NSString * BookingSuccessScore;
@property (nonatomic, retain) NSString * BookingSuccessRate;
@property (nonatomic, retain) NSString * ComplaintScore;
@property (nonatomic, retain) NSString * ComplaintRate;

+(NSDictionary *) mapedXMLObject;

@end
