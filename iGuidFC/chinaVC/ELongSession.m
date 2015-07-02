//
//  ELongSession.m
//  iGuidFC
//
//  Created by dampier on 15/5/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELongSession.h"
#import "AFHTTPClient.h"
#import "ELongRData.h"
#import "NSString+MD5.h"
#import "NSObject+JTObjectMapping.h"
#import "XMLDictionary.h"
#import "ELongHotel.h"
#import "ELOrderDetail.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation ELongSession
{

}

#define Path_hotellist @"elong/hoteldemo/hotel_list.php"
#define Path_hoteldetail @"elong/hoteldemo/hotel_detail.php"
#define Path_hotelordercreate @"elong/hoteldemo/hotel_order_create.php"
#define Path_hotelorderdetail @"elong/hoteldemo/hotel_order_detail.php"
#define Path_hotelordercancel @"elong/hoteldemo/hotel_order_cancel.php"

-(void)dealloc
{
    _delegate = nil;
}


-(void) getHotelList:(NSString *) dataString
{
    NSDictionary *params = [self getParams:dataString method:@"hotel.list"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:DomesticURLPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        ELongRData *resultData =[self getMapedObject:responseObject];
        if (resultData) {
            [self.delegate returnHotelList:resultData.result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getHotelList Error: %@", [error localizedDescription]);
    }];
}

-(void) getHotelList1:(NSDictionary *) params
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:Path_hotellist parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        
        ELongRData *resultData =[self getMapedObject:responseObject];
        if (resultData) {
            [self.delegate returnHotelList:resultData.result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getHotelList Error: %@", [error localizedDescription]);
    }];
}

-(void) getHotelDetail:(NSString *) dataString
{
    NSDictionary *params = [self getParams:dataString method:@"hotel.detail"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:DomesticURLPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        ELongRData *resultData =[self getMapedObject:responseObject];
        if (resultData) {
            [self.delegate returnHotelDetail:resultData.result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getHotelDetail Error: %@", [error localizedDescription]);
    }];
}

-(void) getHotelDetail1:(NSDictionary *) params
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:Path_hoteldetail parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        ELongRData *resultData =[self getMapedObject:responseObject];
        if (resultData) {
            [self.delegate returnHotelDetail:resultData.result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getHotelDetail Error: %@", [error localizedDescription]);
    }];
}

-(void) getHotelDetailXML:(NSString *) hotelid
{
    NSString *lastid = [hotelid substringFromIndex:hotelid.length-2];
    NSString *hotelDetailXMLPath = [NSString stringWithFormat:@"%@/%@/%@.xml",hotelDetailURL,lastid, hotelid];
    [self performSelectorInBackground:@selector(getStrFromURL:) withObject:hotelDetailXMLPath];
}

-(void) hotelOrderCreate:(NSString *) dataString
{
    NSDictionary *params = [self getParams:dataString method:ELMethodOrderCreate];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client postPath:Path_hotelordercreate parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        HotelCreateResult *resultData =[self getCreateResultObject:responseObject];
        if (resultData) {
            [self.delegate returnHotelCreate:resultData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"hotelOrderCreate Error: %@", [error localizedDescription]);
    }];
}

-(void) hotelOrderDetail:(NSString *) userid
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userid forKey:@"userid"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:Path_hotelorderdetail parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        ELOrderDetail *resultData =[self getOrderDetailObject:responseObject];
        if (resultData) {
            [self.delegate returnOrderDetail:resultData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"hotelOrderDetail Error: %@", [error localizedDescription]);
    }];
}

-(void) hotelOrderCancel:(NSString *) orderid
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:orderid forKey:@"orderid"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:Path_hotelordercancel parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:0
                                                                    error:NULL];
            if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
                BOOL cancelSuccess = [[json valueForKeyPath:@"Result.Successs"] boolValue];
                [self.delegate returnOrdercancel:cancelSuccess];
            } else {
                NSLog(@"return data code failed: %@", json);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"hotelOrderCancel Error: %@", [error localizedDescription]);
    }];
}

-(void) creditcardValidate:(NSString *) cardNo
{
//    NSString *jsonString = [ELongSession jsonstringWithData:cardNo];
    
    NSDictionary *params = [self getParams:cardNo method:ELMethodCommonCreditcardValidate];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    [client getPath:DomesticURLPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:0
                                                                    error:NULL];
            if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
                BOOL isValid = YES;
                BOOL isNeedVerifyCode = YES;
                if (![[json valueForKeyPath:@"Result.IsValid"] boolValue]) {
                    isValid = NO;
                }
                if (![[json valueForKeyPath:@"Result.IsNeedVerifyCode"] boolValue]) {
                    isNeedVerifyCode = NO;
                }
                [self.delegate returnCreditCardValidate:isValid needCVV:isNeedVerifyCode];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"creditcardValidate Error: %@", [error localizedDescription]);
    }];
}

-(void) orderCheckguest:(NSArray *) names isGangAo:(BOOL) isGangAo
{
    NSString *gangAoString;
    if (isGangAo) {
        gangAoString = @"true";
    } else {
        gangAoString = @"false";
    }
    
    NSMutableDictionary *jsonParmDict = [[NSMutableDictionary alloc]init];
    [jsonParmDict setValue:names forKey:@"Names"];
    [jsonParmDict setValue:gangAoString forKey:@"IsGangAo"];

    NSString * dataString = [ELongSession jsonstringWithCommonData:jsonParmDict];
    NSDictionary *params = [self getParams:dataString method:@"hotel.order.checkguest"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:DomesticURL]];
    
    [client getPath:DomesticURLPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:0
                                                                    error:NULL];
            if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
                [self.delegate returnCheckGuest:[json valueForKeyPath:@"Result.Result"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"orderCheckguest Error: %@", [error localizedDescription]);
    }];
}

#pragma mark Private

-(void)getStrFromURL:(NSString*)searchurl {
    NSURL* url = [NSURL URLWithString:searchurl];
    NSError* error = nil;
    NSString* str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    if (str) {
        ELongHotelData *hotelData = [self getMapedXMLObject:str];
        if (hotelData) {
            [self.delegate returnHotelDetailXML:hotelData];
        }
    }
    NSLog(@"str: %@", str);
}

-(NSDictionary *) getParams:(NSString *) data method:(NSString *) method
{
//    NSNumber * timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    
//    NSString * strTimestamp = [NSString stringWithFormat:@"%ld",(long)[timestamp integerValue]];
    
//    NSString *signature1 = [[data stringByAppendingString:appKey1] MD5];
//    NSString *signature2 = [[strTimestamp stringByAppendingString:signature1] stringByAppendingString: secretKey1];

//    NSString *signature = [signature2 MD5];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:user1 forKey:@"user"];
//    [dict setValue:strTimestamp forKey:@"timestamp"];
    [dict setValue:@"json" forKey:@"format"];
    [dict setValue:data forKey:@"data"];
//    [dict setValue:signature forKey:@"signature"];
    [dict setValue:method forKey:@"method"];
    [dict setValue:appKey1 forKey:@"appkey"];
    [dict setValue:secretKey1 forKey:@"secretkey"];
    return dict;
}

-(ELOrderDetail *) getOrderDetailObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
            id result = [json valueForKeyPath:@"Result"];
            ELOrderDetail *rdata = [ELOrderDetail objectFromJSONObject:result mapping:[ELOrderDetail mapedObject]];
            return rdata;
        }else {
            NSLog(@"return data code failed: %@", json);
        }
    }
    return nil;
}

-(HotelCreateResult *) getCreateResultObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
            id result = [json valueForKeyPath:@"Result"];
            HotelCreateResult *rdata = [HotelCreateResult objectFromJSONObject:result mapping:[HotelCreateResult mapedObject]];
            return rdata;
        }else {
            NSLog(@"return data code failed: %@", json);
        }
    }
    return nil;
}

-(ELongRData *) getMapedObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        if ([[json objectForKey:@"Code"] isEqualToString:@"0"]) {
            ELongRData *rdata = [ELongRData objectFromJSONObject:json mapping:[ELongRData mapedObject]];
            return rdata;
        } else {
            NSLog(@"return data code failed: %@", json);
        }
    }
    return nil;
}

-(ELongHotelData *) getMapedXMLObject:(id) xmlData
{
    if ([xmlData isKindOfClass:[NSString class]]) {
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlData];
//        NSLog(@"%@",xmlDoc);
        ELongHotelData *rdata = [ELongHotelData objectFromJSONObject:xmlDoc mapping:[ELongHotelData mapedXMLObject]];
        return rdata;
    }
    return nil;
}

#pragma mark static

+ (NSString *) jsonstringWithCommonData:(id) data
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
    [jsonDict setValue:@"1.18" forKey:@"Version"];
    [jsonDict setValue:@"en_US" forKey:@"Local"];
    [jsonDict setValue:data forKey:@"Request"];
    
    NSString *jsonString = [ELongSession jsonstring:jsonDict];
    return jsonString;
}

+ (NSString *) jsonstring:(id) data
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *) convertDateToString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSDate *) dateFromString:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
//    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
//    [dateFormatter setLocale:usLocale];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'00:00:00ZZZZZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+ (NSString *) currencyWithCode:(NSString *) code
{
    if ([code isEqualToString:@"RMB"]) {
        return @"￥";
    }
    return code;
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString*) doCipher:(NSString*)encryptValue {
    
    NSString* key = appKey1;
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    plainTextBufferSize = [encryptValue length];
    vplainText = (const void *) [encryptValue UTF8String];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t *movedBytes = NULL;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    
    //NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [key UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCModeCBC,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySizeDES,
                       vinitVec,// vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       movedBytes);
    
    NSString *result;
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    result = [myData base64Encoding];
    
    return result;
}

@end
