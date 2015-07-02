//
//  ELImage.h
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELImage : NSObject

@property (nonatomic, retain) NSString * AuthorType;
@property (nonatomic, retain) NSString * IsCoverImage;
@property (nonatomic, retain) NSArray * Locations;
@property (nonatomic, retain) NSString * RoomId;
@property (nonatomic, retain) NSString * Type;

+ (NSDictionary *) mapedObject;
+(NSDictionary *) mapedXMLObject;

@end
