//
//  MyVC.m
//  iGuidFC
//
//  Created by dampier on 15/6/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "MyVC.h"
#import "ELOrderListVC.h"
#import "ServiceUtils.h"

@interface MyVC ()

@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 1) {
        ELOrderListVC *hotelVC = [segue destinationViewController];
        if (indexPath.row == 0) {
            //hotel
            [hotelVC initWithMode:ORDERTYPE_HOTEL];
        }
        if (indexPath.row== 1) {
            [hotelVC initWithMode:ORDERTYPE_CARRENTAL];
        }
    }
}

#pragma mark - Actions

- (IBAction)logoutAction:(id)sender
{
    LocalSession *session = [[LocalSession alloc] init];
    [session setDelegate:self];
    [session signout];
}

#pragma mark - Localsession Delegate

- (void)returnSignout
{
    [LocalSession setEmptyLogInfo];
    [ServiceUtils removePassword];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
