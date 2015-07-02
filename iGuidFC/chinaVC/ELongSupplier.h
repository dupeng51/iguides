//
//  ELongSupplier.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongSupplier : NSObject

@property (nonatomic, retain) NSNumber * WeekendStart;
@property (nonatomic, retain) NSNumber * WeekendEnd;
@property (nonatomic, retain) NSString * InstantRoomTypes;
@property (nonatomic, retain) NSNumber * ID;
@property (nonatomic, retain) NSString * HotelCode;
@property (nonatomic, retain) NSString * Status;

+(NSDictionary *) mapedXMLObject;

@end
