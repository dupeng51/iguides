//
//  SkyscannerUtils.m
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SkyscannerSession.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

#define CreatingSessionURL @"http://partners.api.skyscanner.net/apiservices/pricing/v1.0?apiKey=tr781224477297939107692161184415"


@implementation SkyscannerSession
{
    NSString *locationURL;
}

-(void) createSession:(NSDictionary *) params
{
    NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"CN", @"country",
                            @"CNY", @"currency",
                            @"en-GB", @"locale",
                            @"NYCA-sky", @"originplace",
                            @"BJSA-sky", @"destinationplace",
                            @"2015-04-21", @"outbounddate",
                            @"1", @"adults",
                            nil];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:CreatingSessionURL]];
    [client setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [client setDefaultHeader:@"Accept" value:@"application/json"];

    
    [client postPath:@"" parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *headers = operation.response.allHeaderFields;
        locationURL = [headers objectForKey:@"Location"];
        NSLog(@"Response: %@", headers);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
