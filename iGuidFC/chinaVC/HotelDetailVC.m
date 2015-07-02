//
//  HotelDetailVC.m
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelDetailVC.h"
#import "OTCover.h"
#import "UIImageView+AFNetworking.h"
#import "ELongHotel.h"
#import "ELongRoomXML.h"
#import "ELRoom.h"
#import "ELRatePlan.h"
#import "HotelBookingVC.h"
#import "HotelMap.h"

@interface HotelDetailVC ()

@end

#define SummaryScoreCell @"summaryScoreCell"
#define SuccessRateCell @"successrate"
#define ConfirmRateCell @"confirmrateCell"
#define AddressCell @"addressCell"
#define FacilitiesCell @"facilitiesCell"
#define DescriptionCell @"descriptionCell"
#define RoomCell @"roomCell"
#define CoverImageCell @"coverimageCell"
#define ratePlanViewTag 100

#define hieghtOfSummaryPriceCell 90
#define hieghtOfPriceCell 70

@implementation HotelDetailVC
{
    ELongHotelData *hotelXMLData;
    ELongHotel *hotelData;
    OTCover *otcover;
    NSIndexPath * selectedRoomIndex;
    NSDate *arrivalDate_;
    NSDate *departureDate_;
    NSString *hotelID_;
}

- (void)dealloc
{
    hotelData = nil;
    hotelXMLData = nil;
    otcover = nil;
    selectedRoomIndex = nil;
    arrivalDate_ = nil;
    departureDate_ = nil;
    hotelID_ = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    otcover = [[OTCover alloc] initWithTableViewWithHeaderImage:[UIImage imageNamed:@"placeholder.jpg"] withOTCoverHeight:self.view.frame.size.width];
    otcover.tableView.delegate = self;
    otcover.tableView.dataSource = self;
    [self.view addSubview:otcover];
    
    NSMutableDictionary *jsonParmDict = [[NSMutableDictionary alloc]init];
    [jsonParmDict setValue:[ELongSession convertDateToString:arrivalDate_] forKey:@"ArrivalDate"];
    [jsonParmDict setValue:[ELongSession convertDateToString:departureDate_] forKey:@"DepartureDate"];
    [jsonParmDict setValue:hotelID_ forKey:@"HotelIds"];
    [jsonParmDict setValue:@"1,2,3,4" forKey:@"Options"];
    
//    NSString *jsonString = [ELongSession jsonstringWithData:jsonParmDict];
    ELongSession *session = [[ELongSession alloc] init];
    [session setDelegate:self];
//    [session getHotelDetail:jsonString];
    [session getHotelDetail1:jsonParmDict];
    [session getHotelDetailXML:hotelID_];
    
}

-(void) initData:(NSString *) hotelID arrivalDate:(NSDate *) arrivalDate departureDate:(NSDate *)departureDate
{
    arrivalDate_ = arrivalDate;
    departureDate_ = departureDate;
    hotelID_ = hotelID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
        {
            int i = 4;
            if (hotelXMLData.Detail.GeneralAmenities) {
                //fatiliaties
                i++;
            }
            if (hotelXMLData.Detail.IntroEditor) {
                //description
                i++;
            }
            return i;
            break;
        }
        case 1:
        {
            return hotelData.rooms.count;
            break;
        }
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
//                case 0:
//                {
//                    [self configeCoverImageCell:indexPath];
//                    break;
//                }
                case 0:
                {
                    cell = [self configeSummaryScoreCell:indexPath];
                    break;
                }
                case 1:
                {
                    cell = [self configeBookRateCell:indexPath];
                    break;
                }
                case 2:
                {
                    cell = [self configeConfirmCell:indexPath];
                    break;
                }
                case 3:
                {
                    cell = [self configeAddressCell:indexPath];
                    break;
                }
                case 4:
                {
                    if (hotelXMLData.Detail.GeneralAmenities) {
                        //fatiliaties
                        cell = [self configeFacilityCell:indexPath];
                    } else {
                        cell = [self configeDescriptionCell:indexPath];
                    }
                    break;
                }
                case 5:
                {
                    cell = [self configeDescriptionCell:indexPath];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            cell = [self configeRoomCell:indexPath];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
//                case 0:
//                {//cover image
//                    return 300;
//                    break;
//                }
                case 0:
                {
                    return 50;
                    break;
                }
                case 1:
                {
                    return 50;
                    break;
                }
                case 2:
                {
                    return 50;
                    break;
                }
                case 3:
                {
                    return 50;
                    break;
                }
                case 4:
                {
                    return 60;
                    break;
                }
                case 5:
                {
                    return 60;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            //room cell
            if (selectedRoomIndex && indexPath.row == selectedRoomIndex.row) {
                ELRoom *room1 = hotelData.rooms[indexPath.row];
                return hieghtOfSummaryPriceCell + room1.ratePlans.count * hieghtOfPriceCell;
            }
            return hieghtOfSummaryPriceCell;
            break;
        }
        default:
            break;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIImageView * imageView = (UIImageView *)[cell viewWithTag:1];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 4;
        
        ELRoom *room = hotelData.rooms[indexPath.row];
        NSString *imageURL = room.ImageUrl;
        if (!imageURL) {
            imageURL =[hotelData roomImageUrl:room.roomId];
        }
        [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            //address
            
        }
    }
    if (indexPath.section == 1) {
        if (selectedRoomIndex == indexPath) {
            selectedRoomIndex = nil;
        } else {
            selectedRoomIndex = indexPath;
        }
        [tableView beginUpdates];
        
        [tableView endUpdates];
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        ELRoom *room1 = hotelData.rooms[indexPath.row];
//        if (selectedRowIndex && selectedRowIndex == indexPath) {
//            [self addRatePriceWithCell:cell ratePlan:room1.ratePlans];
//        } else {
//            [self removeRatePriceWithCell:cell];
//        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[HotelMap class]]) {
        HotelMap *hotelMap = (HotelMap *)[segue destinationViewController];
        hotelMap.hotelXML = hotelXMLData;
    }
    if ([[segue destinationViewController] isKindOfClass:[HotelBookingVC class]]) {
        HotelBookingVC *hotelBookingVC = (HotelBookingVC *)[segue destinationViewController];
        if ([sender isKindOfClass:[UIButton class]]) {
            int ratePlanIndex = (int)[((UIButton *)sender) superview].tag - ratePlanViewTag;
            ELRoom *room =  hotelData.rooms[selectedRoomIndex.row];
            ELRatePlan *ratePlan = room.ratePlans[ratePlanIndex];
//            NSString *params = [self getParamsWithRatePlanIndex:ratePlanindex];
            [hotelBookingVC initDataWithHotel:hotelData room:room ratePlan:ratePlan arriveDate:arrivalDate_ departDate:departureDate_];
            
        }
    }
}


#pragma mark - Action
-(IBAction)ratePlanAction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        int ratePlanindex = (int)[((UIButton *)sender) superview].tag - ratePlanViewTag;
        ELRoom *room =  hotelData.rooms[selectedRoomIndex.row];
        ELRatePlan *ratePlan = room.ratePlans[ratePlanindex];
        
    }
}

#pragma mark - ELSession Delegate
- (void)returnHotelDetail:(ELongResult *) hotelData1
{
    if (hotelData1.hotels.count >0) {
        hotelData = hotelData1.hotels[0];
        [hotelData filterRooms];
        [self refreshView];
    } else {
        NSLog(@"Hotel.Detail Method Eorror: Empty Result!");
    }
    
}
- (void)returnHotelDetailXML:(ELongHotelData *) hotelData1
{
    hotelXMLData = hotelData1;
    [self refreshView];
}

#pragma mark - Inner Method

-(void) refreshView
{
    if (hotelData && hotelXMLData) {
        //title
        [self setTitle:hotelXMLData.Detail.Name];
//        //set cover image
        NSString *coverImageUrl = [hotelData coverImageUrl];
        [otcover setImageUrl:coverImageUrl];
        
        [otcover.tableView reloadData];
//        [self.tableView reloadData];
    }
    
}

-(UITableViewCell *) configeCoverImageCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CoverImageCell];
    
    return cell;
}

-(UITableViewCell *) configeSummaryScoreCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SummaryScoreCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    NSString *summaryScore = [NSString stringWithFormat:@"%d/5",hotelXMLData.Detail.ServiceRank.SummaryScore.intValue];
    [label setText:summaryScore];
    return cell;
}

-(UITableViewCell *) configeBookRateCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SuccessRateCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:hotelXMLData.Detail.ServiceRank.BookingSuccessScore];
    return cell;
}

-(UITableViewCell *) configeConfirmCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ConfirmRateCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:hotelXMLData.Detail.ServiceRank.InstantConfirmScore];
    return cell;
}

-(UITableViewCell *) configeAddressCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AddressCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:hotelXMLData.Detail.Address];
    return cell;
}

-(UITableViewCell *) configeFacilityCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:FacilitiesCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:hotelXMLData.Detail.GeneralAmenities];
    return cell;
}

-(UITableViewCell *) configeDescriptionCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DescriptionCell];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    [label setText:hotelXMLData.Detail.IntroEditor];
    return cell;
}

-(UITableViewCell *) configeRoomCell:(NSIndexPath *) indexPath
{
    ELongRoomXML *room;
    ELRoom *room1 = hotelData.rooms[indexPath.row];
    for (ELongRoomXML *room2 in hotelXMLData.Rooms) {
        if ([room2.Id isEqualToString:room1.roomId]) {
            room = room2;
        }
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RoomCell];
    [cell.contentView clipsToBounds];
    [cell.layer setMasksToBounds:YES];
    [cell clipsToBounds];
    
    if (room1 && room) {
        //name
        UILabel *namelabel = (UILabel *)[cell viewWithTag:2];
        if (![room1.name isEqualToString:@""]) {
            [namelabel setText:room1.name];
        } else {
            [namelabel setText:room1.BedType];
        }
        
        //Area
        UILabel *arealabel = (UILabel *)[cell viewWithTag:3];
        [arealabel setText:[NSString stringWithFormat:@"%@m²", room.Area]];
        
        //Window, free wifi
        UILabel *facilitylabel = (UILabel *)[cell viewWithTag:4];
        [facilitylabel setText:[room roomFacilitySummary]];
        
        //price
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:5];
        [priceLabel setText: [room1 lowestPrice]];
        
        //prepay or selfpay
        UILabel *payLabel = (UILabel *)[cell viewWithTag:6];
        NSString *payment = [((ELRatePlan *)room1.ratePlans[0]) getPaymentType:hotelData arrivalDate:arrivalDate_ departDate:departureDate_];
        [payLabel setText: payment];
        
        [self addRatePriceWithCell:cell ratePlan:room1.ratePlans];
    } else {
        NSLog(@"Room ID is Not Same! XMLID = %@; jsonID = %@", room.Id, room1.roomId);
    }
    return cell;
}

-(void) removeRatePriceWithCell:(UITableViewCell *) cell
{
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
}

-(void) addRatePriceWithCell:(UITableViewCell *) cell ratePlan:(NSArray *) ratePlans
{
    int i = 0;
    for (ELRatePlan *ratePlan1 in ratePlans) {
        UITableViewCell *cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"ratePlanCell"];
        UIView *ratePlanView = cell1.contentView;
        
        CGRect frame = CGRectMake(0, hieghtOfSummaryPriceCell+ i * hieghtOfPriceCell, self.view.frame.size.width, hieghtOfPriceCell);
        [ratePlanView setFrame:frame];
        UILabel *nameLabel = (UILabel *)[ratePlanView viewWithTag:1];
        [nameLabel setText:ratePlan1.ratePlanName];
//        [nameLabel setFrame:CGRectMake(8, 23, self.view.frame.size.width - 8-24, 24)];
//        [nameLabel setFont:[UIFont fontWithName:@"System" size:18]];
//        [ratePlanView addSubview:nameLabel];
        
        UILabel *priceLabel = (UILabel *)[ratePlanView viewWithTag:2];
        [priceLabel setText:[ratePlan1 priceStringWithRoomAmount:[NSNumber numberWithInt:1] isOneNight:YES]];
//        [priceLabel setFrame:CGRectMake(self.view.frame.size.width - 82 - 8, 21, 82, 26)];
//        [priceLabel setFont:[UIFont fontWithName:@"System" size:24]];
//        [ratePlanView addSubview:priceLabel];
        
        UILabel *payLabel = (UILabel *)[ratePlanView viewWithTag:3];
//        [payLabel setTextColor:[UIColor grayColor]];
        [payLabel setText:[ratePlan1 getPaymentType:hotelData arrivalDate:arrivalDate_ departDate:departureDate_]];
//        [payLabel setFont:[UIFont fontWithName:@"System" size:13]];
//        [payLabel setFrame:CGRectMake(self.view.frame.size.width - 62 - 8, 44, 62, 21)];
//        [ratePlanView addSubview:payLabel];
        
        //数量紧缺
        if (ratePlan1.currentAlloment.intValue > 0 && ratePlan1.currentAlloment.intValue < 5) {
            UILabel *leftNumberLabel = (UILabel *)[ratePlanView viewWithTag:5];
            [leftNumberLabel setHidden:NO];
            NSString *leftText;
            if (ratePlan1.currentAlloment.intValue == 1) {
                leftText = [NSString stringWithFormat:@"1 room left"];
            } else {
                leftText = [NSString stringWithFormat:@"%d rooms left", ratePlan1.currentAlloment.intValue];
            }
            [leftNumberLabel setText:leftText];
        }
        
        
        [cell.contentView addSubview:ratePlanView];
        ratePlanView.tag = i + ratePlanViewTag;

        i++;
    }
}

@end
