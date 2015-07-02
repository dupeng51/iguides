//
//  Carriers.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Carriers : NSObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * displayCode;
@property (nonatomic, retain) NSNumber * idString;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, strong) UIImage * image;

-(UIImage *) getCarriearImage;

@end
