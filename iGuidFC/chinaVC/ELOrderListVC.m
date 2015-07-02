//
//  ELOrderListVC.m
//  iGuidFC
//
//  Created by dampier on 15/6/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "ELOrderListVC.h"


@interface ELOrderListVC ()

@end

@implementation ELOrderListVC
{
    OrderType hoteltype;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //    NSString *jsonString = [ELongSession jsonstringWithData:jsonParmDict];
    ELongSession *session = [[ELongSession alloc] init];
    [session setDelegate:self];
    [session hotelOrderDetail:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initWithMode:(OrderType) orderType
{
    hoteltype = orderType;
}

#pragma mark - ELong Delegate

- (void)returnOrderDetail:(ELOrderDetail *) hotelData
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return elongResult.hotels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configHotelCell:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELongHotel *hotel = elongResult.hotels[indexPath.row];
    
    HotelDetailVC *hotelDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"hotelDetail"];
    [hotelDetailVC initData:hotel.hotelId arrivalDate:arrivalDate_ departureDate:departureDate_];
    [self.navigationController showViewController:hotelDetailVC sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImageView * carrierImageView = (UIImageView *)[cell viewWithTag:1];
    
    carrierImageView.layer.masksToBounds = YES;
    carrierImageView.layer.cornerRadius = 4;
    
    ELongHotel *hotel = elongResult.hotels[indexPath.row];
    [carrierImageView setImageWithURL:[NSURL URLWithString:hotel.detail.thumbNailUrl] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    //    NSLog(@"hotelName: %@, Url:%@",hotel.detail.hotelName, hotel.detail.thumbNailUrl);
}
*/

@end
