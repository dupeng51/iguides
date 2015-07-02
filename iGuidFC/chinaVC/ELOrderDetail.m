//
//  ELOrderDetail.m
//  iGuidFC
//
//  Created by dampier on 15/6/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELOrderDetail.h"
#import "ELCustomer.h"
#import "NSObject+JTObjectMapping.h"

@implementation ELOrderDetail

+ (NSDictionary *) mapedObject
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"OrderId", @"OrderId",
            @"HotelId", @"HotelId",
            @"HotelName", @"HotelName",
            @"RoomTypeId", @"RoomTypeId",
            @"RoomTypeName", @"RoomTypeName",
            @"RatePlanId", @"RatePlanId",
            @"RatePlanName", @"RatePlanName",
            @"ArrivalDate", @"ArrivalDate",
            @"DepartureDate", @"DepartureDate",
            @"Status", @"Status",
            @"ShowStatus", @"ShowStatus",
            @"ConfirmPoint", @"ConfirmPoint",
            @"CustomerType", @"CustomerType",
            @"PaymentType", @"PaymentType",
            @"NumberOfRooms", @"NumberOfRooms",
            @"NumberOfCustomers", @"NumberOfCustomers",
            @"EarliestArrivalTime", @"EarliestArrivalTime",
            @"LatestArrivalTime", @"LatestArrivalTime",
            @"CurrencyCode", @"CurrencyCode",
            @"TotalPrice", @"TotalPrice",
            @"ElongCardNo", @"ElongCardNo",
            @"ConfirmationType", @"ConfirmationType",
            @"NoteToHotel", @"NoteToHotel",
            @"NoteToElong", @"NoteToElong",
            @"NoteToGuest", @"NoteToGuest",
            @"PenaltyToCustomer", @"PenaltyToCustomer",
            @"PenaltyCurrencyCode", @"PenaltyCurrencyCode",
            @"CreationDate", @"CreationDate",
            @"IsCancelable", @"IsCancelable",
            @"CancelTime", @"CancelTime",
            @"HasInvoice", @"HasInvoice",
            [ELInvoice mappingWithKey:@"Invoice" mapping:[ELInvoice mapedObject]], @"Invoice",
            [ELContact mappingWithKey:@"Contact" mapping:[ELContact mapedObject]], @"Contact",
            [ELCreditCard mappingWithKey:@"CreditCard" mapping:[ELCreditCard mapedObject]], @"CreditCard",
            [ELNightlyRate mappingWithKey:@"NightlyRates" mapping:[ELNightlyRate mapedObject]], @"NightlyRates",
            [ELCustomer mappingWithKey:@"Customers" mapping:[ELCustomer mapedObject]], @"Customers",
            [ELGuranteeRule mappingWithKey:@"GuaranteeRule" mapping:[ELGuranteeRule mapedObject]], @"GuaranteeRule",
            [ELPrepayRule mappingWithKey:@"PrepayRule" mapping:[ELPrepayRule mapedObject]], @"PrepayRule",
            @"ValueAdds", @"ValueAdds",
            @"InvoiceMode", @"InvoiceMode",
            nil];
}

@end
