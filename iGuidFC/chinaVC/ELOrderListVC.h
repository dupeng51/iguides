//
//  ELOrderListVC.h
//  iGuidFC
//
//  Created by dampier on 15/6/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELongSession.h"

typedef enum {
    ORDERTYPE_HOTEL =1,
    ORDERTYPE_CARRENTAL,
} OrderType;

@interface ELOrderListVC : UITableViewController<ELongDelegation>

-(void) initWithMode:(OrderType) orderType;

@end
