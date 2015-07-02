//
//  BookOptionsSkyModel.h
//  iGuidFC
//
//  Created by dampier on 15/4/23.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuerySkyModel.h"

@interface BookOptionsSkyModel : NSObject

@property (nonatomic, retain) NSArray * bookingOptions;
@property (nonatomic, retain) NSArray * carriers;
@property (nonatomic, retain) NSArray * places;
@property (nonatomic, retain) QuerySkyModel * query;
@property (nonatomic, retain) NSArray * segments;

@end
