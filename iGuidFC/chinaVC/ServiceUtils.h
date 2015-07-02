//
//  ServiceUtils.h
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalResultData.h"

@interface ServiceUtils : NSObject

+ (LocalResultData *) getMapedObject:(id) jsonData;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (void) savePassword:(NSString *) password email:(NSString *) email;

+ (void) removePassword;

+ (NSString *)getIPAddress;

+ (void) alart:(NSString *) msg;

+ (NSInteger) currentYear;

@end
