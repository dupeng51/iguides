//
//  ELongRoomXML.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongRoomXML : NSObject

@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Area;
@property (nonatomic, retain) NSString * Floor;
@property (nonatomic, retain) NSNumber * BroadnetAccess;
@property (nonatomic, retain) NSNumber * BroadnetFee;
@property (nonatomic, retain) NSString * BedType;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * Comments;
@property (nonatomic, retain) NSNumber * Capacity;
@property (nonatomic, retain) NSString * Facilities;

+(NSDictionary *) mapedXMLObject;
- (NSString *) roomFacilitySummary;

@end
