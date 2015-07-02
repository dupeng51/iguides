//
//  AllFlightsVC.m
//  iGuidFC
//
//  Created by dampier on 15/4/21.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "AllFlightsVC.h"
#import "SCNavTabBarController.h"
#import "BookFlighsVC.h"
#import "RTSpinKitView.h"
#import "PriceOption.h"
#import "UIImageView+AFNetworking.h"

@interface AllFlightsVC ()

@end

@implementation AllFlightsVC
{
    QueryModel *params;
    SkySession *outSession;
    SkySession *inSession;
    SkySession *allSession;
    BOOL returnLeg; //是否是返程查询
    
    Itinerary *selectedOutItinerary;
    Itinerary *selectedInItinerary;
    NSArray *limitedItinerarys_;
    
    RTSpinKitView *spinKitView;
    
    FlightsVC *priceVC;
    FlightsVC *durationVC;
    FlightsVC *takeoffVC;
    FlightsVC *landingVC;
}

- (void)dealloc
{
    params = nil;
    outSession = nil;
    inSession = nil;
    selectedOutItinerary = nil;
    selectedInItinerary = nil;
    spinKitView = nil;
    allSession = nil;
    _allItinerarys = nil;
    limitedItinerarys_ = nil;
    
    priceVC = nil;
    durationVC = nil;
    takeoffVC = nil;
    landingVC = nil;
    _outBoundView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *paramsDict = [AllFlightsVC getParams:params isReturn:returnLeg isALL:NO];
    SkySession * skySession = [[SkySession alloc]initWithParams:paramsDict];
    if (returnLeg) {
        inSession = skySession;
    } else {
        outSession = skySession;
    }
    
    priceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"flightsVC"];
    [priceVC initDataWithSortString:SORTTYPE_PRICE return:returnLeg session:skySession limited:limitedItinerarys_];
    priceVC.delegate = self;
    priceVC.stopcount = self.stopcount;
    [priceVC activeView];
    
    durationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"flightsVC"];
    [durationVC initDataWithSortString:SORTTYPE_DURATION return:returnLeg session:skySession limited:limitedItinerarys_];
    durationVC.stopcount = self.stopcount;
    durationVC.delegate = self;
    
    takeoffVC = [self.storyboard instantiateViewControllerWithIdentifier:@"flightsVC"];
    [takeoffVC initDataWithSortString:SORTTYPE_TAKEOFFTIME return:returnLeg session:skySession limited:limitedItinerarys_];
    takeoffVC.stopcount = self.stopcount;
    takeoffVC.delegate = self;
    
    landingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"flightsVC"];
    [landingVC initDataWithSortString:SORTTYPE_LANDINGTIME return:returnLeg session:skySession limited:limitedItinerarys_];
    landingVC.stopcount = self.stopcount;
    landingVC.delegate = self;
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    if (returnLeg) {
        
        
        navTabBarController.customTopview = self.outBoundView;
    }
    
    navTabBarController.subViewControllers = @[priceVC, durationVC, takeoffVC, landingVC];
    navTabBarController.showArrowButton = NO;
    [navTabBarController addParentController:self];
    
    if (spinKitView) {
        [self.navigationController.view addSubview:spinKitView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (returnLeg) {
        [self configOutBoundTopView];
        UIImageView * carrierImageView = (UIImageView *)[self.outBoundView viewWithTag:4];
        Carriers * carrier = (Carriers *)selectedOutItinerary.outboundLeg_.carriers_[0];
        [carrierImageView setImageWithURL:[NSURL URLWithString:carrier.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        [self.outBoundView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) initData:(QueryModel *) searchParams isReturn:(BOOL) isReturn itinerary:(Itinerary *) itinerary limitedItinerarys:(NSArray *) limitedItinerarys allsession:(SkySession *) allsession
{
    if (isReturn) {
        selectedOutItinerary = itinerary;
    }
    if (searchParams.inboundDate && !isReturn) {
        //如果是往返查询，且是先查去程，则准备往返数据
        NSDictionary *paramsDict = [AllFlightsVC getParams:searchParams isReturn:returnLeg isALL:YES];
        allSession = [[SkySession alloc] initWithParams:paramsDict];
        allSession.delegate = self;
    }
    if (allsession) {
        allSession = allsession;
    }
    
    limitedItinerarys_ = limitedItinerarys;
    returnLeg = isReturn;
    params = searchParams;
}

+(NSDictionary *) getParams:(QueryModel *) query isReturn:(BOOL) isReturn isALL:(BOOL) isALL
{
    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setObject:query.country forKey:@"country"];
    [params setObject:query.currency forKey:@"currency"];
    [params setObject:query.locale forKey:@"locale"];
    
    
    [params setObject:query.adults forKey:@"adults"];
    if (isALL) {
        [params setObject:query.originPlace forKey:@"originplace"];
        [params setObject:query.destinationPlace forKey:@"destinationplace"];
        [params setObject:query.outboundDate forKey:@"outbounddate"];
        if (query.inboundDate) {
            [params setObject:query.inboundDate forKey:@"inbounddate"];
        }
    } else {
        if (isReturn) {
            [params setObject:query.originPlace forKey:@"destinationplace"];
            [params setObject:query.destinationPlace forKey:@"originplace"];
            [params setObject:query.inboundDate forKey:@"outbounddate"];
        } else {
            [params setObject:query.originPlace forKey:@"originplace"];
            [params setObject:query.destinationPlace forKey:@"destinationplace"];
            [params setObject:query.outboundDate forKey:@"outbounddate"];
        }
        
    }
    
    
    return params;
}

#pragma mark - SkySession Delegate

- (void) sessionCreated
{
    [self performSelector:@selector(querySession) withObject:nil afterDelay:1.0f];
}

-(void) querySession
{
    [allSession searchItinerariesWithSortType:@"price" page:0 stops:self.stopcount];
}

- (void)returnItinerarys:(NSArray *)itinerarys pageIndex:(int) index;
{
    NSLog(@"return round way itinerarys data");
    
    self.allItinerarys = itinerarys;
    [priceVC setLimitedOutItinerarys:itinerarys];
    [durationVC setLimitedOutItinerarys:itinerarys];
    [takeoffVC setLimitedOutItinerarys:itinerarys];
    [landingVC setLimitedOutItinerarys:itinerarys];
//    [allSession createBookSession:dictParams];
}

#pragma mark - FlightsVC delegate

- (void)didSelectItinerary:(Itinerary *) itinerary
{
    if (returnLeg) {
        selectedInItinerary = itinerary;
        //如果有返程日期，则进入往返的订票详情
//        NSDictionary *paramsDict = [AllFlightsVC getParams:params isReturn:returnLeg isALL:YES];
//        SkySession *allSession = [[SkySession alloc] initWithParams:paramsDict];
//        [inSession createBookSession:[self getBookParams]];
//        [allSession createBookSession:[self getBookParams]];
        NSArray * priceOptions = [self getPriceOption:selectedOutItinerary.outboundLegId inLegid:selectedInItinerary.outboundLegId];
        BookFlighsVC *booksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookFlighsVC"];
        [booksVC initData:selectedOutItinerary inItinerary:selectedInItinerary session:allSession params:[self getBookParams]];
        booksVC.priceOtions = priceOptions;
        [self.navigationController pushViewController:booksVC animated:YES];
    } else {
        selectedOutItinerary = itinerary;
        if (params.inboundDate) {
            //进入下一步，选择返程机票
            AllFlightsVC *allFlightsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AllFlights"];
            NSArray *limitedItinerarys = [self getInboundItinerarys:itinerary];
            [allFlightsVC initData:params isReturn:YES itinerary:itinerary limitedItinerarys:limitedItinerarys allsession:allSession];
            allFlightsVC.allItinerarys = self.allItinerarys;
            allFlightsVC.stopcount = self.stopcount;
            [self.navigationController pushViewController:allFlightsVC animated:YES];
        } else {
            //如果没有返程日期，则直接进入单程的订票详情
            [outSession createBookSession:[self getBookParams]];
            
            BookFlighsVC *booksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookFlighsVC"];
            [booksVC initData:selectedOutItinerary inItinerary:selectedInItinerary session:outSession params:nil];
            [self.navigationController pushViewController:booksVC animated:YES];
        }
    }
}

-(void) beginLoadingAnimation
{
    if (!spinKitView) {
        spinKitView =[[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStylePlane color:[UIColor colorWithRed:128/225 green:0.0f blue:0.0f alpha:0.5f]];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        spinKitView.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds));
    }
    
    [self.view addSubview:spinKitView];
}

-(void) endLoadingAnimation
{
    [spinKitView removeFromSuperview];
}

#pragma mark - Private

-(void) configOutBoundTopView
{
    if (!returnLeg) {
        return;
    }
    UILabel * priceLabel = (UILabel *)[self.outBoundView viewWithTag:1];
    Itinerary *itinerary = selectedOutItinerary;
    CurrencySkyModel * currency = [allSession getCurrency];
    NSString * billString = [currency getBillString:[itinerary getLowestPrice]];
    [priceLabel setText:billString];
    
    UILabel * dateLabel = (UILabel *)[self.outBoundView viewWithTag:2];
    NSString *timeString = [itinerary.outboundLeg_ getFormatedTime];
    [dateLabel setText:timeString];
    
    UILabel * durationLabel = (UILabel *)[self.outBoundView viewWithTag:3];
    NSString *durationString = [itinerary.outboundLeg_ getFormatedDuration];
    [durationLabel setText:durationString];
    
    if (itinerary.outboundLeg_.carriers.count > 0) {
        Carriers * carrier = (Carriers *)itinerary.outboundLeg_.carriers_[0];
        
        UILabel * carrierNameLabel = (UILabel *)[self.outBoundView viewWithTag:5];
        [carrierNameLabel setText:carrier.name];
        
        //        int duration = itinerary.outboundLeg_.duration.intValue + itinerary.inboundLeg_.duration.intValue;
        //        [carrierNameLabel setText:[NSString stringWithFormat:@"%d", duration]];
    }
    
    UILabel * titleLabel = (UILabel *)[self.outBoundView viewWithTag:7];
    
    NSString *dateString = [allSession getFormatedDate: allSession.flights.query.outboundDate];
    dateString = [NSString stringWithFormat:@"Outbound on %@", dateString];
    [titleLabel setText:dateString];
    
    [FlightsVC drawItinarery:self.outBoundView itinerary:itinerary];
}

-(NSArray *) getPriceOption:(NSString *) outLegid inLegid:(NSString *) inLegid
{
    for (Itinerary *itinerary in self.allItinerarys) {
        if ([itinerary.outboundLegId isEqualToString:outLegid] && [itinerary.inboundLegId isEqualToString:inLegid]) {
            return itinerary.pricingOptions;
        }
    }
    return nil;
}

-(NSArray *) getInboundItinerarys:(Itinerary *) selectedItinerary
{
    NSMutableArray *inboundItinerarys = [[NSMutableArray alloc] init];
    for (Itinerary *itinerary in self.allItinerarys) {
        if ([itinerary.outboundLegId isEqualToString:selectedItinerary.outboundLegId]) {
            [inboundItinerarys addObject:itinerary];
        }
    }
    if (inboundItinerarys.count == 0) {
        NSLog(@"inboundItinerarys.count == 0");
    }
    return inboundItinerarys;
}

-(NSMutableDictionary *) getBookParams
{
    NSMutableDictionary *bookParams =[[NSMutableDictionary alloc] init];
    [bookParams setObject:selectedOutItinerary.outboundLegId forKey:@"outboundlegid"];
    if (selectedInItinerary.outboundLegId) {
        [bookParams setObject:selectedInItinerary.outboundLegId forKey:@"inboundlegid"];
    }
    [bookParams setObject:params.adults forKey:@"adults"];
    [bookParams setObject:params.children forKey:@"children"];
    [bookParams setObject:params.infants forKey:@"infants"];

    return bookParams;
}

@end
