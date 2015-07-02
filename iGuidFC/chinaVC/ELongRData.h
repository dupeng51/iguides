//
//  ELongRData.h
//  iGuidFC
//
//  Created by dampier on 15/5/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELongRData : NSObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) id result;

+(NSDictionary *) mapedObject;

@end
