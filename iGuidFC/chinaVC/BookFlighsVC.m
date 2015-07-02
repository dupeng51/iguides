//
//  BookFlighsVC.m
//  iGuidFC
//
//  Created by dampier on 15/4/23.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "BookFlighsVC.h"
#import "SegmentSkyModel.h"
#import "PriceOption.h"
#import "Itinerary.h"
#import "UIImageView+AFNetworking.h"


@interface BookFlighsVC ()

@end

@implementation BookFlighsVC
{
    Itinerary *outItinerary_;
    Itinerary *inItinerary_;
    SkySession *skySession;
    NSArray *bookOptions;
    int numberOfPassengers;
    id selectedItem;
    NSDictionary *dictParams;
}

- (void)dealloc
{
    outItinerary_ = nil;
    inItinerary_ = nil;
    skySession = nil;
    bookOptions = nil;
    selectedItem = nil;
    dictParams = nil;
    _priceOtions = nil;
}

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
            //flights
            if (inItinerary_) {
                return (inItinerary_.outboundLeg_.segmentIds.count + outItinerary_.outboundLeg_.segmentIds.count);
            } else{
                return outItinerary_.outboundLeg_.segmentIds.count;
            }
            break;
        }
//        case 1:
//        {
//            //passengers
//            return 1;
//            break;
//        }
        case 1:
        {
            // books
//            int count = 0;
//            for (BookOptionSkyModel *bookOption in bookOptions) {
//                count += bookOption.bookingItems.count;
//            }
            if (self.priceOtions) {
                return self.priceOtions.count;
            } else {
                return bookOptions.count;
            }
            break;
        }
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            //flights
            return [self configItineraryCell:indexPath];
            break;
        }
            /*
        case 1:
        {
            //passengers
            return [self configPassengersCell:indexPath];
            break;
        }
             */
        case 1:
        {
            // books
            return [self configBooksCell:indexPath];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            //flights
            return @" ";
            break;
        }
//        case 1:
//        {
//            //passengers
//            return @" ";
//            break;
//        }
        case 1:
        {
            // books
            return @"Book Via";
            break;
        }
        default:
            break;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            //flights
            return nil;
            break;
        }
//        case 1:
//        {
//            //passengers
//            return nil;
//            break;
//        }
        case 1:
        {
            // books
            return @"Any Cancellation or change to the ticket booking is to be made by the user via the billing organization, according to its terms and conditions, We only provides online flight information search service.";
            break;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return 139.0f;
            break;
        }
//        case 1:
//        {
//            return 43.0f;
//            break;
//        }
        case 1:
        {
            return 96.0;
            break;
        }

        default:
            break;
    }
    
    return 39.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            //flights
            
            break;
        }
       /* case 1:
        {
            //passengers
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
            break;
        }*/
        case 1:
        {
            // books
            NSString *actionSheetTitle;
            if (self.priceOtions) {
                selectedItem = self.priceOtions[indexPath.row];
                actionSheetTitle = [NSString stringWithFormat:@"Book with %@ via", ((Agents *)((PriceOption *)selectedItem).agents_[0]).name];
            } else {
                BookOptionSkyModel *bookOption = bookOptions[indexPath.row];
                selectedItem = bookOption.bookingItems[0];
                actionSheetTitle = [NSString stringWithFormat:@"Book with %@ via", ((BookItemSkyModel *)selectedItem).agents_.name];
            }
            
            
             //Action Sheet Title
            NSString *other1 = @"Website";
            NSString *other2 = @"Phone";
            NSString *cancelTitle = @"Cancel";
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:actionSheetTitle
                                          delegate:self
                                          cancelButtonTitle:cancelTitle
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:other1, other2, nil];
            actionSheet.tag = 2;
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        
        NSString *imageUrl;
        if (self.priceOtions) {
            PriceOption *priceOption = self.priceOtions[indexPath.row];
            Agents *agent = priceOption.agents_[0];
            imageUrl  = agent.imageUrl;
        } else {
            BookOptionSkyModel *bookOption = bookOptions[indexPath.row];
            BookItemSkyModel *bookItem = bookOption.bookingItems[0];
            imageUrl = bookItem.agents_.imageUrl;
        }
        UIImageView *  agentImage = (UIImageView *)[cell viewWithTag:2];
        
        [agentImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark actionsheet Delegation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet buttonIndex %ld", (long)buttonIndex);
    if (actionSheet.tag == 1) {
        //select number of passengers
    } else if (actionSheet.tag == 2) {
        NSString * bookNumber;
        NSString * deeplink;
        if ([selectedItem isKindOfClass:[PriceOption class]]) {
            bookNumber = ((Agents *)((PriceOption *)selectedItem).agents_[0]).bookingNumber;
            deeplink  =((PriceOption *)selectedItem).deeplinkUrl;
        } else {
            bookNumber = ((BookItemSkyModel *)selectedItem).agents_.bookingNumber;
            deeplink  = ((BookItemSkyModel *)selectedItem).deeplink;
        }
        //select book site of phone
        switch (buttonIndex) {
            case 0:
            {
                //website
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:deeplink]];
                break;
            }
            case 1:
            {
                //book phone
                NSString *phoneNumber = [@"tel://" stringByAppendingString:bookNumber];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark - SkySession Delegate

- (void) sessionCreated
{
    [self performSelector:@selector(querySession) withObject:nil afterDelay:1.0f];
}

- (void)returnItinerarys:(NSArray *)itinerarys pageIndex:(int) index;
{
    NSLog(@"return round way itinerarys data");
    
    if (itinerarys.count >0) {
        [dictParams setValue:((Itinerary *)itinerarys[0]).outboundLegId forKey:@"outboundlegid"];
        [dictParams setValue:((Itinerary *)itinerarys[0]).inboundLegId forKey:@"inboundlegid"];
    } else {
        NSLog(@"return 0 itinerarys");
    }
    
    
    [skySession createBookSession:dictParams];
}

#pragma mark Book Delegation
- (void)bookSessionCreated
{
    NSLog(@"book Session Created");
}

- (void)returnBooks:(NSArray *) books
{
    bookOptions = books;
    [self.tableView reloadData];
}

#pragma mark Public

-(void) initData:(Itinerary *) outItinerary inItinerary:(Itinerary *) inItinerary session:(SkySession *) session params:(NSDictionary *) params
{
    skySession = session;
    skySession.delegate = self;
    skySession.bookDelegate = self;
    outItinerary_ = outItinerary;
    inItinerary_ = inItinerary;
    dictParams = params;
    
//    [skySession createBookSession:params];
}

#pragma mark Private

-(void) querySession
{
    [skySession searchItinerariesWithSortType:@"price" page:0 stops:3];
}

-(UITableViewCell *) configPassengersCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"passenger" forIndexPath:indexPath];
    return cell;
}

-(UITableViewCell *) configBooksCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Books" forIndexPath:indexPath];
    
    NSString *dateString;
    NSNumber *bookPrice;
    if (self.priceOtions) {
        PriceOption *priceOption = self.priceOtions[indexPath.row];
        dateString = ((Agents *)priceOption.agents_[0]).name;
        bookPrice = priceOption.price;
    } else {
        BookOptionSkyModel *bookOption = bookOptions[indexPath.row];
        if (bookOption.bookingItems.count > 1) {
            NSLog(@"error: bookingItems more then one!");
        }
        BookItemSkyModel *bookItem = bookOption.bookingItems[0];
        dateString = bookItem.agents_.name;
        bookPrice = bookItem.price;
    }
    
    
    
    //agent name
    UILabel * nameLabel = (UILabel *)[cell viewWithTag:1];
    
    [nameLabel setText:dateString];
    
    //agent image
//    UIImageView *  agentImage = (UIImageView *)[cell viewWithTag:2];
//    [agentImage setImage: [bookItem.agents_ getAgentImage]];
    
    //price
    UILabel * priceLabel = (UILabel *)[cell viewWithTag:3];
    CurrencySkyModel * currency = [skySession getCurrency];
    NSString * billString = [currency getBillString:bookPrice];
    [priceLabel setText:billString];
    
    return cell;
}

-(UITableViewCell *) configItineraryCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"flight" forIndexPath:indexPath];
    
    SegmentSkyModel *segment;
    if (indexPath.row + 1 > outItinerary_.outboundLeg_.segments_.count) {
        int index = indexPath.row - outItinerary_.outboundLeg_.segments_.count;
        segment = inItinerary_.outboundLeg_.segments_[index];
    } else {
        segment = outItinerary_.outboundLeg_.segments_[indexPath.row];
    }
    //4月29日 周三
    UILabel * dateLabel = (UILabel *)[cell viewWithTag:1];
    NSString *dateString = [segment getFormatedDepartureDate];
    [dateLabel setText:dateString];
    
    //Beijing Capital to New York
    UILabel * fromtoLabel = (UILabel *)[cell viewWithTag:2];
    NSString *fromtoString = [NSString stringWithFormat:@"%@ to %@", [skySession getCityByID:segment.originStation_.idString].name, [skySession getCityByID: segment.destinationStation_.idString].name];
    [fromtoLabel setText:fromtoString];
    
    //2h 5m - Economy, Korean Air #854
    UILabel * detailLabel = (UILabel *)[cell viewWithTag:3];
    NSString * durationString = [segment getFormatedDuration];
    NSString * classString = skySession.flights.query.cabinClass;
    NSString * flightNumber = [NSString stringWithFormat:@"%@ #%@", segment.carrier_.name, segment.flightNumber];
    NSString *detailString = [NSString stringWithFormat:@"%@ - %@, %@",durationString, classString, flightNumber];
    [detailLabel setText:detailString];
    
    //9:15 PM - 12:20 AM
    UILabel * timeLabel = (UILabel *)[cell viewWithTag:4];
    NSString *timeString = [segment getFormatedTime];
    [timeLabel setText:timeString];
    
    [self drawItinarery:cell segment:segment];
    
    return cell;
}

-(void) drawItinarery:(UITableViewCell *) cell segment:(SegmentSkyModel *) segment
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    CGRect lineFrame = CGRectMake(cell.frame.size.width/4, 99, cell.frame.size.width/2, 4);
    UIView *carrierLine = [[UIView alloc] initWithFrame:lineFrame];
    [carrierLine setBackgroundColor:[UIColor grayColor]];
    CGPoint startPoint = CGPointMake(carrierLine.frame.origin.x, carrierLine.center.y) ;
    CGPoint endPoint = CGPointMake(carrierLine.frame.origin.x+carrierLine.frame.size.width, carrierLine.center.y) ;
    
    CGRect stationFrame = CGRectMake(0, 0, 16, 16);
    UIView *startStationView = [[UIView alloc] initWithFrame:stationFrame];
    [startStationView setBackgroundColor:[UIColor grayColor]];
    [startStationView setCenter:startPoint];
    startStationView.layer.cornerRadius = stationFrame.size.width/2;
    startStationView.clipsToBounds = YES;
    
    CGRect stationLabelFrame = CGRectMake(0, 0, 30, 21);
    UILabel *startLabel = [[UILabel alloc] initWithFrame:stationLabelFrame];
    startLabel.center = CGPointMake(startStationView.center.x, startStationView.center.y +18);
    [startLabel setFont: font];
    startLabel.text = segment.originStation_.code;
    
    
    UIView *endStationView = [[UIView alloc] initWithFrame:stationFrame];
    [endStationView setBackgroundColor:[UIColor grayColor]];
    [endStationView setCenter:endPoint];
    endStationView.layer.cornerRadius = stationFrame.size.width/2;
    endStationView.clipsToBounds = YES;
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:stationLabelFrame];
    endLabel.center = CGPointMake(endStationView.center.x, endStationView.center.y +18);
    endLabel.font = font;
    endLabel.text = segment.destinationStation_.code;
    
    [cell.contentView addSubview:carrierLine];
    [cell.contentView addSubview:startStationView];
    [cell.contentView addSubview:startLabel];
    [cell.contentView addSubview:endStationView];
    [cell.contentView addSubview:endLabel];
}

@end
