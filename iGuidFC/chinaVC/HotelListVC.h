//
//  HotelListVC.h
//  iGuidFC
//
//  Created by dampier on 15/5/19.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELongSession.h"

@interface HotelListVC : UITableViewController<ELongDelegation>

-(void) initData:(NSString *) cityID arrivalDate:(NSDate *) arrivalDate departureDate:(NSDate *)departureDate queryText:(NSString *) queryText;

@end
