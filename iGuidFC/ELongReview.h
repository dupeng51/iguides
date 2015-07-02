//
//  ELongReview.h
//  iGuidFC
//
//  Created by dampier on 15/5/20.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongReview : NSObject

@property (nonatomic, retain) NSNumber * good;
@property (nonatomic, retain) NSNumber * poor;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * score;

+(NSDictionary *) mapedObject;

+(NSDictionary *) mapedXMLObject;

@end
