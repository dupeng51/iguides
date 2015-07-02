//
//  SkySession.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SkySession.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "NSObject+JTObjectMapping.h"
#import "Itinerary.h"
#import "Station.h"
#import "PriceOption.h"
#import "Carriers.h"
#import "FlightNumber.h"
#import "SkyUtils.h"


#define CreatingSessionURL @"http://partners.api.skyscanner.net/apiservices/pricing/v1.0"

#define statusPending @"UpdatesPending"
#define statusBookPending @"Pending"

@implementation SkySession
{
    NSString *locationURL;
    NSString *sessionKey;
    NSString *bookingLocationURL;
    NSString *sortTypeName;
    NSDictionary *searchParams;
    //map object
    NSDictionary *currencyMaping;
    NSDictionary *segmentMaping;
    NSDictionary *flightsMapping;
    NSDictionary *itineraryMapping;
    NSDictionary *legsMapping;
    NSDictionary *flightNumberMaping;
    NSDictionary *queryMaping;
    NSDictionary *agentsMaping;
    NSDictionary *priceOptionMaping;
    NSDictionary *carriersMaping;
    NSDictionary *placeMaping;
    //book map object
    NSDictionary *bookItemMaping;
    NSDictionary *bookOptionMaping;
    NSDictionary *bookMapping;
}

- (instancetype)initWithParams:(NSDictionary *) params
{
    self = [super init];
    if (self) {
        searchParams = params;
        _status = SESSIONSTATUS_NOTCREATE;
        [self createSession:params];
        
        [self initMapObject];
    }
    return self;
}

- (void)dealloc
{
    _flights = nil;
    sortTypeName = nil;
    searchParams = nil;
    _delegate = nil;
    sessionKey = nil;
    
    currencyMaping = nil;
    segmentMaping = nil;
    flightsMapping = nil;
    itineraryMapping = nil;
    legsMapping = nil;
    flightNumberMaping = nil;
    queryMaping = nil;
    agentsMaping = nil;
    priceOptionMaping = nil;
    carriersMaping = nil;
    placeMaping = nil;
    
    bookItemMaping = nil;
    bookOptionMaping = nil;
    bookMapping = nil;
}

#pragma mark Public

-(NSString *) getQuerySortTypeName
{
    return sortTypeName;
}

-(void) searchItinerariesWithSortType:(NSString *) sortName page:(int) pageIndex stops:(int) stopcount
{
    if (!locationURL) {
//        [self createSession:params];
    } else {
        sortTypeName = sortName;
        [self pollSession:sortName page:pageIndex stops:stopcount];
    }
}

-(Agents *) getAgentByID:(NSNumber *) agentid
{
    for (Agents *agent in self.flights.agents) {
        if (agentid.intValue  == agent.idString.intValue) {
            return agent;
        }
    }
    return nil;
}

-(Leg *) getLegByLegid:(NSString *) legid {
    for (Leg *leg in self.flights.legs) {
        if ([legid isEqualToString:leg.idString]) {
            for (FlightNumber *flightNumbers in leg.flightNumbers) {
                Carriers *carrier = [self getCarrierByID: flightNumbers.carrierId];
                flightNumbers.carrier_ = carrier;
            }
            NSMutableArray *segments = [[NSMutableArray alloc] init];
            for (NSNumber *segmentid in leg.segmentIds) {
                SegmentSkyModel *segment = [self getSegmentByID:segmentid];
                if (!segment) {
                    NSLog(@"can't find segmentid %@", segmentid.stringValue);
                }
                [segments addObject:segment];
            }
            leg.segments_ = segments;
            
            NSMutableArray *stops = [[NSMutableArray alloc] init];
            for (NSNumber *stopid in leg.stops) {
                if (stopid.intValue != 0) {
                    Station *station = [self getStationByID:stopid];
                    if (!station) {
                        NSLog(@"can't find stopid %@", stopid.stringValue);
                    }
                    [stops addObject:station];
                }
            }
            leg.stops_ = stops;
            
            NSMutableArray *operatingCarriers = [[NSMutableArray alloc] init];
            for (NSNumber *operatingCarrierid in leg.operatingCarriers) {
                Carriers *carrier = [self getCarrierByID:operatingCarrierid];
                if (!carrier) {
                    NSLog(@"can't find operatingCarrierid %@", operatingCarrierid.stringValue);
                }
                [operatingCarriers addObject:carrier];
            }
            leg.operatingCarriers_ = operatingCarriers;
            
            NSMutableArray *carriers = [[NSMutableArray alloc] init];
            for (NSNumber *carrierid in leg.carriers) {
                Carriers *carrier = [self getCarrierByID:carrierid];
                if (!carrier) {
                    NSLog(@"can't find carrierid %@", carrierid.stringValue);
                }
                [carriers addObject:carrier];
            }
            leg.carriers_ = carriers;
            
            leg.originStation_ = [self getStationByID:leg.originStation];
            leg.destinationStation_ = [self getStationByID:leg.destinationStation];
//            leg.arrival = [self getFormatedDate:leg.arrival];
//            leg.departure = [self getFormatedDate:leg.departure];
            
            return leg;
        }
    }
    return nil;
}

-(Station *) getStationByID:(NSNumber *) stationid
{
    for (Station *station in self.flights.places) {
        if (stationid.intValue == station.idString.intValue) {
            return station;
        }
    }
    return nil;
}

-(Station *) getCityByID:(NSNumber *) stationid
{
    for (Station *station in self.flights.places) {
        if (stationid.intValue == station.idString.intValue) {
            if ([station.type isEqualToString:@"City"]) {
                return station;
            } else if([station.type isEqualToString:@"Country"]) {
                return nil;
            } else {
                return [self getCityByID:station.parentId];
            }
        }
    }
    return nil;
}

-(Carriers *) getCarrierByID:(NSNumber *) carrierid
{
    for (Carriers *carrier in self.flights.carriers) {
        if (carrierid.intValue == carrier.idString.intValue) {
            return carrier;
        }
    }
    return nil;
}

-(SegmentSkyModel *) getSegmentByID:(NSNumber *) segmentid
{
    for (SegmentSkyModel *segment in self.flights.segments) {
        if (segmentid.intValue  == segment.idString.intValue) {
            segment.carrier_ = [self getCarrierByID:segment.carrier];
            segment.operatingCarrier_ = [self getCarrierByID:segment.operatingCarrier];
            segment.originStation_ = [self getStationByID:segment.originStation];
            segment.destinationStation_ = [self getStationByID:segment.destinationStation];
            return segment;
        }
    }
    return nil;
}

-(CurrencySkyModel *) getCurrency
{
    return [self getCurrencyByID: self.flights.query.currency];
}

-(NSString *) getFormatedDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *date1 = [dateFormatter stringFromDate:date];
    return date1;
    
}


#pragma mark Private

-(void) appendItineraryData:(NSArray *) itinerarys
{
    for (Itinerary *itinerary in itinerarys) {
        itinerary.outboundLeg_ = [self getLegByLegid:itinerary.outboundLegId];
        itinerary.inboundLeg_ = [self getLegByLegid:itinerary.inboundLegId];
        for (PriceOption *priceOption in itinerary.pricingOptions) {
            NSMutableArray *agents = [[NSMutableArray alloc] init];
            for (NSNumber *agintid in priceOption.agents) {
                Agents *agent = [self getAgentByID:agintid];
                [agents addObject:agent];
            }
            priceOption.agents_ = agents;
        }
        
    }
}

-(void) appendBookData:(NSArray *) bookOptions
{
    for (BookOptionSkyModel *bookOption in bookOptions) {
        for (BookItemSkyModel *bookItem in bookOption.bookingItems) {
            bookItem.agents_ = [self getAgentByID:bookItem.agentid];
        }
    }
}

-(void) pollSession:(NSString *) sortName page:(int) pageIndex stops:(int) stopcount
{
    if (_status == SESSIONSTATUS_SEARCHED) {
        
    } else {
        _status = SESSIONSTATUS_SEARCHING;
    }
        //        NSString *urlString = [NSString stringWithFormat:@"%@?apiKey=%@",locationURL, apiKey];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                                [NSURL URLWithString:locationURL]];
        //        NSDictionary *params;
        //        if ([sender isKindOfClass:[NSDictionary class]]) {
        //            params = sender;
        //        } else {
        //            params = ((NSTimer *) sender).userInfo;
        //        }
        NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [SkyUtils getAPIKey], @"apiKey",
                                 sortName, @"sorttype",
                                 [NSNumber numberWithInt:stopcount], @"stops",
                                 @"asc", @"sortorder",
//                                 [NSString stringWithFormat:@"%d",pageIndex], @"pageindex",
//                                 @"100", @"pagesize",
                                 nil];
        [client getPath:@"" parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _status = SESSIONSTATUS_SEARCHED;
            
            NSDictionary *headers = operation.response.allHeaderFields;
            if (!locationURL) {
                locationURL = [headers objectForKey:@"Location"];
            }
            
//            NSLog(@"Response Header: %@", headers);
            //            NSLog(@"Response Body: %@", responseObject);
            
            Flights *flights =[self getMapedObject:responseObject];
            sessionKey =  flights.sessionKey;
            if (!self.flights) {
                self.flights = flights;
            } else {
                [self appendBaseDataToFlights:flights];
            }
            [self appendItineraryData:flights.itinerarys];
            
            [self.delegate returnItinerarys:flights.itinerarys pageIndex:pageIndex];
            
            if ([flights.status isEqualToString:statusPending]) {
                [self pollSession:sortName page:pageIndex stops: stopcount];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _status = SESSIONSTATUS_CREATED;
            NSLog(@"%@", [error localizedDescription]);
        }];
//    }
}

-(void) createSession:(NSDictionary *) params
{
    if (self.status != SESSIONSTATUS_NOTCREATE) {
        return;
    }
    _status = SESSIONSTATUS_CREATING;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?apiKey=%@",CreatingSessionURL, [SkyUtils getAPIKey]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:urlString]];
    [client setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    [client postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *headers = operation.response.allHeaderFields;
        if (!locationURL) {
            locationURL = [headers objectForKey:@"Location"];
        }
        
//        NSLog(@"Response: %@", headers);
        
        //        [self performSelector:@selector(pollSession:) withObject:params1 afterDelay:1.0f];
        
        _status = SESSIONSTATUS_CREATED;
        
        [self.delegate sessionCreated];
        //        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
        //                                                          target:self
        //                                                        selector:@selector(pollSession:)
        //                                                        userInfo:params1
        //                                                         repeats:NO];
        //        [timer setFireDate: [NSDate distantPast]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _status = SESSIONSTATUS_NOTCREATE;
        NSLog(@"%@", [error localizedDescription]);
    }];
}

-(void) createBookSession:(NSDictionary *) params
{
//    if (_status != SESSIONSTATUS_SEARCHED) {
//        return;
//    }
    _status = SESSIONSTATUS_BOOKCREATING;
    
    NSLog(@"Session Key: %@", sessionKey);
//    NSString *urlString = [NSString stringWithFormat:@"%@/booking?apiKey=%@",locationURL, [SkyUtils getAPIKey]];
    NSString *urlString = [NSString stringWithFormat:@"%@/booking",locationURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                            [NSURL URLWithString:urlString]];
//    [client setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [params setValue:[SkyUtils getAPIKey] forKey:@"apiKey"];
    
    [client putPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *headers = operation.response.allHeaderFields;
        if (!bookingLocationURL) {
            bookingLocationURL = [headers objectForKey:@"Location"];
        }
        
//        NSLog(@"Response: %@", headers);
        
        _status = SESSIONSTATUS_BOOKCREATED;
        
        [self.bookDelegate bookSessionCreated];
        
        [self pollBookSession];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"createBookSession error: %@", [error localizedDescription]);
        _status = SESSIONSTATUS_SEARCHED;
//        if (operation.response.statusCode == 410) {
//            [self createBookSession:params];
//        }
       
    }];
}

-(void) pollBookSession
{
    if (_status == SESSIONSTATUS_BOOKCREATED) {
        _status = SESSIONSTATUS_BOOKSEARCHING;
//        NSString *urlString = [NSString stringWithFormat:@"%@?apiKey=%@",locationURL, apiKey];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                                [NSURL URLWithString:bookingLocationURL]];
        //        NSDictionary *params;
        //        if ([sender isKindOfClass:[NSDictionary class]]) {
        //            params = sender;
        //        } else {
        //            params = ((NSTimer *) sender).userInfo;
        //        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [SkyUtils getAPIKey], @"apiKey",
                                 nil];
        [client getPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _status = SESSIONSTATUS_BOOKSEARCHED;
            
            NSDictionary *headers = operation.response.allHeaderFields;
            if (!bookingLocationURL) {
                bookingLocationURL = [headers objectForKey:@"Location"];
            }
            
//            NSLog(@"Response Header: %@", headers);
            //            NSLog(@"Response Body: %@", responseObject);
            
            BookOptionsSkyModel *books =[self getBookMapedObject:responseObject];
            
//            [self appendBaseDataToFlights:flights];
            
            [self appendBookData:books.bookingOptions];
            
            [self.bookDelegate returnBooks:books.bookingOptions];
            
            for (BookOptionSkyModel *bookOption in books.bookingOptions) {
                for (BookItemSkyModel *bookItem in bookOption.bookingItems) {
                    if ([bookItem.status isEqualToString:statusBookPending]) {
                        [self pollBookSession];
                        break;
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _status = SESSIONSTATUS_BOOKCREATED;
            NSLog(@"pollBookSession error: %@", [error localizedDescription]);
        }];
    }
}


-(CurrencySkyModel *) getCurrencyByID:(NSString *) currencyCode
{
    for (CurrencySkyModel *currency in self.flights.currencies) {
        if ([currencyCode isEqualToString: currency.code]) {
            return currency;
        }
    }
    return nil;
}

-(void) appendBaseDataToFlights:(Flights *) data
{
    self.flights.agents = [data.agents arrayByAddingObjectsFromArray:self.flights.agents];
    self.flights.carriers = [data.carriers arrayByAddingObjectsFromArray:self.flights.carriers];
    self.flights.currencies = [data.currencies arrayByAddingObjectsFromArray:self.flights.currencies];
    self.flights.legs = [data.legs arrayByAddingObjectsFromArray:self.flights.legs];
    self.flights.places = [data.places arrayByAddingObjectsFromArray:self.flights.places];
    self.flights.segments = [data.segments arrayByAddingObjectsFromArray:self.flights.segments];
}

-(BookOptionsSkyModel *) getBookMapedObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        //        NSDictionary *itinerary = [((NSArray *)[json objectForKey:@"Itineraries"]) objectAtIndex:0];
        
        BookOptionsSkyModel *books = [BookOptionsSkyModel objectFromJSONObject:json mapping:bookMapping];
        
        return books;
    }
    return nil;
}

-(Flights *) getMapedObject:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:NULL];
        //        NSDictionary *itinerary = [((NSArray *)[json objectForKey:@"Itineraries"]) objectAtIndex:0];
        
        Flights *flights = [Flights objectFromJSONObject:json mapping:flightsMapping];
        
        return flights;
    }
    return nil;
}

-(void) initMapObject{
    currencyMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"code", @"Code",
                      @"decimalDigits", @"DecimalDigits",
                      @"decimalSeparator", @"DecimalSeparator",
                      @"roundingCoefficient", @"RoundingCoefficient",
                      @"spaceBetweenAmountAndSymbol", @"SpaceBetweenAmountAndSymbol",
                      @"symbol", @"Symbol",
                      @"symbolOnLeft",@"SymbolOnLeft",
                      @"thousandsSeparator",@"ThousandsSeparator",
                      nil];
    segmentMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"arrivalDateTime", @"ArrivalDateTime",
                     @"carrier", @"Carrier",
                     @"departureDateTime", @"DepartureDateTime",
                     @"destinationStation", @"DestinationStation",
                     @"directionality", @"Directionality",
                     @"duration", @"Duration",
                     @"flightNumber",@"FlightNumber",
                     @"idString",@"Id",
                     @"journeyMode", @"JourneyMode",
                     @"operatingCarrier",@"OperatingCarrier",
                     @"originStation",@"OriginStation",
                     nil];
    queryMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"adults", @"Adults",
                   @"cabinClass", @"CabinClass",
                   @"children", @"Children",
                   @"country", @"Country",
                   @"currency", @"Currency",
                   @"destinationPlace", @"DestinationPlace",
                   @"groupPricing",@"GroupPricing",
                   @"infants",@"Infants",
                   @"locale", @"Locale",
                   @"locationSchema",@"LocationSchema",
                   @"originPlace",@"OriginPlace",
                   @"outboundDate",@"OutboundDate",
                   @"inboundDate",@"inboundDate",
                   nil];
    agentsMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"idString", @"Id",
                    @"name", @"Name",
                    @"imageUrl", @"ImageUrl",
                    @"status", @"Status",
                    @"optimisedForMobile", @"OptimisedForMobile",
                    @"bookingNumber", @"BookingNumber",
                    @"type",@"Type",
                    nil];
    priceOptionMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                         //                                           [Agents mappingWithKey:@"agents" mapping:agentsMaping], @"Agents",
                         @"quoteAgeInMinutes", @"QuoteAgeInMinutes",
                         @"price", @"Price",
                         @"deeplinkUrl", @"DeeplinkUrl",
                         nil];
    carriersMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"idString", @"Id",
                      @"code", @"Code",
                      @"name", @"Name",
                      @"imageUrl", @"ImageUrl",
                      @"displayCode", @"DisplayCode",
                      nil];
    placeMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"idString", @"Id",
                   @"parentId", @"ParentId",
                   @"code", @"Code",
                   @"type", @"Type",
                   @"name", @"Name",
                   nil];
    flightNumberMaping = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"flightNumber", @"FlightNumber",
                          @"carrierId", @"CarrierId",
                          nil];
    legsMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"idString", @"Id",
                   @"segmentIds", @"SegmentIds",
                   @"originStation", @"OriginStation",
                   @"destinationStation", @"DestinationStation",
                   @"departure", @"Departure",
                   @"arrival", @"Arrival",
                   @"duration", @"Duration",
                   @"journeyMode", @"JourneyMode",
                   @"stops", @"Stops",
                   @"carriers", @"Carriers",
                   @"operatingCarriers", @"OperatingCarriers",
                   @"directionality", @"Directionality",
                   [FlightNumber mappingWithKey:@"flightNumbers" mapping:flightNumberMaping], @"FlightNumbers",
                   nil];
    //        NSDictionary *itineraryDict = [json objectForKey:@"Itineraries"];
    itineraryMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"bookingDetailsLinkURI", @"BookingDetailsLink.Uri",
                        @"bookingDetailsLinkBody", @"BookingDetailsLink.Body",
                        @"bookingDetailsLinkBodyMethod", @"BookingDetailsLink.Method",
                        @"outboundLegId", @"OutboundLegId",
                        @"inboundLegId", @"InboundLegId",
                        [PriceOption mappingWithKey:@"pricingOptions" mapping:priceOptionMaping], @"PricingOptions",
                        nil];
    flightsMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                      [Itinerary mappingWithKey:@"itinerarys" mapping:itineraryMapping], @"Itineraries",
                      [Agents mappingWithKey:@"agents" mapping:agentsMaping], @"Agents",
                      [Carriers mappingWithKey:@"carriers" mapping:carriersMaping], @"Carriers",
                      [CurrencySkyModel mappingWithKey:@"currencies" mapping:currencyMaping], @"Currencies",
                      [Leg mappingWithKey:@"legs" mapping:legsMapping], @"Legs",
                      [Station mappingWithKey:@"places" mapping:placeMaping], @"Places",
                      [QuerySkyModel mappingWithKey:@"query" mapping:queryMaping], @"Query",
                      [SegmentSkyModel mappingWithKey:@"segments" mapping:segmentMaping], @"Segments",
                      @"sessionKey", @"SessionKey",
                      @"status", @"Status",
                      nil];
    
    bookItemMaping =[NSDictionary dictionaryWithObjectsAndKeys:
                     @"agentid", @"AgentID",
                     @"alternativeCurrency", @"AlternativeCurrency",
                     @"alternativePrice", @"AlternativePrice",
                     @"deeplink", @"Deeplink",
                     @"price", @"Price",
                     @"segmentIds", @"SegmentIds",
                     @"status", @"Status",
                     nil];
    bookOptionMaping =[NSDictionary dictionaryWithObjectsAndKeys:
                     [BookItemSkyModel mappingWithKey:@"bookingItems" mapping:bookItemMaping], @"BookingItems",
                     nil];
    bookMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                   [BookOptionSkyModel mappingWithKey:@"bookingOptions" mapping:bookOptionMaping], @"BookingOptions",
                   [Carriers mappingWithKey:@"carriers" mapping:carriersMaping], @"Carriers",
                   [Station mappingWithKey:@"places" mapping:placeMaping], @"Places",
                   [QuerySkyModel mappingWithKey:@"query" mapping:queryMaping], @"Query",
                   [SegmentSkyModel mappingWithKey:@"segments" mapping:segmentMaping], @"Segments",
                   nil];

}

@end
