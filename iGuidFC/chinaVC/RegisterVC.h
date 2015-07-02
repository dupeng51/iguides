//
//  RegisterVC.h
//  iGuidFC
//
//  Created by dampier on 15/6/3.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSession.h"

@interface RegisterVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LocalDelegation>

@property (nonatomic,strong) IBOutlet UITableView *registerTableView;

@end
