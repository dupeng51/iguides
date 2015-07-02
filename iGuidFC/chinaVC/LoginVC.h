//
//  LoginVC.h
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalSession.h"

@interface LoginVC : UITableViewController<UITextFieldDelegate, LocalDelegation>

@property IBOutlet UITextField *emailField;
@property IBOutlet UITextField *passwordField;

@end
