//
//  LocalSession.m
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "LocalSession.h"
#import "AFHTTPClient.h"
#import "ServiceUtils.h"
#import "Constants.h"
#import "ServiceUtils.h"

@implementation LocalSession

static NSString *username_;
static NSString *email_;

+ (NSString *) userName
{
    return username_;
}

+ (NSString *) email
{
    return email_;
}

+ (void) setEmptyLogInfo
{
    username_ = nil;
    email_ = nil;
}

- (void) postSignupWithName:(NSString *) username email:(NSString *) email password:(NSString *) password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [params setValue:email forKey:@"email"];
    [params setValue:password forKey:@"p"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client postPath:SignupPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",operation);
        LocalResultData *resultData =[ServiceUtils getMapedObject:responseObject];
        if (resultData && resultData.code.intValue == 0) {
            username_ = resultData.username;
            email_ = resultData.email;
        }
        if (resultData) {
            [self.delegate returnSignup:resultData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate returnSignup:nil];
        NSLog(@"postSignupWithName Error: %@", [error localizedDescription]);
    }];
}

- (void) postSigninWithEmail:(NSString *) email password:(NSString *) password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:email forKey:@"email"];
    [params setValue:password forKey:@"p"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client postPath:SigninPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",operation);
        LocalResultData *resultData =[ServiceUtils getMapedObject:responseObject];
        if (resultData && resultData.code.intValue == 0) {
            username_ = resultData.username;
            email_ = resultData.email;
        }
        if (resultData) {
            [self.delegate returnLogin:resultData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"postSigninWithEmail Error: %@", [error localizedDescription]);
    }];
}

- (void) signout
{   
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client postPath:SignoutPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",operation);
        [self.delegate returnSignout];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"signout Error: %@", [error localizedDescription]);
    }];
}

@end
