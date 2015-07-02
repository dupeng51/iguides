//
//  FlightsVC.m
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "FlightsVC.h"
#import "Flights.h"
#import "QuerySkyModel.h"
#import "QueryModel.h"
#import "AllFlightsVC.h"
#import "UIImageView+AFNetworking.h"

@interface FlightsVC ()

@end

#define SortTypePrice @"price"
#define SortTypeDuration @"duration"
#define SortTypeOutArrivetime @"outboundarrivetime"
#define SortTypeOutDeparttime @"outbounddeparttime"
#define SortTypeInArrivetime @"inboundarrivetime"
#define SortTypeInDeparttime @"inbounddeparttime"

@implementation FlightsVC
{
    NSArray *itinerarys_;
    SkySession *skySession;
    NSDictionary *params;
    NSString *sortTypeName;
    BOOL isLoaded;
    BOOL isAllDataLoaded;
    BOOL isReturn_;
    int pageIndex;
    NSArray *limitedInItinerarys;
    NSArray *limitedOutItinerarys;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 0;
//    sortTypeName = SortTypePrice;
    isLoaded = NO;
    isAllDataLoaded  = NO;
    
    itinerarys_ = [[NSArray alloc] init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionCreated) name:@"sessionCreated" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self querySession];
}

-(void) dealloc{
    itinerarys_ = nil;
    skySession = nil;
    params = nil;
    _delegate = nil;
    
    sortTypeName = nil;
    limitedInItinerarys = nil;
    limitedOutItinerarys = nil;
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
            return 1;
            break;
        }
        case 1:
        {
            return itinerarys_.count;
        }
            
        default:
            break;
    }
    return itinerarys_.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell = [self configSummaryCell:indexPath];
            } else {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"navigationCell" forIndexPath:indexPath];
            }
            break;
        }
        case 1:
        {
            cell = [self configItineraryCell:indexPath];
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
            if (indexPath.row == 0) {
                return 39.0f;
            } else {
                return 50.0f;
            }
            break;
        }
        case 1:
        {
            return 104.0f;
            break;
        }
        default:
            break;
    }

    return 39.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Itinerary *itinerary = itinerarys_[indexPath.row];
    [self.delegate didSelectItinerary:itinerary];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    NSLog(@"Number of Row = %ld, row = %ld", (long)lastRowIndex, (long)indexPath.row);
    int pageIndex = (lastRowIndex+1)/100;

    if (!isAllDataLoaded && (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        [skySession searchItinerariesWithSortType:sortTypeName page:pageIndex];
        isLoaded = NO;
    }
     */
    if (itinerarys_.count ==0) {
        return;
    }
    
    UIImageView * carrierImageView = (UIImageView *)[cell viewWithTag:4];
    Itinerary *itinerary = itinerarys_[indexPath.row];
    Carriers * carrier = (Carriers *)itinerary.outboundLeg_.carriers_[0];
    if (carrier.image) {
        NSDictionary *cellimage = [NSDictionary dictionaryWithObjectsAndKeys:
                                   indexPath, @"indexPath",
                                   carrier.image, @"image",
                                   nil];
        [self _setOCellImage:cellimage];
    } else{
//        [NSThread detachNewThreadSelector:@selector(startImageread:) toTarget:self withObject:indexPath]; // 获取图片
        [carrierImageView setImageWithURL:[NSURL URLWithString:carrier.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Public
-(void) initDataWithSortString:(SORTTYPE) sortType return:(BOOL) isReturn session:(SkySession *) session limited:(NSArray *) itinerarys
{
    skySession = session;
    skySession.delegate = self;
    
    limitedInItinerarys = itinerarys;
    isReturn_ = isReturn;
    
    switch (sortType) {
        case SORTTYPE_PRICE:
        {
            sortTypeName = SortTypePrice;
            self.title = @"Lowest Price";
            break;
        }
        case SORTTYPE_DURATION:
        {
            sortTypeName = SortTypeDuration;
            self.title = @"Quickest";
            break;
        }
        case SORTTYPE_LANDINGTIME:
        {
            if (isReturn) {
                sortTypeName = SortTypeInArrivetime;
            } else {
                sortTypeName = SortTypeOutArrivetime;
            }
            
            self.title = @"Latest Arrival";
            break;
        }
        case SORTTYPE_TAKEOFFTIME:
        {
            if (isReturn) {
                sortTypeName = SortTypeInDeparttime;
            } else {
                sortTypeName = SortTypeOutDeparttime;
            }
            self.title = @"Earliest Departure";
            break;
        }
        default:
            break;
    }
}

-(void) activeView{
    
    skySession.delegate = self;
    [self querySession];
}

-(void) setLimitedOutItinerarys:(NSArray *) limitedItinerarys
{
    limitedOutItinerarys = limitedItinerarys;

    itinerarys_ = [self getLimitedItinerarys];
    [self.tableView reloadData];
}

-(void) setLimitedInItinerarys:(NSArray *) limitedItinerarys
{
    limitedInItinerarys = limitedItinerarys;
    
    itinerarys_ = [self getLimitedItinerarys];
    [self.tableView reloadData];
}

+(void) drawItinarery:(UIView *) contentView itinerary:(Itinerary *) itinerary
{
    for (UIView *view in contentView.subviews) {
        if (view.tag == 55) {
            [view removeFromSuperview];
        }
    }
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
    
    CGRect lineFrame = CGRectMake(209, 60, contentView.frame.size.width - 209 - 17, 4);
    UIView *carrierLine = [[UIView alloc] initWithFrame:lineFrame];
    [carrierLine setBackgroundColor:[UIColor grayColor]];
    CGPoint startPoint = CGPointMake(carrierLine.frame.origin.x, carrierLine.center.y) ;
    CGPoint endPoint = CGPointMake(carrierLine.frame.origin.x+carrierLine.frame.size.width, carrierLine.center.y) ;
    carrierLine.tag = 55;
    
    CGRect stationFrame = CGRectMake(0, 0, 16, 16);
    UIView *startStationView = [[UIView alloc] initWithFrame:stationFrame];
    [startStationView setBackgroundColor:[UIColor grayColor]];
    [startStationView setCenter:startPoint];
    startStationView.layer.cornerRadius = stationFrame.size.width/2;
    startStationView.clipsToBounds = YES;
    startStationView.tag = 55;
    
    CGRect stationLabelFrame = CGRectMake(0, 0, 30, 21);
    UILabel *startLabel = [[UILabel alloc] initWithFrame:stationLabelFrame];
    startLabel.center = CGPointMake(startStationView.center.x, startStationView.center.y +18);
    [startLabel setFont: font];
    startLabel.text = itinerary.outboundLeg_.originStation_.code;
    [startLabel setTextAlignment:NSTextAlignmentCenter];
    startLabel.tag = 55;
    
    UIView *endStationView = [[UIView alloc] initWithFrame:stationFrame];
    [endStationView setBackgroundColor:[UIColor grayColor]];
    [endStationView setCenter:endPoint];
    endStationView.layer.cornerRadius = stationFrame.size.width/2;
    endStationView.clipsToBounds = YES;
    endStationView.tag = 55;
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:stationLabelFrame];
    endLabel.center = CGPointMake(endStationView.center.x, endStationView.center.y +18);
    endLabel.font = font;
    endLabel.text = itinerary.outboundLeg_.destinationStation_.code;
    [endLabel setTextAlignment:NSTextAlignmentCenter];
    endLabel.tag = 55;
    
    int i = 1;
    int length = lineFrame.size.width / (1 + itinerary.outboundLeg_.stops_.count);
    for (Station *station in itinerary.outboundLeg_.stops_) {
        UIView *stationView = [[UIView alloc] initWithFrame:stationFrame];
        [stationView setBackgroundColor:[UIColor grayColor]];
        CGPoint stationCenter = CGPointMake(lineFrame.origin.x + i*length, carrierLine.center.y);
        [stationView setCenter:stationCenter];
        stationView.layer.cornerRadius = stationFrame.size.width/2;
        stationView.clipsToBounds = YES;
        stationView.tag = 55;
        
        UILabel *stationLabel = [[UILabel alloc] initWithFrame:stationLabelFrame];
        stationLabel.center = CGPointMake(stationView.center.x, stationView.center.y +18);
        stationLabel.font = font;
        stationLabel.text = station.code;
        [stationLabel setTextAlignment:NSTextAlignmentCenter];
        stationLabel.tag = 55;
        
        
        [contentView addSubview:stationView];
        [contentView addSubview:stationLabel];
        
        i++;
    }
    [contentView addSubview:carrierLine];
    [contentView addSubview:startStationView];
    [contentView addSubview:startLabel];
    [contentView addSubview:endStationView];
    [contentView addSubview:endLabel];
}

#pragma mark - SkySession Delegate

- (void) sessionCreated
{
    [self performSelector:@selector(querySession) withObject:nil afterDelay:1.0f];
}

- (void)returnItinerarys:(NSArray *)itinerarys pageIndex:(int) index;
{
    if (itinerarys.count < 100) {
        isAllDataLoaded =YES;
    }
    
    itinerarys_ = itinerarys;
    itinerarys_ = [self getLimitedItinerarys];
//    itinerarys_ = [itinerarys_ arrayByAddingObjectsFromArray: itinerarys];
    pageIndex ++;
    [self.tableView reloadData];
    
//    [self.delegate endLoadingAnimation];
}

#pragma mark - Private

- (NSArray *) getLimitedItinerarys
{
    if (isReturn_) {
        if (!limitedInItinerarys) {
            return itinerarys_;
        }
        
        [self.delegate endLoadingAnimation];
        
        NSMutableArray *newItinerarys = [[NSMutableArray alloc] init];
        for (Itinerary *itinerary in itinerarys_) {
            for (Itinerary *limiteditinerary in limitedInItinerarys) {
                if ([limiteditinerary.inboundLegId isEqualToString:itinerary.outboundLegId]) {
                    [newItinerarys addObject:itinerary];
                    break;
                }
            }
        }
        return newItinerarys;
    } else {
        if (!limitedOutItinerarys) {
            return itinerarys_;
        }
        if (limitedOutItinerarys && itinerarys_) {
            [self.delegate endLoadingAnimation];
            
            NSMutableArray *newItinerarys = [[NSMutableArray alloc] init];
            for (Itinerary *itinerary in itinerarys_) {
                for (Itinerary *limiteditinerary in limitedOutItinerarys) {
                    if ([limiteditinerary.outboundLegId isEqualToString:itinerary.outboundLegId]) {
                        [newItinerarys addObject:itinerary];
                        break;
                    }
                }
            }
            return newItinerarys;
        }
    }
    return itinerarys_;
}

-(void) querySession
{
    if (!isLoaded) {
        if (skySession.status == SESSIONSTATUS_CREATING) {
            if (![[skySession getQuerySortTypeName] isEqualToString:sortTypeName] && [skySession getQuerySortTypeName]) {
                [skySession searchItinerariesWithSortType:sortTypeName page:pageIndex stops:self.stopcount];
                isLoaded = YES;
                [self.delegate beginLoadingAnimation];
            }
        } else {
            [skySession searchItinerariesWithSortType:sortTypeName page:pageIndex stops:self.stopcount];
            isLoaded = YES;
            [self.delegate beginLoadingAnimation];
        }
    }
}

-(UITableViewCell *) configSummaryCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"summaryCell" forIndexPath:indexPath];
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel * dateLabel = (UILabel *)[cell viewWithTag:2];
    NSString *destinationName = [skySession getStationByID:skySession.flights.query.destinationPlace].name;
    if (destinationName) {
        NSString *title;
        if (isReturn_) {
            title = [NSString stringWithFormat:@"Return to %@", destinationName];
        } else {
            title = [NSString stringWithFormat:@"Outbound to %@", destinationName];
        }
        [titleLabel setText:title];
        
        
        NSString *dateString = [skySession getFormatedDate: skySession.flights.query.outboundDate];
        [dateLabel setText:dateString];
    } else {
        [titleLabel setText:@""];
        [dateLabel setText:@""];
    }
    
    return cell;
    
}

-(UITableViewCell *) configItineraryCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"itineraryCell" forIndexPath:indexPath];
    UILabel * priceLabel = (UILabel *)[cell viewWithTag:1];
    Itinerary *itinerary = itinerarys_[indexPath.row];
    CurrencySkyModel * currency = [skySession getCurrency];
    NSString * billString = [currency getBillString:[itinerary getLowestPrice]];
    [priceLabel setText:billString];
    
    UILabel * dateLabel = (UILabel *)[cell viewWithTag:2];
    NSString *dateString = [itinerary.outboundLeg_ getFormatedTime];
    [dateLabel setText:dateString];
    
    UILabel * durationLabel = (UILabel *)[cell viewWithTag:3];
    NSString *durationString = [itinerary.outboundLeg_ getFormatedDuration];
    [durationLabel setText:durationString];
    
    if (itinerary.outboundLeg_.carriers.count > 0) {
        Itinerary *itinerary = itinerarys_[indexPath.row];
        Carriers * carrier = (Carriers *)itinerary.outboundLeg_.carriers_[0];
        
        UILabel * carrierNameLabel = (UILabel *)[cell viewWithTag:5];
        [carrierNameLabel setText:carrier.name];
        
//        int duration = itinerary.outboundLeg_.duration.intValue + itinerary.inboundLeg_.duration.intValue;
//        [carrierNameLabel setText:[NSString stringWithFormat:@"%d", duration]];
    }
    
    [self drawItinarery:cell indexPath:indexPath];
    
    return cell;
}

//-(void)startImageread:(NSIndexPath *)indexPath
//{
//    Itinerary *itinerary = itinerarys_[indexPath.row];
//    Carriers * carrier = (Carriers *)itinerary.outboundLeg_.carriers_[0];
//    UIImage *carrierImage = [carrier getCarriearImage];
//    
//    
//    NSDictionary *cellimage = [NSDictionary dictionaryWithObjectsAndKeys:
//                               indexPath, @"indexPath",
//                               carrierImage,@"image",
//                               nil];
//    [self performSelectorOnMainThread:@selector(_setOCellImage:) withObject:cellimage waitUntilDone:NO];
////    [self _setOCellImage:cellimage];
//}

- (void)_setOCellImage:( id )celldata
{
    UIImage *newimage = [celldata objectForKey:@"image"];
    NSIndexPath *indexPath = [celldata objectForKey:@"indexPath"];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"itineraryCell" forIndexPath:indexPath];
    
    UIImageView * carrierImageView = (UIImageView *)[cell viewWithTag:4];
    [carrierImageView setImage:newimage];
    
    [self drawItinarery:cell indexPath:indexPath];
}

-(void) drawItinarery:(UITableViewCell *) cell indexPath:(NSIndexPath *) indexPath
{
    Itinerary *itinerary = itinerarys_[indexPath.row];
    [FlightsVC drawItinarery:cell.contentView itinerary:itinerary];
}




@end
