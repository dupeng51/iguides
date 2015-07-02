//
//  ELRoom.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELRoom : NSObject

@property (nonatomic, retain) NSString * roomTypeId;
@property (nonatomic, retain) NSString * roomId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSArray * ratePlans;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * ImageUrl;
@property (nonatomic, retain) NSString * Floor;
@property (nonatomic, retain) NSString * Broadnet;
@property (nonatomic, retain) NSString * BedType;
@property (nonatomic, retain) NSString * BedDesc;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSString * Area;
@property (nonatomic, retain) NSString * Capcity;

+ (NSDictionary *) mapedObject;
- (NSString *) lowestPrice;

@end
