//
//  ELongSession.h
//  iGuidFC
//
//  Created by dampier on 15/5/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongResult.h"
#import "ELongHotelData.h"
#import "ELOrderDetail.h"
#import "HotelCreateResult.h"
#import "Constants.h"

typedef enum {
    SESSIONSTATUS_NOTCREATE =1,
    SESSIONSTATUS_CREATING,
    SESSIONSTATUS_CREATED,
    SESSIONSTATUS_SEARCHING,
    SESSIONSTATUS_SEARCHED,
    
    SESSIONSTATUS_BOOKCREATING,
    SESSIONSTATUS_BOOKCREATED,
    SESSIONSTATUS_BOOKSEARCHING,
    SESSIONSTATUS_BOOKSEARCHED
} SESSIONSTATUS;

@protocol ELongDelegation <NSObject>

@optional

- (void)returnHotelList:(ELongResult *) hotelData;
- (void)returnHotelDetail:(ELongResult *) hotelData;
- (void)returnHotelDetailXML:(ELongHotelData *) hotelData;
- (void)returnHotelCreate:(HotelCreateResult *) hotelData;
- (void)returnCreditCardValidate:(BOOL) isValidate needCVV:(BOOL) needCVV;
- (void)returnCheckGuest:(NSArray *) names;
- (void)returnOrderDetail:(ELOrderDetail *) hotelData;
- (void)returnOrdercancel:(BOOL) cancelSuccess;

@end

@interface ELongSession : NSObject

@property id<ELongDelegation> delegate;

-(void) getHotelList:(NSString *) dataString;
-(void) getHotelList1:(NSDictionary *) params;

-(void) getHotelDetail:(NSString *) dataString;
-(void) getHotelDetail1:(NSDictionary *) params;

-(void) getHotelDetailXML:(NSString *) hotailid;
-(void) creditcardValidate:(NSString *) cardNo;
-(void) orderCheckguest:(NSArray *) names isGangAo:(BOOL) isGangAo;

//order
-(void) hotelOrderCreate:(NSString *) dataString;
-(void) hotelOrderCancel:(NSString *) orderid;
-(void) hotelOrderDetail:(NSString *) userid;

+ (NSString *) jsonstringWithCommonData:(id) data;
+ (NSString *) jsonstring:(id) data;
+ (NSString *) convertDateToString:(NSDate *) date;
+ (NSDate *) dateFromString:(NSString *) dateString;
+ (NSString *) currencyWithCode:(NSString *) code;
+ (NSString *) GetUUID;

@end
