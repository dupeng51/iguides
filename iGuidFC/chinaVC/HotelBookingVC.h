//
//  HotelBookingVC.h
//  iGuidFC
//
//  Created by dampier on 15/5/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELongSession.h"
#import "ELongHotel.h"
#import "ELRoom.h"
#import "ELRatePlan.h"

@interface HotelBookingVC : UITableViewController<ELongDelegation, UIActionSheetDelegate, UITextFieldDelegate>

-(IBAction)bookAction:(id)sender;
-(void) initDataWithHotel:(ELongHotel *) hotelData room:(ELRoom *) room ratePlan:(ELRatePlan *) ratePlan arriveDate:(NSDate *) arriveDate departDate:(NSDate *) departDate;

@end
