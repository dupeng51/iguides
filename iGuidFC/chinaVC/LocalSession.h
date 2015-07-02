//
//  LocalSession.h
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalResultData.h"

@protocol LocalDelegation <NSObject>

@optional

- (void)returnLogin:(LocalResultData *) resultData;
- (void)returnSignup:(LocalResultData *) resultData;
- (void)returnSignout;

@end

@interface LocalSession : NSObject

@property id<LocalDelegation> delegate;

- (void) postSigninWithEmail:(NSString *) email password:(NSString *) password;
- (void) postSignupWithName:(NSString *) username email:(NSString *) email password:(NSString *) password;
- (void) signout;

+ (NSString *) userName;
+ (NSString *) email;

+ (void) setEmptyLogInfo;

@end
