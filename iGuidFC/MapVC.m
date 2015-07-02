//
//  MapVC.m
//  iGuidFC
//
//  Created by dampier on 15/3/26.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "MapVC.h"
#import "JPSThumbnailAnnotation.h"
#import "DaoArticle.h"
#import "POCity.h"
#import "POArticle.h"
#import "POSpot.h"
#import "SubSpotAnnotation.h"

#import "AppDelegate.h"
#import "FCMapController.h"
#import "DownloadListVC.h"

#import "KMLParser.h"
#import "KMLPoint.h"

@interface MapVC ()<MKMapViewDelegate>

@end

#define DocumentsDirectory NSTemporaryDirectory()
#define MUSICFile [DocumentsDirectory stringByAppendingPathComponent:@"test.mov"]

#define margin 60
#define markerDefaultOpacity 0.4
#define markerHighLightOpacity 1
#define mapBearing 2.1
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define plistFileName @"guidesetting.plist"
#define keySatellite @"satelite"
#define KeyFullVersion @"fullversion"

@implementation MapVC
{
    MKMapView *mapView;
    //    int buttomViewHeight;
    GMSGroundOverlay *overlay0;
    GMSGroundOverlay *overlay1;
    GMSGroundOverlay *overlay2;
    UIButton *_myLocationButton;
    UIButton *_currentVoiceButton;
    UIButton *backButton;
    CLLocationManager *myLocationManager;
    int buttomViewHeight;
    int zoomLevel;
    
    GuideArea *areaLeavel;
    KMLParser * kmlParser;
    AVAudioPlayer *alarmPlayer;
    POArticle *currentSpot;
    BOOL isShowedDownloadAlarm;
    CLLocationCoordinate2D currentSateliteLocation;
}

@synthesize x, y, lineNo, selectedSpotIndex, butomView, currentLocation, spots, subspots;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Map View
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    _citys = nil;
    spots = nil;
    subspots = nil;
    butomView = nil;
    
    mapView = nil;
    overlay0 = nil;
    overlay1 = nil;
    overlay2 = nil;

    
    _myLocationButton = nil;
    _currentVoiceButton = nil;
    selectedSpotIndex = nil;
    myLocationManager = nil;
    //    _centrolLocation = nil;
    currentLocation = nil;
    areaLeavel = nil;
    backButton = nil;
    
    kmlParser = nil;
    alarmPlayer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initView];
    //开启线控接受功能
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //开启定位
    //    CLLocationManager *locationManager;//定义Manager
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        if (!myLocationManager) {
            myLocationManager = [[CLLocationManager alloc] init];
            myLocationManager.delegate = self;
            myLocationManager.desiredAccuracy=kCLLocationAccuracyBest;
            myLocationManager.distanceFilter = 3.0f;
            if ([myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [myLocationManager requestWhenInUseAuthorization];
            }
            
            [myLocationManager startUpdatingLocation];
        }
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [butomView apear];
    //    [self switchToLine:0];
    // 开始定位
    //    [locationManager startUpdatingLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [butomView disapear];
    
    myLocationManager.delegate = nil;
    myLocationManager = nil;
    
    //关闭线控接受功能
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //至空，以避免重复显示
    selectedSpotIndex = nil;
}

/*----------------------------------------------------*/
#pragma mark - Override Method -
/*----------------------------------------------------*/
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //	if (event.type == UIEventTypeRemoteControl) {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            [butomView play:self];
            break;
        }
        case UIEventSubtypeRemoteControlPlay:
        {
            NSLog(@"UIEventSubtypeRemoteControlPlay...");
            break;
        }
        case UIEventSubtypeRemoteControlPause:
        {
            NSLog(@"UIEventSubtypeRemoteControlPause...");
            break;
        }
        case UIEventSubtypeRemoteControlStop:
        {
            NSLog(@"UIEventSubtypeRemoteControlStop...");
            break;
        }
        case UIEventSubtypeRemoteControlPreviousTrack:
            [butomView previousVoice:self];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            //              播放下一曲按钮
            [butomView nextVoice:self];
            NSLog(@"UIEventSubtype RemoteControl Next Track...");
            break;
            
        default:
            break;
    }
    //    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Map delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    } else if ([view.annotation isKindOfClass:[SubSpotAnnotation class]]) {
        //Sub Spot
        [self showInfoWindow: view.annotation];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    } else {
        if (butomView) {
            CGRect rect = [butomView frame];
            if (rect.origin.y < self.view.frame.size.height) {
                
                [FCMapInfoWindow2 beginAnimations:nil context:nil];
                [FCMapInfoWindow2 setAnimationDuration:0.2];
                
                CGRect rect = [butomView frame];
                rect.origin.y = self.view.frame.size.height;
                [butomView setFrame:rect];
                
                CGRect rect1 = _myLocationButton.frame;
                rect1.origin.y = mapView.frame.size.height - 45;
                [_myLocationButton setFrame:rect1];
                
                CGRect rect2 = _currentVoiceButton.frame;
                rect2.origin.y = mapView.frame.size.height - 90;
                [_currentVoiceButton setFrame:rect2];
                
                for (SubSpotAnnotation *othermarker in mapView.annotations) {
                    if ([othermarker isKindOfClass:[SubSpotAnnotation class]]) {
                        if (othermarker.userData) {
                            othermarker.view.alpha = markerDefaultOpacity;
                        }
                    }
                }
                //还原地图,向下移动
//                CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(south, west);
//                CGPoint point = [mapView.projection pointForCoordinate:southWest];
//                if (point.y < self.view.frame.size.height) {
//                    CGPoint cameraPos;
//                    cameraPos.x = self.view.frame.size.width/2;
//                    cameraPos.y = self.view.frame.size.height/2 - (butomView.frame.size.height - point.y);
//                    [mapView animateToLocation:[mapView.projection coordinateForPoint:cameraPos]];
//                }
                
                [FCMapInfoWindow2 commitAnimations];
            }
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    } else if ([annotation isKindOfClass:[SubSpotAnnotation class]]) {
        //Sub Spot
        return [((SubSpotAnnotation *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}
/*
- (void) calloutAccessoryTapped {
    Trip * trip = ((MyCustomAnnotation *)self.selectedAnnotationView.annotation).trip;
    Dao *dao = [[Dao alloc] init];
    CityMap *cityMap = [self.storyboard instantiateViewControllerWithIdentifier:@"CityMap"];
    cityMap.city = [dao findCityByID:trip.cityID];
    cityMap.trip = trip;
    cityMap.isInsert = false;
    cityMap.title = cityMap.city.cityName;
    [self.navigationController pushViewController:cityMap animated:YES];
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
    
}
*/
+ (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations mapView:(MKMapView *) mapView
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 0) {
        region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000);
        
    } else if ([annotations count] == 1) {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
        
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [mapView regionThatFits:region];
}

#pragma mark - Public

-(void) initData:(GuideArea *) guideArea
{
    switch (guideArea.leavel) {
        case AREALEAVEL_CITY:
        {
            [self addCitys:NO];
            break;
        }
        case AREALEAVEL_SPOT:
        {
            [self addSpotsByCityID:guideArea.PID isAnimation:NO];
            break;
        }
            
        case AREALEAVEL_SUBSPOT:
        {
            [self addSubspotsBySpotid:guideArea.PID isAnimation:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

-(KMLParser *) getKmlParser:(NSString *) spotid
{
    POSpot *spot = [[[DaoArticle alloc] init] getBigSpotWithID:spotid];
    NSString * path = [[NSBundle mainBundle] pathForResource:spot.kmlFileName ofType:@"kml"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    return kmlParser;
}

-(void) setAreaLeavel:(GuideArea *)area
{
    areaLeavel = area;
    if (area.leavel == AREALEAVEL_CITY) {
        [backButton setHidden:YES];
    } else {
        [backButton setHidden:NO];
    }
}

-(void) addBackBtn
{
    CGRect frame;
    frame.size.width = 35;
    frame.size.height = 35;
    
    frame.origin.x = mapView.frame.size.width - 40;
    frame.origin.y = 5;
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:frame];
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrowback.png"] forState:UIControlStateNormal];
    //    _myLocationButton.tintColor = [UIColor redColor];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.alpha = 0.8;
    
    // 设置圆角半径
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 8;
    //还可设置边框宽度和颜色
//    backButton.layer.borderWidth = 1;
//    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [backButton addTarget:self action:@selector(backBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setHidden:YES];
    [self.view addSubview:backButton];
}

-(void) showDetailAreaVC:(GuideArea *) area
{
    MapVC *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    
    [self.navigationController pushViewController: childController animated:(true)];
    [childController initData:area];
}

- (void) addCitys:(BOOL) animated {
    NSLog(@"refresh citys marker");
    DaoArticle *dao = [[DaoArticle alloc] init];
    self.citys = [dao getAllCitys];
    
    [mapView performSelectorOnMainThread:@selector(removeAnnotations:) withObject:mapView.annotations waitUntilDone:YES];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (POCity *city in self.citys) {
            JPSThumbnail *point = [[JPSThumbnail alloc] init];
            point.image = [UIImage imageNamed:city.imageName];
            point.title = city.name;
            point.subtitle = city.desc;
            point.coordinate = CLLocationCoordinate2DMake(city.lat, city.lon);
            point.disclosureBlock = ^{
                NSLog(@"selected %@", city.name);
                [self addSpotsByCityID:[city.pid stringValue] isAnimation:animated];
//                [self showDetailAreaVC:area];
            };
            
            [annotations addObject:[JPSThumbnailAnnotation annotationWithThumbnail:point]];
    }
    [mapView addAnnotations:annotations];
    
    [self showMyLocation:currentLocation.coordinate isClear:NO];
    
    [self setAreaLeavel:[[GuideArea alloc] initWithID:@"" leavel:AREALEAVEL_CITY]];
    
    MKCoordinateRegion region = [MapVC regionForAnnotations:annotations mapView:mapView];
    [mapView setRegion:region animated:animated];
    
    self.title = @"China";
}

- (void) addSpotsByCityID:(NSString *) cityid isAnimation:(BOOL) animated {
    NSLog(@"refresh spots marker");
    DaoArticle *dao = [[DaoArticle alloc] init];
    self.spots = [dao getBigSpotWithCityID:cityid];
    if (self.spots.count > 0) {
        [mapView performSelectorOnMainThread:@selector(removeAnnotations:) withObject:mapView.annotations waitUntilDone:YES];
        
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (POSpot *spot in self.spots) {
            JPSThumbnail *point = [[JPSThumbnail alloc] init];
            point.image = [UIImage imageNamed:spot.imageName];
            point.title = spot.name;
            point.subtitle = spot.desc;
            point.coordinate = CLLocationCoordinate2DMake(spot.lat, spot.lon);
            point.disclosureBlock = ^{
                NSLog(@"selected %@", spot.name);
                [self addSubspotsBySpotid: [spot.pid stringValue] isAnimation: YES];
//                [self showDetailAreaVC:area];
            };
            
            [annotations addObject:[JPSThumbnailAnnotation annotationWithThumbnail:point]];
        }
        [mapView addAnnotations:annotations];
        
        [self showMyLocation:currentLocation.coordinate isClear:NO];
        
        [self setAreaLeavel:[[GuideArea alloc] initWithID:cityid leavel:AREALEAVEL_SPOT]];
        
        MKCoordinateRegion region = [MapVC regionForAnnotations:annotations mapView:mapView];
        [mapView setRegion:region animated:animated];
        self.title = [dao getCityWithID:cityid].name;
    }
    
}

- (void) addSubspotsBySpotid:(NSString *) spotid isAnimation:(BOOL) animation {
    NSLog(@"refresh subspots marker");
    
    DaoArticle *dao = [[DaoArticle alloc] init];
    self.subspots = [dao getAllSpotsWithSpotid:spotid];
    if (self.subspots.count > 0) {
        [mapView performSelectorOnMainThread:@selector(removeAnnotations:) withObject:mapView.annotations waitUntilDone:YES];
        
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (POArticle *spot in self.subspots) {
            SubSpotAnnotation *point = [[SubSpotAnnotation alloc] init];
            point.title = spot.title;
            point.annotationType = ANNOTYPESubspot;
            point.subtitle = spot.remark;
            point.coordinate = CLLocationCoordinate2DMake(spot.positionx, spot.positiony);
            
            point.userData = spot;
            
            [annotations addObject:point];
        }
        [mapView addAnnotations:annotations];
        
        [self showMyLocation:currentLocation.coordinate isClear:NO];
        
        [self setAreaLeavel:[[GuideArea alloc] initWithID:spotid leavel:AREALEAVEL_SUBSPOT]];
        
        [self showAnnotation:ANNOTYPEAtm];
        [self showAnnotation:ANNOTYPEToilet];
        [self showAnnotation:ANNOTYPETaxi];
        [self showAnnotation:ANNOTYPETicket];
        [self showAnnotation:ANNOTYPECheckpint];
        [self showAnnotation:ANNOTYPEShop];

        
        MKCoordinateRegion region = [MapVC regionForAnnotations:annotations mapView:mapView];
        [mapView setRegion:region animated:animation];
        self.title = [dao getBigSpotWithID:spotid].name;
    }
    
}
- (void)initView
{
    NSString *bottomViewName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Some code for iPhone
        if (self.view.frame.size.width> 320) {
            // iPhone6
            bottomViewName = @"BottomViewiPhone6";
        } else {
            bottomViewName = @"MapInfoWindow2";
        }
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Some code for iPad
        bottomViewName = @"BottomView";
    }
    
    //添加地图图片
//    [self addMap];
    //添加定位按钮
    [self addLocationButton];
    //add back button
    [self addBackBtn];
    
    //maptype
    NSString *documentsDirectory= NSTemporaryDirectory();
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    float satellite = [[dict objectForKey:keySatellite] floatValue];
    if (satellite ==0) {
        mapView.mapType = MKMapTypeStandard;
    } else {
        mapView.mapType = MKMapTypeSatellite;
    }
    
    
    
    //底部添加景点播放控制面板
    if (!butomView) {
        butomView = [[[NSBundle mainBundle] loadNibNamed:bottomViewName owner:self options:nil] objectAtIndex:0];
        
        [mapView addSubview:butomView];
        CGRect rect = butomView.frame;
        rect.origin.y = self.view.frame.size.height;
        rect.size.width = self.view.frame.size.width;
        [butomView setFrame:rect];
    }
    //添加指定标记，用于文章中地图元素的调用，说明相关位置
    if ((x == 0) && (y == 0)) {
//        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(x, y);
//        SubSpotAnnotation *marker = [SubSpotAnnotation markerWithPosition:position];
//        marker.title = @"Hello World";
//        marker.map = mapView;
    }
    //添加外部被选中的spot
    if (selectedSpotIndex) {
        [self showInfoWindow:[self markerWithIndex:selectedSpotIndex.integerValue]];
    }
    
    //显示最近的景点
    if (currentLocation) {
        [self showNearestSpot:currentLocation];
    }
    //兼容IOS6
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
    //        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
    //                                    [UIColor whiteColor], UITextAttributeTextColor, 0, UITextAttributeTextShadowOffset, nil];
    //        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    //        [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    //        [segmentedControl setTintColor:RGB(172, 49, 22)];
    //    }
    //    UIDevice* device = [UIDevice currentDevice];
    //    BOOL backgroundSupported = NO;
    //
    //    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
    //        backgroundSupported = device.multitaskingSupported;
    //    }
}

//从底部弹出infowindow
- (void) showInfoWindow:(SubSpotAnnotation *) marker
{
    
    POArticle * poMarker = (POArticle *)marker.userData;
    butomView.userData = poMarker;
    if ([poMarker.type isEqualToString:@"spot"]) {
        NSInteger index = [subspots indexOfObject:marker.userData];
        currentSpot = subspots[index];
        
        [butomView changeSpot:subspots currentIndex:index];
        
        CGRect rect = butomView.frame;
        //如果不在屏幕内从底部动画移入
        if (rect.origin.y >= self.view.frame.size.height || rect.origin.y < 0) {
            [FCMapInfoWindow2 beginAnimations:nil context:nil];
            
            [FCMapInfoWindow2 setAnimationDuration:0.2];
            
            rect.origin.y = self.view.frame.size.height - butomView.frame.size.height;
            [butomView setFrame:rect];
            
            CGRect rect1 = _myLocationButton.frame;
            rect1.origin.y -= butomView.frame.size.height;
            [_myLocationButton setFrame:rect1];
            
            CGRect rect2 = _currentVoiceButton.frame;
            rect2.origin.y -= butomView.frame.size.height;
            [_currentVoiceButton setFrame:rect2];
            
            [FCMapInfoWindow2 commitAnimations];
        }
    }
    if ([poMarker.type isEqualToString:@"taxi"]) {
        [butomView changeTaxi:marker.userData];
        
        CGRect rect = butomView.frame;
        //如果不在屏幕内从底部动画移入
        if (rect.origin.y >= self.view.frame.size.height || rect.origin.y < 0) {
            [FCMapInfoWindow2 beginAnimations:nil context:nil];
            
            [FCMapInfoWindow2 setAnimationDuration:0.2];
            
            rect.origin.y = self.view.frame.size.height - butomView.frame.size.height;
            [butomView setFrame:rect];
            
            CGRect rect1 = _myLocationButton.frame;
            rect1.origin.y -= butomView.frame.size.height;
            [_myLocationButton setFrame:rect1];
            
            CGRect rect2 = _currentVoiceButton.frame;
            rect2.origin.y -= butomView.frame.size.height;
            [_currentVoiceButton setFrame:rect2];
            
            [FCMapInfoWindow2 commitAnimations];
        }
    }
    [self highlightMarkerWithMarker:marker];
}

-(void) moveMapToCurrentPlayingSpot
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.currentPlayingSpotID) {
        if (appDelegate.currentPlayingSpotID.intValue == areaLeavel.PID.intValue && areaLeavel.leavel == AREALEAVEL_SUBSPOT) {
            
        } else {
            [self addSubspotsBySpotid:appDelegate.currentPlayingSpotID.stringValue isAnimation:NO];
        }
    }
    
    
}

-(SubSpotAnnotation *) getAnnotationWithSpotID:(NSNumber *) subspotid
{
    for (SubSpotAnnotation *tmpmarker in mapView.annotations) {
        if ([tmpmarker isKindOfClass:[SubSpotAnnotation class]]) {
            POArticle * userData = (POArticle *)tmpmarker.userData;
            if ([userData.primaryid isEqual:subspotid]) {
                return tmpmarker;
                
            }
        }
    }
    return nil;
}

/*----------------------------------------------------*/
#pragma mark - location Event -
/*----------------------------------------------------*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"did Update Locations");
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *actualLocation = [locations lastObject];
    currentSateliteLocation = actualLocation.coordinate;
    GuideArea *area = [MapVC getArea:actualLocation.coordinate];
    
    CLLocationCoordinate2D newLocation = actualLocation.coordinate;
    if (area.leavel == AREALEAVEL_SUBSPOT) {
        //如果在景区则进行定位纠偏处理
        newLocation = [MapVC offsetCoordinate:actualLocation.coordinate spotid:area.PID];
    }
    currentLocation = [[CLLocation alloc] initWithLatitude:newLocation.latitude longitude:newLocation.longitude];
    
    if (area) {
        if ((areaLeavel.leavel > area.leavel) && (areaLeavel.leavel != area.leavel || ![areaLeavel.PID isEqualToString: area.PID] || !areaLeavel)) {
            [self setAreaLeavel:area];
            
            switch (area.leavel) {
                case AREALEAVEL_SUBSPOT:
                    [self addSubspotsBySpotid:area.PID isAnimation:NO];
                    break;
                case AREALEAVEL_SPOT:
                    [self addSpotsByCityID:area.PID isAnimation:NO];
                    break;
                case AREALEAVEL_CITY:
                    [self addCitys:NO];
                default:
                    break;
            }
        }
        /*
        if (mapView.annotations.count > 0) {
            MKCoordinateRegion region = [self regionForAnnotations:mapView.annotations];
            [mapView setRegion:region animated:YES];
        } else {
            [mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
        }
        [self showMyLocation:currentLocation.coordinate isClear:NO];
        */
    } else {
        [manager stopUpdatingLocation];
//        [self showMyLocation:currentLocation.coordinate isClear:NO];
    }
    //    self.title = [NSString stringWithFormat:@"%f, %f",_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
    //    [butomView updatePos:_currentLocation.coordinate];
    //[self.locationManager stopUpdatingLocation];
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (area.leavel == AREALEAVEL_SUBSPOT) {
        if (currentLocation) {
            POArticle *theNearestSpot = [self theNeareastSpot:area.PID];
            currentSpot = theNearestSpot;
            if (theNearestSpot) {
                if ([FCMapInfoWindow2 voiceExistWithSubspot:theNearestSpot]) {
                    if (appDelegate.audioPlayer.isPlaying) {
                        if (![theNearestSpot.primaryid isEqual:butomView.currentPlayingSpot.primaryid]) {
                            if (butomView.currentPlayingSpot) {
                                [appDelegate.audioPlayer stop];
                                
                                //播放切换音效
                                if (!alarmPlayer) {
                                    NSURL *fileURL1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dd" ofType:@"wav"]];
                                    alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL1 error:nil];
                                    alarmPlayer.delegate = self;
                                    alarmPlayer.volume = 2;//重置音量,(每次播放的默认音量好像是1.0)
                                    [alarmPlayer setNumberOfLoops:0];
                                }
                                [alarmPlayer prepareToPlay];
                                [alarmPlayer play];
                                
                                [self showInfoWindow:[self getAnnotationWithSpotID:theNearestSpot.primaryid]];
                            } else {
                                if ([spots indexOfObject:theNearestSpot]!= appDelegate.currentPlayingIndex) {
                                    [self showInfoWindow:[self getAnnotationWithSpotID:theNearestSpot.primaryid]];
                                    [butomView play:nil];
                                }
                            }
                        }
                    } else {
                        [self showInfoWindow:[self getAnnotationWithSpotID:theNearestSpot.primaryid]];
                        [butomView play:nil];
                    }
                } else {
                    // voice file not exist
                    if (!isShowedDownloadAlarm) {
                        [FCMapInfoWindow2 showDownloadAlarm:self];
                        isShowedDownloadAlarm = YES;
                    }
                }
                
            }
        }
    }
    
}

#pragma mark - Alert View method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //download Voice
    if (buttonIndex == 1) {
        DownloadListVC *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"downloadlistvc"];
        [childController addSpotToDownload:currentSpot.spotID.intValue];
        [self.navigationController pushViewController:childController animated:YES];
    }
    
}

#pragma mark - Audio method

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    if ([alarmPlayer isEqual:player])
//    {
//        
//        
//    }
    
    [butomView play:nil];
    
}

/*----------------------------------------------------*/
#pragma mark - Copy method -
/*----------------------------------------------------*/

- (void) addLocationButton
{
    if (_myLocationButton) {
        return;
    }
    // 创建定位按钮
    _myLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // 确定宽、高、X、Y坐标
    CGRect frame;
    frame.size.width = 35;
    frame.size.height = 35;
    
    frame.origin.x = mapView.frame.size.width - 40;
    frame.origin.y = mapView.frame.size.height - 45;
    [_myLocationButton setFrame:frame];
    [_myLocationButton setBackgroundImage:[UIImage imageNamed:@"location1"] forState:UIControlStateNormal];
    //    _myLocationButton.tintColor = [UIColor redColor];
    _myLocationButton.backgroundColor = [UIColor whiteColor];
    _myLocationButton.alpha = 0.8;
    
    // 设置圆角半径
    _myLocationButton.layer.masksToBounds = YES;
    _myLocationButton.layer.cornerRadius = 8;
    //还可设置边框宽度和颜色
    _myLocationButton.layer.borderWidth = 1;
    _myLocationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_myLocationButton addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:_myLocationButton];
    
    //创建按钮，该按钮可以定位当前正在播放的景点
    _currentVoiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // 确定宽、高、X、Y坐标
    CGRect frame1;
    frame1.size.width = 35;
    frame1.size.height = 35;
    
    frame1.origin.x = mapView.frame.size.width - 40;
    frame1.origin.y = mapView.frame.size.height - 90;
    [_currentVoiceButton setFrame:frame1];
    [_currentVoiceButton setBackgroundImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal];
    _currentVoiceButton.tintColor = [UIColor grayColor];
    _currentVoiceButton.backgroundColor = [UIColor whiteColor];
    _currentVoiceButton.alpha = 0.8;
    // 设置圆角半径
    _currentVoiceButton.layer.masksToBounds = YES;
    _currentVoiceButton.layer.cornerRadius = 8;
    //还可设置边框宽度和颜色
    _currentVoiceButton.layer.borderWidth = 1;
    _currentVoiceButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_currentVoiceButton addTarget:self action:@selector(currentVoiceLocation:) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:_currentVoiceButton];
    
    //如果正在播放则显示当前声音定位按钮
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer) {
        if (appDelegate.audioPlayer.isPlaying) {
            _currentVoiceButton.hidden = NO;
        } else {
            _currentVoiceButton.hidden = YES;
        }
    } else {
        _currentVoiceButton.hidden = YES;
        
    }
}

- (SubSpotAnnotation *)markerWithIndex:(NSInteger) index
{
    [self moveMapToCurrentPlayingSpot];
    
    //根据Index查找Marker
    POArticle * spot = (POArticle *)[subspots objectAtIndex:index];
    SubSpotAnnotation * marker = [self getAnnotationWithSpotID:spot.primaryid];
    return marker;
}

//改变marker颜色,高亮显示，并移动到屏幕内
- (void) highlightMarker:(NSInteger) index
{
    SubSpotAnnotation *marker = [self markerWithIndex:index];
    if (!marker) {
        return;
    }
    [self highlightMarkerWithMarker:marker];
}

- (void) highlightMarkerWithMarker:(SubSpotAnnotation *) marker
{
    
    for (SubSpotAnnotation *othermarker in mapView.annotations) {
        if ([othermarker isKindOfClass:[SubSpotAnnotation class]]) {
            if (othermarker.userData) {
                othermarker.view.alpha = markerDefaultOpacity;
            }
        }
    }
    marker.view.alpha = markerHighLightOpacity;
    
    CGPoint cameraPoint;
    cameraPoint.x = self.view.frame.size.width/2;
    cameraPoint.y = self.view.frame.size.height/2;
    
    //移动地图
    CGPoint point = [mapView convertCoordinate:marker.coordinate toPointToView:mapView];
    if (point.y < 50) {
        float moveLength = 50 - point.y;
        point.y = point.y + moveLength;
        cameraPoint.y = cameraPoint.y - moveLength;
    }
    //如果被butomView遮住
    if (point.y > butomView.frame.origin.y - margin) {
        float moveLength = point.y - (butomView.frame.origin.y - margin);
        point.y = point.y - moveLength;
        cameraPoint.y = cameraPoint.y + moveLength;
    }
    //如果右边
    if (point.x > self.view.frame.size.width - margin) {
        float moveLength = point.x - (self.view.frame.size.width - margin);
        point.x = point.x - moveLength;
        cameraPoint.x = cameraPoint.x + moveLength;
        
    }
    //如果左边
    if (point.x < margin) {
        float moveLength = margin - point.x;
        point.x = point.x + moveLength;
        cameraPoint.x = cameraPoint.x - moveLength;
        
    }
    //
    CLLocationCoordinate2D newCoordinate = [mapView convertPoint:point toCoordinateFromView:mapView];
    [mapView setCenterCoordinate:newCoordinate animated:YES];
}

-(void) backBtnTaped:(id)sender {
    switch (areaLeavel.leavel) {
        case AREALEAVEL_CITY:
        {
            
            break;
        }
        case AREALEAVEL_SPOT:
        {
            [self addCitys:YES];
            break;
        }
            
        case AREALEAVEL_SUBSPOT:
        {
            DaoArticle *dao = [[DaoArticle alloc] init];
            POSpot *spot = [dao getBigSpotWithID:areaLeavel.PID];
            
            [self addSpotsByCityID:spot.cityID.stringValue isAnimation:YES];
            break;
        }
        default:
            break;
    }
}

//定位当前位置
-(void) locationButtonClicked:(id)sender {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
    //                                                    message:@"单击了动态按钮！"
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"确定"
    //                                          otherButtonTitles:nil];
    //    [alert show];
    //    UIButton *button = (UIButton *) sender;
    
    //    if (!mapView_.myLocationEnabled)
    //    {
    //        mapView_.myLocationEnabled = YES;
    //    };
    
    CLLocation *location = mapView.userLocation.location;
    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.920726 longitude:116.399032];
    if (!location) {
        location = currentLocation;
    }
    
    //    if (location && ![self isOut:location.coordinate]) {
    if (location) {
//        if ([self isOut:location.coordinate]) {
//            NSString *alertString = @"You are not in the Forbidden City.";
//#ifdef SP_VERSION
//            alertString = @"You are not in the Summer Palace.";
//#endif
//#ifdef TH
//            alertString = @"You are not in the Temple of Heaven.";
//#endif
//#ifdef Yu
//            alertString = @"You are not in the Yu Garden.";
//#endif
//#ifdef LT
//            alertString = @"You are not in the Lama Temple.";
//#endif
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Problem"
//                                                            message:alertString
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
            
//        } else {
            [mapView setCenterCoordinate:location.coordinate animated:YES];
            [self showNearestSpot:location];
//        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    location = nil;
}

-(void) showNearestSpot:(CLLocation *)location
{
    NSNumber *index = [self getTheNeareastSpotIndex:location exceptIndex:-1];
    if (index) {
        SubSpotAnnotation * marker = [self markerWithIndex:[index integerValue]];
        if (marker) {
            [self showInfoWindow:marker];
        }
        marker = nil;
    }
}


//- (UIButton *) getLocationButton
//{
//    UIButton * button;
//    for (UIView *view in mapView_.subviews)
//    {
//        NSString *viewClassString = NSStringFromClass([view class]);
//        if ([viewClassString rangeOfString:@"GMSUISettingsView"].location != NSNotFound)
//        {
//            for (UIView *view2 in view.subviews) {
//                if ([view2 isKindOfClass:[UIButton class]]) {
//                    button = (UIButton *)view2;
//                }
//            }
//        }
//    }
//    return button;
//}

- (void)play{
    _currentVoiceButton.hidden = NO;
}
//定位当前正在播放的景点位置
- (void) currentVoiceLocation:(id)sender
{
    [self moveMapToCurrentPlayingSpot];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:butomView.currentPlayingSpot.positionx longitude:butomView.currentPlayingSpot.positiony];
    if (location) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [butomView changeSpot:spots currentIndex:appDelegate.currentPlayingIndex];
        
        SubSpotAnnotation * marker = [self markerWithIndex:appDelegate.currentPlayingIndex];
        if (marker) {
            [mapView selectAnnotation:marker animated:YES];
//            [mapView.delegate mapView:mapView didSelectAnnotationView:marker.view];
//            [self showInfoWindow:marker];
        }
        //        [mapView_ animateToLocation:location.coordinate];
        
        //        [self highlightMarker:appDelegate.currentPlayingIndex];
    }
    
    location = nil;
}

- (void) initData
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Some code for iPhone
        buttomViewHeight = 115;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Some code for iPad
        buttomViewHeight = 194;
    }
    
//    [self showSpots];
    // Annotations
    [self addCitys:NO];
    isShowedDownloadAlarm = NO;
}

- (void)showMyLocation:(CLLocationCoordinate2D) position isClear:(BOOL) isClear {
    return;
    
    for (id<MKAnnotation> marker in mapView.annotations) {
        if ([marker conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
            
        } else {
            if (((SubSpotAnnotation *)marker).annotationType == ANNOTYPEMylocation) {
                [mapView removeAnnotation:marker];
            }
        }
    }
    if (!isClear) {
        SubSpotAnnotation *point = [[SubSpotAnnotation alloc] init];
        
        point.coordinate = CLLocationCoordinate2DMake(position.latitude, position.longitude);
        point.annotationType = ANNOTYPEMylocation;
        
        [mapView addAnnotation:point];
    }
}

-(void) showAnnotation:(int) AnnoType
{
    NSArray *annotations;
    switch (AnnoType) {
        case ANNOTYPEAtm:
        {
            annotations = [[DaoArticle alloc] getAllAtm];
            break;
        }
        case ANNOTYPESubway:
        {
            annotations = [[DaoArticle alloc] getAllSubway];
            break;
        }
        case ANNOTYPETaxi:
        {
            annotations = [[DaoArticle alloc] getAllTaxi];
            break;
        }
        case ANNOTYPETicket:
        {
            annotations = [[DaoArticle alloc] getAllTicket];
            break;
        }
        case ANNOTYPEToilet:
        {
            annotations = [[DaoArticle alloc] getAllToilet];
            break;
        }
        case ANNOTYPECheckpint:
        {
            annotations = [[DaoArticle alloc] getAllCheckpoint];
            break;
        }
        case ANNOTYPEShop:
        {
            annotations = [[DaoArticle alloc] getAllShop];
            break;
        }
        default:
            break;
    }
    
    for (POArticle *annotation in annotations) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(annotation.positionx, annotation.positiony);
        
        SubSpotAnnotation *point = [[SubSpotAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(position.latitude, position.longitude);
        point.annotationType = AnnoType;
        
        [mapView addAnnotation:point];
    }
}
//获取最近的景点index，空则说明不在故宫附近，或定位关闭
- (NSNumber *)getTheNeareastSpotIndex:(CLLocation *) mylocation exceptIndex:(int) exceptIndex{
    //    BOOL isNear = [[[NSUserDefaults standardUserDefaults] objectForKey:@"play_nearby"] boolValue];
    //    if (!isNear) {
    //        return nil;
    //    }
    
    NSNumber *index;
    double minDistance = 1200;
    if (!mylocation) {
        mylocation = currentLocation;
    }
    
    //    CLLocation *mylocation = [[CLLocation alloc] initWithLatitude:39.920726 longitude:116.399032];
    if (mylocation) {
        int i = 0;
        for (POArticle *spot in subspots) {
            CLLocation *spotLocation =  [[CLLocation alloc] initWithLatitude:spot.positionx longitude: spot.positiony];
            double distance = [mylocation distanceFromLocation:spotLocation];
            if ((exceptIndex != i) && (distance < minDistance)) {
                minDistance = distance;
                index = [NSNumber numberWithInt:i];
            }
            i++;
            spotLocation = nil;
        }
    }
    return index;
}

+(GuideArea *) getArea:(CLLocationCoordinate2D) location {
    DaoArticle *dao = [[DaoArticle alloc] init];
    
    NSArray *bigspots = [dao getAllBigSpot];
    for (POSpot *spot in bigspots) {
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(spot.north, spot.east);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(spot.south, spot.west);
        if (![self isOut:location northEast:northEast southWest:southWest]) {
            GuideArea * area = [[GuideArea alloc] initWithID:[spot.pid stringValue] leavel:AREALEAVEL_SUBSPOT];
            return area;
        }
    }
    NSArray * citys = [dao getAllCitys];
    for (POCity *city in citys) {
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(city.north, city.east);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(city.south, city.west);
        if (![self isOut:location northEast:northEast southWest:southWest]) {
            GuideArea * area = [[GuideArea alloc] initWithID:[city.pid stringValue] leavel:AREALEAVEL_SPOT];
            return area;
        }
    }
    return [[GuideArea alloc] initWithID:nil leavel:AREALEAVEL_CITY];
}

+(BOOL)isOut:(CLLocationCoordinate2D) position northEast:(CLLocationCoordinate2D) northEast southWest:(CLLocationCoordinate2D) southWest
{
    
    if (position.latitude > northEast.latitude) {
        return YES;
    }
    if (position.latitude < southWest.latitude) {
        return YES;
    }
    if (position.longitude < southWest.longitude) {
        return YES;
    }
    if (position.longitude > northEast.longitude) {
        return YES;
    }
    return NO;
}

//根据定位的位置，寻找符合范围内的景点
- (POArticle *)theNeareastSpot:(NSString *) spotid
{
    POArticle *neareastSpot;
    
    if (currentLocation) {
        CLLocationCoordinate2D tmpCoordinate =currentSateliteLocation;

        NSString * primaryID;
        for (KMLPlacemark * placeMark in [self getKmlParser:spotid].marks) {
            if ([((KMLPolygon *)placeMark.geometry) pointinPolygon:tmpCoordinate]) {
                primaryID = placeMark.name;
                break;
            }
        }
        
        for (POArticle *spot in subspots) {
            if ([[spot.primaryid stringValue] isEqual: primaryID]) {
                neareastSpot = spot;
            }
        }
    }
    return neareastSpot;
}

//纠偏，解决定位不准确的问题
+(CLLocationCoordinate2D) offsetCoordinate:(CLLocationCoordinate2D) position spotid:(NSString *) spotid
{
    
    DaoArticle *dao = [[DaoArticle alloc] init];
    CLLocationCoordinate2D resultPosition = position;
    
    if (spotid) {
        POSpot *spot = [dao getBigSpotWithID:spotid];
        if (spot.WGS == 1) {
            resultPosition = CLLocationCoordinate2DMake(position.latitude + spot.latOffset, position.longitude + spot.lonOffset);
        } else {
            resultPosition = position;
        }
    }
    
    //    NSLog(@"orignal %f %f, new %f, %f", position.latitude, position.longitude, resultPosition.latitude, resultPosition.longitude);
    return resultPosition;
}
/*
-(IBAction)switchAction:(id)sender
{
    UISwitch *switcher = (UISwitch *)sender;
    [self showFCMap:switcher.on];
}

-(void) addMap
{
#ifdef SP_VERSION
    return;
#endif
#ifdef TH
    [self showTHMap];
    return;
#endif
#ifdef Yu
    [self showYuMap];
    return;
#endif
#ifdef LT
    return;
#endif
    
    //添加故宫地图图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName]; //3
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    float satellite = [[dict objectForKey:keySatellite] floatValue];
    [self showFCMap:(satellite == 0)];
}

- (void) addSPMapCover {
    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.978126, 116.252121)];
    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(40.002971, 116.280781)];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"summerPalaceMap" ofType:@"png"];
    UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
    
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
    GMSGroundOverlay *overlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
    overlay.map = mapView;
}
- (void) showYuMap {
    //    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(31.227718, 121.486887)];
    //    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(31.229752, 121.488526)];
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(31.225104, 121.490487);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(31.227897, 121.493507);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YuGardenMap" ofType:@"png"];
    UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
    
    if (!overlay2) {
        GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
        overlay2 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
    }
    overlay2.map = mapView_;
    mapView_.mapType = kGMSTypeNone;
}
//添加天坛地图
-(void)showTHMap
{
    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(south,west)];
    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(north,east)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"THMap" ofType:@"png"];
    UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
    if (!overlay2) {
        GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
        overlay2 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
    }
    overlay2.map = mapView_;
    mapView_.mapType = kGMSTypeNone;
}

//添加故宫地图
-(void)showFCMap:(BOOL) isShow
{
    if (isShow) {
        //添加故宫地图图片
        NSString *filePath;
        float zoomlevel = mapView_.camera.zoom;
        CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.912719,116.391853)];
        CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.923077,116.402301)];
        if (zoomlevel > 16 && !overlay0) {
            filePath = [[NSBundle mainBundle] pathForResource:@"fcmap" ofType:@"jpg"];
            UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
            if (!overlay0) {
                GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
                overlay1.map = nil;
                overlay1 = nil;
                overlay0 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
                overlay0.bearing = -2.1;
                overlayBounds = nil;
            }
            overlay0.map = mapView_;
            icon = nil;
        }
        if (zoomlevel <= 16 && !overlay1) {
            filePath = [[NSBundle mainBundle] pathForResource:@"fcmap2" ofType:@"jpg"];
            UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
            if (!overlay1) {
                GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
                overlay0.map = nil;
                overlay0 = nil;
                overlay1 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
                overlay1.bearing = -2.1;
                overlayBounds = nil;
            }
            overlay1.map = mapView_;
            icon = nil;
        }
        mapView_.mapType = kGMSTypeNone;
    } else {
        overlay0.map = nil;
        overlay0 = nil;
        overlay1.map = nil;
        overlay1 = nil;
        NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
        if(networkStatus == NotReachable) {
            // Put alternative content/message here
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                            message:@"Your network isn't avilable. Please check your settings and change to the satellite map again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName];
            
            // Load the file content and read the data into arrays
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            NSNumber *num = [NSNumber numberWithFloat:0.0];
            [dict setValue:num forKey:keySatellite];
            
            [dict writeToFile:path atomically:YES];
            
            [self showFCMap:YES];
        } else {
            mapView_.mapType = kGMSTypeSatellite;
        }
    }
}
*/

@end
