//
//  ELongFacilitiesV2.h
//  iGuidFC
//
//  Created by dampier on 15/5/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongFacilitiesV2 : NSObject

@property (nonatomic, retain) NSString * GeneralAmenities;
@property (nonatomic, retain) NSString * RecreationAmenities;
@property (nonatomic, retain) NSString * ServiceAmenities;

+(NSDictionary *) mapedXMLObject;

@end
