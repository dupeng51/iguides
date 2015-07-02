//
//  HotelBookingVC.m
//  iGuidFC
//
//  Created by dampier on 15/5/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelBookingVC.h"
#import "ServiceUtils.h"
#import "SkyUtils.h"
#import "NSDate+Convenience.h"
#import "LocalSession.h"
#import "ELongBookingRule.h"
#import "Constants.h"
#import "CreditCardVC.h"

@interface HotelBookingVC ()

@end

#define BookingsummaryCell @"bookingsummaryCell"
#define RoomCell @"roomCell"
#define TimeCell @"timeCell"
#define GuestCell @"guestCell"
#define PhoneCell @"phoneCell"
#define EmailCell @"emailCell"
#define GuranteeDescCell @"guranteeDescCell"
#define GiftCell @"giftCell"
#define BookCell @"bookCell"

@implementation HotelBookingVC
{
    NSDictionary *contactDict;
    NSMutableArray *orderRooms;//客人信息
    NSDate *arrivalDate_;
    NSDate *departureDate_;
    NSNumber *roomNumber;
    ELongSession *session;
    NSString *earliestArrivalTime;
    NSString *latestArrivalTime;
    NSDictionary *creditCard;
    ELongHotel *hotelData;
    ELRoom *room;
    ELRatePlan *ratePlan;
    ELGuranteeRule *guaranteeRule;
    ELongBookingRule *bookRule;
    NSArray *gifts;
    UITextField *currentTextField;
    
    UILabel *roomLabel;
    UILabel *timeLabel;
}

- (void)dealloc
{
    contactDict = nil;
    orderRooms = nil;
    arrivalDate_ = nil;
    departureDate_ = nil;
    session = nil;
    roomNumber = nil;
    earliestArrivalTime = nil;
    latestArrivalTime = nil;
    hotelData = nil;
    room = nil;
    ratePlan = nil;
    guaranteeRule = nil;
    bookRule = nil;
    gifts = nil;
    roomLabel = nil;
    timeLabel = nil;
    creditCard = nil;
    currentTextField = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCreditCard:) name:NotificationCreditCardSet object:nil];
}

-(void) initDataWithHotel:(ELongHotel *) hotelData1 room:(ELRoom *) room1 ratePlan:(ELRatePlan *) ratePlan1 arriveDate:(NSDate *) arriveDate departDate:(NSDate *) departDate
{
    hotelData = hotelData1;
    room = room1;
    ratePlan = ratePlan1;
    arrivalDate_ = arriveDate;
    departureDate_ = departDate;
    
    roomNumber = [NSNumber numberWithInt:1];

    if (ratePlan.guaranteeRuleIds) {
        guaranteeRule = [hotelData guranteeRuleByID:ratePlan.guaranteeRuleIds];
    }
    
    earliestArrivalTime = [self dateWithDate:arrivalDate_ time:@"06:00"];
    if (guaranteeRule.startTime) {
        latestArrivalTime = [self dateWithDate:arrivalDate_ time:guaranteeRule.startTime];
    } else {
        latestArrivalTime = [self dateWithDate:arrivalDate_ time:@"23:59"];
    }
    
    
    if (ratePlan.GiftIds) {
        NSMutableArray *giftsArray = [[NSMutableArray alloc] init];
        NSArray *giftids = [ratePlan.GiftIds componentsSeparatedByString:@","];
        for (NSString *giftid in giftids) {
            ELGift *gift = [hotelData giftByID:[NSNumber numberWithInt:giftid.intValue]];
            [giftsArray addObject:gift];
        }
        gifts = giftsArray;
    }
    //booking rule
    if (ratePlan1.bookingRuleIds) {
        bookRule = [hotelData1 bookRuleByID:ratePlan1.bookingRuleIds];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            int i = 3;
            if (guaranteeRule && [self guaranteeType] != GUARANTEETYPE_NONEED) {
                i++;
            }
            return i;
            break;
        }
        case 2:
        {
            return roomNumber.integerValue;
            break;
        }
        case 3:
        {
            return 1;
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
            return [self configeSummaryCell:indexPath];
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    return  [ self configeRoomCell:indexPath];
                    break;
                }
                case 1:
                {
                    return  [ self configeTimeCell:indexPath];
                    break;
                }
                case 2:
                {
//                    if (bookRule && [bookRule needPhoneNo]) {
//                        return  [ self configePhoneCell:indexPath];
//                    } else {
//                        return [self configeEmailCell:indexPath];
//                    }
                    return [self configeEmailCell:indexPath];
                    break;
                }
                case 3:
                {
                    
                    return [self configeGuaranteeRuleCell:indexPath];
                    break;
                }
                case 4:
                {
                    return [self configeGiftsCell:indexPath];
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            return [self configeGuestCell:indexPath];
            break;
        }
        case 3:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BookCell];
            if ([self guaranteeType] != GUARANTEETYPE_NONEED) {
                UIButton * bookBtn = (UIButton *)[cell viewWithTag:1];
                [bookBtn setTitle:@"Go to guarantee" forState:UIControlStateNormal];
            }
            
            return cell;
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
            return 90;
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    return  44;
                    break;
                }
                case 1:
                {
                    //time
                    if (guaranteeRule) {
                        return 44;
                    } else {
                        return 0;
                    }
                    
                    break;
                }
                case 2:
                {
                    return  44;
                    break;
                }
                case 3:
                {
                    if (guaranteeRule && [self guaranteeType] != GUARANTEETYPE_NONEED) {
                        return 100;
                    } else {
                        return 60;
                    }
                    break;
                }
                case 4:
                {
                    return 60;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            return 44;
            break;
        }
        case 3:
        {
            return 44;
            break;
        }
        default:
            break;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            // summary
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //room
                    [self showRooms];
                    break;
                }
                case 1:
                {
                    //time
                    if (guaranteeRule && guaranteeRule.isTimeGuarantee) {
                        [self showTimes];
                    }
                    break;
                }
                case 2:
                {
                    //phone
                    break;
                }
                case 3:
                {
                    if (guaranteeRule && guaranteeRule.Description) {
                        //guarantee
                        
                    }
                    break;
                }
                case 4:
                {
                    //gift
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            //guests
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    if ([self.tableView indexPathForCell:cell].section == 2) {
        //passengers
        if (textField.text.length > 0) {
            NSMutableArray * names = [[NSMutableArray alloc] init];
            [names addObject: textField.text];
            
            ELongSession *session1 = [[ELongSession alloc] init];
            [session1 setDelegate:self];
            currentTextField = textField;
            [session1 orderCheckguest:names isGangAo:[self isGangAo]];
        }
    }
}

#pragma mark - Action

- (IBAction)bookAction:(id)sender
{
    if ([self validateBookingInfo]) {
        if (!creditCard && [self guaranteeType] != GUARANTEETYPE_NONEED) {
            //Credit Card
            CreditCardVC *creditCardVC = [self.storyboard instantiateViewControllerWithIdentifier:IdentifierCreditCardVC];
        
            [creditCardVC initData:[self getGuaranteePrice] isGangAo:[self isGangAo]];
            
            [self.navigationController showViewController:creditCardVC sender:self];
        } else {
            NSString *params = [self getParamsWithHotel];
            session = [[ELongSession alloc] init];
            [session setDelegate:self];
            [session hotelOrderCreate:params];
        }
    }
}

#pragma mark - ELong Delegate

- (void)returnCheckGuest:(NSArray *) names
{
    for (NSDictionary *dict in names) {
        if (![[dict objectForKey:@"IsValid"] boolValue]) {
            [ServiceUtils alart:@"Invalid name."];
            [currentTextField becomeFirstResponder];
            return;
        }
    }
}

#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet buttonIndex %ld", (long)buttonIndex);
    if (actionSheet.tag == 1) {
        //select number of rooms
        if (buttonIndex < 5) {
            roomNumber =[NSNumber numberWithInteger:buttonIndex + 1];
            [self.tableView reloadData];
        }
    } else if (actionSheet.tag == 2) {
        //select time
        switch (buttonIndex) {
            case 0:
            {
                earliestArrivalTime = [self dateWithDate:arrivalDate_ time:@"6:00"];
                latestArrivalTime = [self dateWithDate:arrivalDate_ time:guaranteeRule.startTime];
                break;
            }
            case 1:
            {
                earliestArrivalTime = [self dateWithDate:arrivalDate_ time:guaranteeRule.startTime];
                
                NSDate *latestDate = arrivalDate_;
                if (guaranteeRule.isTomorrow.intValue == 1) {
                    latestDate = [arrivalDate_ offsetDay:1];
                }
                latestArrivalTime = [self dateWithDate:latestDate time:guaranteeRule.endTime];
                break;
            }
            case 2:
            {
                //cancel
                break;
            }
            
            default:
                break;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Inner Method

- (NSString *) getParamsWithHotel
{
    NSMutableDictionary *bookDict = [[NSMutableDictionary alloc] init];
    [bookDict setValue:[ELongSession GetUUID] forKey:@"AffiliateConfirmationId"];
    [bookDict setValue:hotelData.hotelId forKey:@"HotelId"];
    [bookDict setValue:room.roomTypeId forKey:@"RoomTypeId"];
    [bookDict setValue:ratePlan.ratePlanId forKey:@"RatePlanId"];
    [bookDict setValue:[ELongSession convertDateToString: arrivalDate_] forKey:@"ArrivalDate"];
    [bookDict setValue:[ELongSession convertDateToString: departureDate_] forKey:@"DepartureDate"];
    [bookDict setValue:ratePlan.customerType forKey:@"CustomerType"];
    [bookDict setValue:ratePlan.paymentType forKey:@"PaymentType"];
    //lease than 5 rooms
    [bookDict setValue:roomNumber.stringValue forKey:@"NumberOfRooms"];
    [bookDict setValue:roomNumber.stringValue forKey:@"NumberOfCustomers"];
    [bookDict setValue:earliestArrivalTime forKey:@"EarliestArrivalTime"];
    [bookDict setValue:latestArrivalTime forKey:@"LatestArrivalTime"];
    [bookDict setValue:ratePlan.currencyCode forKey:@"CurrencyCode"];
    [bookDict setValue:ratePlan.totalRate forKey:@"TotalPrice"];
    [bookDict setValue:[ServiceUtils getIPAddress] forKey:@"CustomerIPAddress"];
    [bookDict setValue:@"0" forKey:@"IsGuaranteeOrCharged"];
    [bookDict setValue:@"SMS_cn" forKey:@"ConfirmationType"];
    [bookDict setValue:orderRooms forKey:@"OrderRooms"];
    [bookDict setValue:contactDict forKey:@"Contact"];
    if ([self guaranteeType] != GUARANTEETYPE_NONEED) {
        [bookDict setValue: creditCard forKey:@"CreditCard"];
    }
    //additional param add to self order
    [bookDict setValue:hotelData.detail.hotelName forKey:@"Hotelname"];
    NSString *roomString = [NSString stringWithFormat:@"%@ - %@", room.name, ratePlan.ratePlanName ];
    [bookDict setValue: roomString forKey:@"roomtype"];
    [bookDict setValue: [ELongSession convertDateToString:arrivalDate_] forKey:@"arrivaldate"];
    [bookDict setValue: [ELongSession convertDateToString:departureDate_] forKey:@"departdate"];
    
    
    NSString *jsonString = [ELongSession jsonstring:bookDict];
    return jsonString;
}


-(UITableViewCell *) configeSummaryCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BookingsummaryCell];
    UILabel *hotelname = (UILabel *)[cell viewWithTag:1];
    [hotelname setText:hotelData.detail.hotelName];
    
    UILabel *roomName = (UILabel *)[cell viewWithTag:2];
    [roomName setText:room.name];
    
    UILabel *bookDate = (UILabel *)[cell viewWithTag:3];
    NSString *days = @"1 day";
    int dayNumber =[NSDate dayBetweenStartDate:arrivalDate_ endDate:departureDate_];
    if (dayNumber > 1) {
        days = [NSString stringWithFormat:@"%d days",dayNumber];
    }
    NSString *dateString = [NSString stringWithFormat:@"%@ - %@ %@", [SkyUtils displayDateToString:arrivalDate_], [SkyUtils displayDateToString:departureDate_], days];
    [bookDate setText:dateString];
    
    UILabel *ratePlanName = (UILabel *)[cell viewWithTag:4];
    [ratePlanName setText:ratePlan.ratePlanName];
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:5];
    [priceLabel setText:[ratePlan priceStringWithRoomAmount:roomNumber isOneNight:NO]];
    
    UILabel *payTypeLabel = (UILabel *)[cell viewWithTag:6];
    [payTypeLabel setText:[ratePlan getPaymentType:hotelData arrivalDate:arrivalDate_ departDate:departureDate_]];
    
    if (![ratePlan.customerType isEqualToString:@"All"]) {
        // show the passport
        UILabel *customerTypeLabel = (UILabel *)[cell viewWithTag:7];
        [customerTypeLabel setHidden:NO];
    }
    
    return cell;
}

-(UITableViewCell *) configeRoomCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RoomCell];
    
    roomLabel = (UILabel *)[cell viewWithTag:1];
    NSString * guaranteeString = @"";
    if ([self guaranteeType] == GUARANTEETYPE_ROOM) {
        guaranteeString = @"(Guarantee)";
    }
    if (roomNumber.intValue == 1) {
        [roomLabel setText:[NSString stringWithFormat:@"1 room%@", guaranteeString]];
    } else {
        [roomLabel setText:[NSString stringWithFormat:@"%d rooms%@",roomNumber.intValue,guaranteeString]];
    }
    
    return cell;
}

-(UITableViewCell *) configeTimeCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TimeCell];
    timeLabel = (UILabel *)[cell viewWithTag:1];
    if (guaranteeRule) {
        if (guaranteeRule.isTimeGuarantee) {
            NSString *timeText;
            if ([self guaranteeType] == GUARANTEETYPE_TIME) {
                //need guarantee
                NSString * nextDayString = @"";
                if (guaranteeRule.isTomorrow.intValue == 1) {
                    nextDayString = @" the next day";
                }
                timeText = [NSString stringWithFormat:@"Before %@%@(Guarantee)", guaranteeRule.endTime, nextDayString];
            } else {
                //no guarantee
                timeText = [NSString stringWithFormat:@"before %@", guaranteeRule.startTime];
            }
            [timeLabel setText:timeText];
        } else {
            [timeLabel setText:@"Need Guarantee"];
        }
    } else {
        [cell setHidden:YES];
    }
    return cell;
}

-(UITableViewCell *) configeGuestCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GuestCell];
    
    return cell;
}

-(UITableViewCell *) configePhoneCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PhoneCell];
    
    return cell;
}

-(UITableViewCell *) configeEmailCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:EmailCell];
    if ([LocalSession email]) {
        UILabel *emailLabel = (UILabel *)[cell viewWithTag:1];
        [emailLabel setText:[LocalSession email]];
    }
    
    return cell;
}

-(UITableViewCell *) configeGuaranteeRuleCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GuranteeDescCell];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:1];
    if ([self guaranteeType] != GUARANTEETYPE_NONEED) {
        [priceLabel setText:[self getGuaranteePrice]];
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:2];
        [descriptionLabel setText:guaranteeRule.Description];
    }
    return cell;
}

-(UITableViewCell *) configeGiftsCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GiftCell];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:1];
    NSString *desc = @"";
    for (ELGift *gift in gifts) {
        desc = [desc stringByAppendingString:gift.Description];
        desc = [desc stringByAppendingString:@"\n"];
    }
    [descriptionLabel setText:desc];
    return cell;
}

-(void) showRooms
{
    NSString *guaranteeText = @"";
    if ([self guaranteeType] == GUARANTEETYPE_ROOM) {
        guaranteeText = [NSString stringWithFormat:@"(Guarantee, %@)", [self getGuaranteePrice]];
    }
    NSString *other1 = [NSString stringWithFormat:@"1 Room%@", guaranteeText];
    NSString *other2 = [NSString stringWithFormat:@"2 Rooms%@", guaranteeText];
    NSString *other3 = [NSString stringWithFormat:@"3 Rooms%@", guaranteeText];
    NSString *other4 = [NSString stringWithFormat:@"4 Rooms%@", guaranteeText];
    NSString *other5 = [NSString stringWithFormat:@"5 Rooms%@", guaranteeText];
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3,other4, other5, nil];
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}

-(void) showTimes
{
    NSString *other1 = [NSString stringWithFormat:@"Before %@", guaranteeRule.startTime];
    NSString * nextDayString = @"";
    if (guaranteeRule.isTomorrow.intValue == 1) {
        nextDayString = @" the next day";
    }
    
    NSString *other2 = [NSString stringWithFormat:@"Before %@%@(Credit Card Guarantee, %@)", guaranteeRule.endTime, nextDayString, [self getGuaranteePrice]];
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    actionSheet.tag = 2;
    
    [actionSheet showInView:self.view];
}


-(BOOL) validateBookingInfo
{
    //EMail
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    UILabel *emailLabel = (UILabel *)[cell viewWithTag:1];
    if (emailLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Email is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [emailLabel becomeFirstResponder];
        return NO;
    } else if (![ServiceUtils isValidateEmail:emailLabel.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Email is not in proper format!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [emailLabel becomeFirstResponder];
        return NO;
    }
    //Guest's Name
    for (int i = 0; i < roomNumber.intValue; i++) {
        UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        UITextField *textField = (UITextField *)[cell1 viewWithTag:1];
        NSString *nameText = [textField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
        if (nameText.length == 0) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Guest's Name is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [textField becomeFirstResponder];
            return NO;
        } else {
            //contact
            if (i == 0) {
                NSMutableDictionary *contactArray = [[NSMutableDictionary alloc] init];
                [contactArray setValue:nameText forKey:@"Name"];
                [contactArray setValue:emailLabel.text forKey:@"Email"];
                contactDict = contactArray;
            }
            //OrderRooms
            if (!orderRooms) {
                orderRooms = [[NSMutableArray alloc] init];
            }
            NSMutableDictionary *customer = [[NSMutableDictionary alloc] init];
            [customer setValue:nameText forKey:@"Name"];
            [customer setValue:@"Unknown" forKey:@"Gender"];
            
            NSMutableArray *customers = [[NSMutableArray alloc] init];
            [customers addObject:customer];
            
            NSMutableDictionary *orderRoom = [[NSMutableDictionary alloc] init];
            [orderRoom setValue:customers forKey:@"Customers"];
            
            [orderRooms addObject:orderRoom];
        }
    }
    return YES;
}

- (NSString *) dateWithDate:(NSDate *) date time:(NSString *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString * dateString1 = [NSString stringWithFormat:@"%@ %@", dateString, time];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [dateFormatter dateFromString:dateString1];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *dateString2 = [dateFormatter stringFromDate:date1];
    return dateString2;
}

- (NSString *) timeWithDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [dateFormatter setLocale:usLocale];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString2 = [dateFormatter stringFromDate:date];
    return dateString2;
}

- (NSString *) getGuaranteePrice
{
    if ([guaranteeRule.guaranteeType isEqualToString:@"FullNightCost"]) {
        return [ratePlan priceStringWithRoomAmount:roomNumber isOneNight:NO];
    } else {
        return [ratePlan priceStringWithRoomAmount:roomNumber isOneNight:YES];
    }
}

- (GUARANTEETYPE) guaranteeType
{
    if (guaranteeRule && [guaranteeRule isGuarantee:arrivalDate_ departDate:departureDate_]) {
        if (guaranteeRule.isAmountGuarantee.intValue == 1){
            if (roomNumber.intValue > guaranteeRule.amount.intValue) {
                //need room guarantee
                return GUARANTEETYPE_ROOM;
            }
        }
        if (guaranteeRule.isTimeGuarantee && [[self dateWithDate:arrivalDate_ time:guaranteeRule.startTime] isEqualToString:earliestArrivalTime]) {
            //need time guarantee
            return GUARANTEETYPE_TIME;
        }
        if (!(guaranteeRule.isTimeGuarantee) && guaranteeRule.isAmountGuarantee.intValue == 0) {
            //无条件担保
            return GUARANTEETYPE_NOCONDITION;
        }
    }
    return GUARANTEETYPE_NONEED;
}

- (void) setCreditCard:(NSNotification *) params
{
    creditCard = params.userInfo;
    [self bookAction:nil];
}

- (BOOL) isGangAo
{
    if (hotelData.detail.city.intValue == 3201 ||
        hotelData.detail.city.intValue == 3203 ||
        hotelData.detail.city.intValue == 3206 ||
        hotelData.detail.city.intValue == 3207 ||
        hotelData.detail.city.intValue == 3301) {
        return YES;
    }
    return NO;
}

@end
