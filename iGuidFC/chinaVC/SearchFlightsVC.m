//
//  SearchFlightsVC.m
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SearchFlightsVC.h"
#import "AllFlightsVC.h"
#import "SkySession.h"
#import "QueryModel.h"
#import "EventKitDataSource.h"
#import "NSDate+Convenience.h"

#define  economyString @"Economy"
#define  premiumEconomyString @"Premium Economy"
#define  businessString @"Business Class"
#define  firstClassString @"First Class"

@interface SearchFlightsVC ()

@end

@implementation SearchFlightsVC
{
    SearchPlaceVC *searchDepartPlace;
    SearchPlaceVC *searchDestinationPlace;
    QueryModel *query;
    KalViewController *kal;
    id dataSource;
}

- (void)dealloc
{
    searchDepartPlace = nil;
    searchDestinationPlace = nil;
    query = nil;
    kal = nil;
    
    _tripDate = nil;
    _startPlace = nil;
    _toPlace = nil;
    _tripDateLabel = nil;
    _passengerLabel = nil;
    _carbinLabel = nil;
    _directSwitch = nil;
    _searchBtn = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    query = [[QueryModel alloc] init];
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    NSString *languageCode = [NSString stringWithFormat:@"%@-%@", [[NSLocale preferredLanguages] objectAtIndex:0], countryCode];
    //CN
    query.country = countryCode;
    //CNY
    query.currency = currencyCode;
    //en-GB
    query.locale = languageCode;
    query.originPlace = @"NYCA-sky";
    query.destinationPlace = @"BJSA-sky";
    query.outboundDate = [SkyUtils convertDateToString:[[NSDate date] offsetDay:2]];
    query.inboundDate = [SkyUtils convertDateToString:[[NSDate date] offsetDay:4]];
    query.adults = @"1";
    query.children = @"0";
    query.infants = @"0";
    query.cabinClass = @"Economy";
    
    [self showData];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.searchBtn.layer setCornerRadius:8];
    [self.searchBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {//place
            switch (indexPath.row) {
                case 0:
                {//from
                    [self showSearchVC:YES];
                    break;
                }
                case 1:
                {// to
                    [self showSearchVC:NO];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {//date
            switch (indexPath.row) {
                case 0:
                {//out bound date
                    [self showDate];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            if (indexPath.row == 0) {
                //passenger
                [self showPassengers];
            } else {
                //cabin class
                [self showCabinClass];
            }
            break;
        }
        default:
            break;
    }
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - searchVCDelegate
- (void) selectPlaces:(PlaceSkyModel *) place depart:(BOOL) isDepart;
{
    if (isDepart) {
        query.originPlace = place.placeId;
        [self.startPlace setText:place.placeName];
    } else {
        query.destinationPlace = place.placeId;
        [self.toPlace setText:place.placeName];
    }
}

#pragma mark - KalDelegate

- (void) selectDate:(NSDate *) beginDate end:(NSDate *) endDate;
{
    NSString *outboundDate =[SkyUtils displayDateToString:beginDate];
    NSString *inboundDate = [SkyUtils displayDateToString:endDate];
    
    query.outboundDate = [SkyUtils convertDateToString:beginDate];
    
    NSString *dateString;
    if (![outboundDate isEqualToString:inboundDate]) {
        query.inboundDate = [SkyUtils convertDateToString:endDate];;
        dateString = [NSString stringWithFormat:@"%@ - %@", outboundDate, inboundDate];
        [self.tripDateLabel setText:@"Date (Round Trip)"];
    } else {
        query.inboundDate = nil;
        dateString = [NSString stringWithFormat:@"%@", outboundDate];
        [self.tripDateLabel setText:@"Date (One Way)"];
    }
    
    [self.tripDate setText:dateString];
    
    
}

#pragma mark actionsheet Delegation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet buttonIndex %ld", (long)buttonIndex);
    if (actionSheet.tag == 1) {
        //select number of passengers
        query.adults = [NSString stringWithFormat:@"%ld", (long)buttonIndex+1];
        NSString *unitString =@"Traveler";
        if (buttonIndex>0) {
            unitString = @"Travelers";
        }
        [self.passengerLabel setText:[NSString stringWithFormat:@"%d %@", query.adults.intValue, unitString]];
    } else if (actionSheet.tag == 2) {
        //select carbin class
        switch (buttonIndex) {
            case 0:
            {
                query.cabinClass = @"Economy";
                [self.carbinLabel setText:economyString];
                break;
            }
            case 1:
            {
                query.cabinClass = @"PremiumEconomy";
                [self.carbinLabel setText:premiumEconomyString];
                break;
            }
            case 2:
            {
                query.cabinClass = @"Business";
                [self.carbinLabel setText:businessString];
                break;
            }
            case 3:
            {
                query.cabinClass = @"First";
                [self.carbinLabel setText:firstClassString];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - Action

-(IBAction)skyBtn:(id)sender
{
    NSString *link = @"http://www.skyscanner.net/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[AllFlightsVC class]]) {
//        query.originPlace = @"NYCA-sky";
//        query.destinationPlace = @"BJSA-sky";
//        query.outboundDate = @"2015-05-21";
//        query.inboundDate = @"2015-05-28";
        
//        NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"CN", @"country",
//                                 @"CNY", @"currency",
//                                 @"en-GB", @"locale",
//                                 @"NYCA-sky", @"originplace",
//                                 @"BJSA-sky", @"destinationplace",
//                                 @"2015-05-21", @"outbounddate",
//                                 @"2015-05-28", @"inbounddate",
//                                 @"1", @"adults",
//                                 nil];

        AllFlightsVC *flightsVC =  [segue destinationViewController];
        BOOL isReturn = (query.inboundDate != nil);
        [flightsVC initData:query isReturn:NO itinerary:nil limitedItinerarys:nil allsession:nil];
        if (self.directSwitch.on) {
            flightsVC.stopcount = 0;
        } else {
            flightsVC.stopcount = 3;
        }
        
    };
}
#pragma mark - private

- (void) showData
{
    NSString *dateString;
    NSString * inboundDate = [SkyUtils displayDateWithString:query.inboundDate] ;
    NSString * outboundDate = [SkyUtils displayDateWithString:query.outboundDate];
    
    if (![query.outboundDate isEqualToString:inboundDate]) {
        dateString = [NSString stringWithFormat:@"%@ - %@", outboundDate, inboundDate];
        [self.tripDateLabel setText:@"Date (Round Trip)"];
    } else {
        dateString = [NSString stringWithFormat:@"%@", outboundDate];
        [self.tripDateLabel setText:@"Date (One Way)"];
    }
    
    [self.tripDate setText:dateString];
}

- (void) showSearchVC:(BOOL) depart
{
    if (depart) {
        if (!searchDepartPlace) {
            searchDepartPlace = [self.storyboard instantiateViewControllerWithIdentifier:@"searchPlace"];
            searchDepartPlace.delegate = self;
            searchDepartPlace.isDepart = depart;
        }
        [self presentViewController:searchDepartPlace animated:true completion:^{
        }];
    } else {
        if (!searchDestinationPlace) {
            searchDestinationPlace = [self.storyboard instantiateViewControllerWithIdentifier:@"searchPlace"];
            searchDestinationPlace.delegate = self;
            searchDestinationPlace.isDepart = depart;
        }
        [self presentViewController:searchDestinationPlace animated:true completion:^{
        }];
    }
}

- (void) showDate
{
    if (!kal) {
        kal = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeRange];
        if (query.outboundDate) {
            kal.beginDate = [SkyUtils convertDateFromString:query.outboundDate];
        } else {
            kal.beginDate =  [NSDate dateStartOfDay:[[NSDate date] offsetDay:1]];
        }
        if (query.inboundDate) {
            kal.endDate = [SkyUtils convertDateFromString:query.inboundDate];
        } else {
            kal.endDate = [kal.beginDate offsetDay:1];
        }
        
        kal.title = @"NatddddiveCal";
        kal.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", @"") style:UIBarButtonItemStyleBordered target:self action:nil];
        kal.delegate1 = self;
        dataSource = [[EventKitDataSource alloc] init];
        kal.dataSource = dataSource;
        kal.minAvailableDate = [NSDate dateStartOfDay:[NSDate date]];
        kal.maxAVailableDate = [kal.minAvailableDate offsetDay:300];
    }
    

    [self.navigationController presentViewController:kal animated:true completion:^{
    }];
}

-(void) showPassengers
{
    NSString *other1 = @"1 Traveler";
    NSString *other2 = @"2 Travelers";
    NSString *other3 = @"3 Travelers";
    NSString *other4 = @"4 Travelers";
    NSString *other5 = @"5 Travelers";
    NSString *other6 = @"6 Travelers";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3,other4, other5, other6, nil];
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}

-(void) showCabinClass
{
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:economyString, premiumEconomyString, businessString,firstClassString, nil];
    actionSheet.tag = 2;
    
    [actionSheet showInView:self.view];
}

@end
