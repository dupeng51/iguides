//
//  LocalResultData.h
//  iGuidFC
//
//  Created by dampier on 15/6/3.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalResultData : NSObject

//0 success,
//1 error, the message show to user,
//2 error, the message show to developer
@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;

+ (NSDictionary *) mapedObject;

@end
