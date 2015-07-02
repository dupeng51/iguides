//
//  SkyUtils.m
//  iGuidFC
//
//  Created by dampier on 15/4/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SkyUtils.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "NSObject+JTObjectMapping.h"
#import "PlacesSkyModel.h"
#import "PlaceSkyModel.h"

#define skyURL @"http://partners.api.skyscanner.net/apiservices/autosuggest/v1.0"
#define apiKey @"tr781224477297939107692161184415"

@implementation SkyUtils
{
    NSDictionary *placeMap;
    NSDictionary *placesMap;
}

- (void)dealloc
{
    placeMap = nil;
    placesMap = nil;
}

- (void) queryLocation:(NSString *) queryString
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    NSString *languageCode = [NSString stringWithFormat:@"%@-%@", [[NSLocale preferredLanguages] objectAtIndex:0], countryCode];
    
    NSString *queryURL = [NSString stringWithFormat:@"%@/%@/%@/%@", skyURL, countryCode, currencyCode, languageCode];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:queryURL]];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                             queryString, @"query",
                             [SkyUtils getAPIKey], @"apiKey",
                             nil];
    [client getPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *headers = operation.response.allHeaderFields;

        
        NSLog(@"Response Header: %@", headers);
//        NSLog(@"Response Body: %@", responseObject);
        
        PlacesSkyModel *places =[self getXMLObject:responseObject];
        
        [self.delegate responsePlaces:places.places];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    //    }
}

-(PlacesSkyModel *) getXMLObject:(id) responseObject
{
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:0
                                                                error:NULL];
        
        if (!placeMap) {
            placeMap = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"placeId", @"PlaceId",
                      @"placeName", @"PlaceName",
                        @"countryId", @"CountryId",
                        @"regionId", @"RegionId",
                        @"cityId", @"CityId",
                        @"countryName", @"CountryName",
                                  nil];
        }
        if (!placesMap) {
            placesMap = [NSDictionary dictionaryWithObjectsAndKeys:
                         [PlaceSkyModel mappingWithKey:@"places" mapping:placeMap], @"Places",
                         nil];
        }
        

        PlacesSkyModel *places = [PlacesSkyModel objectFromJSONObject:json  mapping:placesMap];
        
        return places;
        
    }
    return nil;
}

+(NSString *) getAPIKey
{
    return apiKey;
}

+(NSDate *) convertDateFromString:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+(NSString *) convertDateToString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+(NSString *) displayDateToString:(NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+(NSString *) displayDateWithString:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString1 = [dateFormatter stringFromDate:date];
    
    return dateString1;
}


@end
