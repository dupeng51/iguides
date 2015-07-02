//
//  SkyUtils.h
//  iGuidFC
//
//  Created by dampier on 15/4/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryModel.h"

@protocol SkyQuerayLocationDelegate <NSObject>

@optional

- (void) responsePlaces:(NSArray *) places;

@end

@interface SkyUtils : NSObject

@property id<SkyQuerayLocationDelegate> delegate;
+(NSString *) getAPIKey;
- (void) queryLocation:(NSString *) queryString;
+(NSDate *) convertDateFromString:(NSString *) dateString;
+(NSString *) convertDateToString:(NSDate *) date;
+(NSString *) displayDateToString:(NSDate *) date;
+(NSString *) displayDateWithString:(NSString *) dateString;

@end
