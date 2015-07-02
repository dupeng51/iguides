//
//  Station.h
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Station : NSObject

@property (nonatomic, retain) NSNumber * idString;
@property (nonatomic, retain) NSNumber * parentId;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;

@end
