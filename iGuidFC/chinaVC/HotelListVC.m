//
//  HotelListVC.m
//  iGuidFC
//
//  Created by dampier on 15/5/19.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelListVC.h"
#import "ELongHotel.h"
#import "UIImageView+AFNetworking.h"
#import "HotelDetailVC.h"

@implementation HotelListVC
{
    ELongResult *elongResult;
    NSDate *arrivalDate_;
    NSDate *departureDate_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc
{
    elongResult = nil;
    arrivalDate_ = nil;
    departureDate_ = nil;
}

- (void) initData:(NSString *) cityID arrivalDate:(NSDate *) arrivalDate departureDate:(NSDate *)departureDate queryText:(NSString *) queryText
{
    arrivalDate_ = arrivalDate;
    departureDate_ = departureDate;
    
    NSMutableDictionary *jsonParmDict = [[NSMutableDictionary alloc]init];
    [jsonParmDict setValue:[ELongSession convertDateToString:arrivalDate] forKey:@"ArrivalDate"];
    [jsonParmDict setValue:[ELongSession convertDateToString:departureDate] forKey:@"DepartureDate"];
    [jsonParmDict setValue:cityID forKey:@"CityId"];
    [jsonParmDict setValue:queryText forKey:@"QueryText"];
    [jsonParmDict setValue:@"3" forKey:@"ResultType"];
    [jsonParmDict setValue:@"1" forKey:@"PageIndex"];
    [jsonParmDict setValue:@"50" forKey:@"PageSize"];
//    [jsonParmDict setValue:@"All" forKey:@"CustomerType"];
    
//    NSString *jsonString = [ELongSession jsonstringWithData:jsonParmDict];
    ELongSession *session = [[ELongSession alloc] init];
    [session setDelegate:self];
//    [session getHotelList:jsonString];
    [session getHotelList1:jsonParmDict];
}

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

#pragma mark ELongSession Delegate

- (void) returnHotelList:(ELongResult *) hotelData
{
    [hotelData filterHotel];
    elongResult = hotelData;
    [self.tableView reloadData];
}

#pragma mark Private Method

-(UITableViewCell *) configHotelCell:(NSIndexPath *) indexPath
{
    ELongHotel *hotel = elongResult.hotels[indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotelCell" forIndexPath:indexPath];
//    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    
    UILabel *hotelNamelabel = (UILabel *)[cell viewWithTag:2];
    [hotelNamelabel setText:hotel.detail.hotelName];
    
    UILabel *reviewRate = (UILabel *)[cell viewWithTag:3];
    [reviewRate setText:hotel.detail.review.score];
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:4];
    NSString *priceString = [[hotel.lowRate stringValue] componentsSeparatedByString:@"."][0];
    [priceLabel setText:[NSString stringWithFormat:@"%@%@", [ELongSession currencyWithCode:hotel.currencyCode], priceString]];
    
    //wifi and parking
    UIImageView *wifiFacility = (UIImageView *)[cell viewWithTag:5];
    UIImageView *parkingFacility = (UIImageView *)[cell viewWithTag:6];
    [wifiFacility setHidden:YES];
    [parkingFacility setHidden:YES];
    if ([hotel haveWifi]) {
        if ([hotel haveParking]) {
            [wifiFacility setImage:[UIImage imageNamed:@"wifi.png"]];
            [wifiFacility setHidden:NO];
            
            [parkingFacility setImage:[UIImage imageNamed:@"parking.png"]];
            [parkingFacility setHidden:NO];
        } else {
            [wifiFacility setImage:[UIImage imageNamed:@"wifi.png"]];
            [wifiFacility setHidden:NO];
        }
    } else {
        if ([hotel haveParking]) {
            [wifiFacility setImage:[UIImage imageNamed:@"parking.png"]];
            [wifiFacility setHidden:NO];
            [parkingFacility setHidden:YES];
        }
    }
    
    return cell;
}

@end
