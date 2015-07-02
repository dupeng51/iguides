//
//  LeftMenuVC.h
//  AMSlideMenu
//
//  Created by Artur Mkrtchyan on 12/24/13.
//  Copyright (c) 2013 Artur Mkrtchyan. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"
#import "LocalSession.h"

@interface LeftMenuVC : AMSlideMenuLeftTableViewController<LocalDelegation>

@property IBOutlet UIButton *userBtn;
@property IBOutlet UIImageView *userImage;

- (IBAction)userAction:(id)sender;

@end
