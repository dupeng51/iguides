//
//  ELOrderDetail.h
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELInvoice.h"
#import "ELContact.h"
#import "ELCreditCard.h"
#import "ELNightlyRate.h"
#import "ELGuranteeRule.h"
#import "ELPrepayRule.h"

@interface ELOrderDetail : NSObject

@property (nonatomic, retain) NSNumber * OrderId;
@property (nonatomic, retain) NSNumber * HotelId;
@property (nonatomic, retain) NSString * HotelName;
@property (nonatomic, retain) NSString * RoomTypeId;
@property (nonatomic, retain) NSString * RoomTypeName;
@property (nonatomic, retain) NSNumber * RatePlanId;
@property (nonatomic, retain) NSString * RatePlanName;
@property (nonatomic, retain) NSString * ArrivalDate;
@property (nonatomic, retain) NSString * DepartureDate;
@property (nonatomic, retain) NSString * Status;
@property (nonatomic, retain) NSNumber * ShowStatus;
@property (nonatomic, retain) NSString * ConfirmPoint;
@property (nonatomic, retain) NSString * CustomerType;
@property (nonatomic, retain) NSString * PaymentType;
@property (nonatomic, retain) NSString * NumberOfRooms;
@property (nonatomic, retain) NSString * NumberOfCustomers;
@property (nonatomic, retain) NSString * EarliestArrivalTime;
@property (nonatomic, retain) NSString * LatestArrivalTime;
@property (nonatomic, retain) NSString * CurrencyCode;
@property (nonatomic, retain) NSNumber * TotalPrice;
@property (nonatomic, retain) NSString * ElongCardNo;
@property (nonatomic, retain) NSString * ConfirmationType;
@property (nonatomic, retain) NSString * NoteToHotel;
@property (nonatomic, retain) NSString * NoteToElong;
@property (nonatomic, retain) NSString * NoteToGuest;
@property (nonatomic, retain) NSNumber * PenaltyToCustomer;
@property (nonatomic, retain) NSString * PenaltyCurrencyCode;
@property (nonatomic, retain) NSString * CreationDate;
@property (nonatomic, retain) NSNumber * IsCancelable;
@property (nonatomic, retain) NSString * CancelTime;
@property (nonatomic, retain) NSNumber * HasInvoice;
@property (nonatomic, retain) ELInvoice * Invoice;
@property (nonatomic, retain) ELContact * Contact;
@property (nonatomic, retain) ELCreditCard * CreditCard;
@property (nonatomic, retain) ELNightlyRate * NightlyRates;
@property (nonatomic, retain) NSArray * Customers;
@property (nonatomic, retain) ELGuranteeRule * GuaranteeRule;
@property (nonatomic, retain) ELPrepayRule * PrepayRule;
@property (nonatomic, retain) NSArray * ValueAdds;
@property (nonatomic, retain) NSString * InvoiceMode;

+ (NSDictionary *) mapedObject;

@end
