//
//  ServiceUtils.m
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ServiceUtils.h"
#import "NSObject+JTObjectMapping.h"
#import "KeychainItemWrapper.h"
#import "Constants.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation ServiceUtils

+ (LocalResultData *) getMapedObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        LocalResultData *rdata = [LocalResultData objectFromJSONObject:json mapping:[LocalResultData mapedObject]];
        return rdata;
    }
    return nil;
}

+ (BOOL)isValidateEmail:(NSString *) email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

+ (void) savePassword:(NSString *) password email:(NSString *) email
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:IdentifierKeychain accessGroup:nil];
    [keychainItem setObject:(__bridge id)(kSecAttrAccessibleAlwaysThisDeviceOnly) forKey:(__bridge id)kSecAttrAccessible];
    [keychainItem setObject:email forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
}

+ (void) removePassword
{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:IdentifierKeychain accessGroup:nil];
    [keychainItem resetKeychainItem];
}

// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

+ (void) alart:(NSString *) msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (NSInteger) currentYear
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    return [components year];
}

@end
