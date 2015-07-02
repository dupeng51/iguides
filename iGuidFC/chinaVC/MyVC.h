//
//  MyVC.h
//  iGuidFC
//
//  Created by dampier on 15/6/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSession.h"

@interface MyVC : UITableViewController<LocalDelegation>

- (IBAction)logoutAction:(id)sender;

@end
