//
//  POCity.h
//  iGuidFC
//
//  Created by dampier on 15/3/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POCity : NSObject{
    
}

@property NSNumber *pid;
@property (nonatomic,retain) NSString *name;
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (nonatomic,retain) NSString *desc;
@property (nonatomic,retain) NSString *imageName;
@property (nonatomic) double north;
@property (nonatomic) double south;
@property (nonatomic) double east;
@property (nonatomic) double west;

@end
