//
//  SegmentSkyModel.m
//  iGuidFC
//
//  Created by dampier on 15/4/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SegmentSkyModel.h"

@implementation SegmentSkyModel

- (void)dealloc
{
    _arrivalDateTime = nil;
    _carrier = nil;
    _departureDateTime = nil;
    _destinationStation = nil;
    _directionality = nil;
    _duration = nil;
    _flightNumber = nil;
    _idString = nil;
    _journeyMode = nil;
    _operatingCarrier = nil;
    _originStation = nil;
    
    _carrier_ = nil;
    _operatingCarrier_ = nil;
    _originStation_ = nil;
    _destinationStation_ = nil;
}

-(NSString *) getFormatedDuration
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *durationFormated = [NSString stringWithFormat:@"%dh %dm", (int)(self.duration.intValue /60), self.duration.intValue % 60];
    return durationFormated;
}

-(NSString *) getFormatedDepartureDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *formateddepartureString = [self.departureDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *date = [dateFormatter dateFromString:formateddepartureString];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

-(NSString *) getFormatedTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *formateddepartureString = [self.departureDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *formatedarrivalString = [self.arrivalDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *date1 = [dateFormatter dateFromString:formateddepartureString];
    NSDate *date2 = [dateFormatter dateFromString:formatedarrivalString];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    NSString *dateString1 = [dateFormatter stringFromDate:date1];
    NSString *dateString2 = [dateFormatter stringFromDate:date2];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}

@end
