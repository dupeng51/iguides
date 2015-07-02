//
//  TripSession.m
//  iGuidFC
//
//  Created by dampier on 15/5/21.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "TripSession.h"
#import "NSObject+JTObjectMapping.h"
#import "AFHTTPClient.h"
#import "NSString+MD5.h"

#define LocalURL @"http://192.168.1.102/"
#define LocalURLPath @"elong/tripAPI.php"


@implementation TripSession

- (void)dealloc
{
    _delegate = nil;
}

-(void) getGuiderList:(NSString *) dataString
{
    NSDictionary *params = [self getParams:dataString method:@"guider.list"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:LocalURL]];
    
    [client getPath:LocalURLPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
//        ELongRData *resultData =[self getMapedObject:responseObject];
//        if (resultData) {
//            [self.delegate returnHotelList:resultData.result];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getHotelList Error: %@", [error localizedDescription]);
    }];
}

#pragma mark Private

-(NSDictionary *) getParams:(NSString *) data method:(NSString *) method
{
    NSString *username = @"username";//用户登录名，未来存储到appdelegate里
    
    NSNumber * timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
    NSString * strTimestamp = [NSString stringWithFormat:@"%ld",(long)[timestamp integerValue]];
    
    NSString *signature1 = [[data stringByAppendingString:username] MD5];
    NSString *signature2 = [[strTimestamp stringByAppendingString:signature1] stringByAppendingString: @"guider.list"];
    
    NSString *signature = [signature2 MD5];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:username forKey:@"user"];
    [dict setValue:strTimestamp forKey:@"timestamp"];
    [dict setValue:@"json" forKey:@"format"];
    [dict setValue:data forKey:@"data"];
    [dict setValue:signature forKey:@"signature"];
    [dict setValue:method forKey:@"method"];
    return dict;
}

-(id) getMapedObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        /*
        if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
            ELongRData *rdata = [ELongRData objectFromJSONObject:json mapping:[ELongRData mapedObject]];
            return rdata;
        } else {
            NSLog(@"%@", json);
        }
         */
    }
    return nil;
}

@end
