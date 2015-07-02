//
//  HotelSearchVC.m
//  iGuidFC
//
//  Created by dampier on 15/5/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelSearchVC.h"
#import "HotelListVC.h"
#import "NSDate+Convenience.h"

@interface HotelSearchVC ()

@end

@implementation HotelSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[HotelListVC class]]) {
        
        HotelListVC *hotelListVC =  [segue destinationViewController];
        [hotelListVC initData:@"2201" arrivalDate:[[NSDate date] offsetDay:2] departureDate:[[NSDate date] offsetDay:5] queryText:@""];
    }
}


@end
