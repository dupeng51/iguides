//
//  ELongResult.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongResult : NSObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSArray * hotels;
@property (nonatomic, retain) NSArray * exchangeRateList;

- (void) filterHotel;

+ (NSDictionary *) mapedObject;

@end
