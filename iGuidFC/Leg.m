//
//  Leg.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Leg.h"
#import "Itinerary.h"


@implementation Leg

-(void)dealloc{
    _arrival = nil;
    _idString = nil;
    _segmentIds = nil;
    _departure = nil;
    _arrival = nil;
    _duration = nil;
    _journeyMode = nil;
    _stops = nil;
    _operatingCarriers = nil;
    _carriers = nil;
    _directionality = nil;
    _flightNumbers = nil;
    _originStation = nil;
    _destinationStation = nil;
    
    _segments_ = nil;
    _stops_ = nil;
    _operatingCarriers_ = nil;
    _carriers_ = nil;
    
    _originStation_ = nil;
    _destinationStation_ = nil;
}

-(NSString *) getFormatedTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *formateddepartureString = [self.departure stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *formatedarrivalString = [self.arrival stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *date1 = [dateFormatter dateFromString:formateddepartureString];
    NSDate *date2 = [dateFormatter dateFromString:formatedarrivalString];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    NSString *dateString1 = [dateFormatter stringFromDate:date1];
    NSString *dateString2 = [dateFormatter stringFromDate:date2];
    return [NSString stringWithFormat:@"%@ - %@", dateString1, dateString2];
}

-(NSString *) getFormatedStartDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *formateddepartureString = [self.departure stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *date1 = [dateFormatter dateFromString:formateddepartureString];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    
    NSString *dateString1 = [dateFormatter stringFromDate:date1];
    return  dateString1;
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


@end
