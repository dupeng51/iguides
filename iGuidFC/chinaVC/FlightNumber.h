//
//  FlightNumber.h
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Carriers.h"

@interface FlightNumber : NSObject

@property (nonatomic, retain) NSString * flightNumber;
@property (nonatomic, retain) NSNumber * carrierId;

//object convert from id
@property (nonatomic, retain) Carriers * carrier_;

@end
