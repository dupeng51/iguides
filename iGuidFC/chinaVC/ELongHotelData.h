//
//  ELongHotelData.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongHotelXML.h"
#import "ELongReview.h"

@interface ELongHotelData : NSObject

@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) ELongHotelXML * Detail;
@property (nonatomic, retain) NSArray * Rooms;
@property (nonatomic, retain) NSArray * Images;
@property (nonatomic, retain) ELongReview * Review;

+(NSDictionary *) mapedXMLObject;

@end
