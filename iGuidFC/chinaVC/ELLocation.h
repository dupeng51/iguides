//
//  ELLocation.h
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELLocation : NSObject

@property (nonatomic, retain) NSNumber * sizeType;
@property (nonatomic, retain) NSString * waterMark;
@property (nonatomic, retain) NSString * url;

+ (NSDictionary *) mapedObject;
+(NSDictionary *) mapedXMLObject;

@end
