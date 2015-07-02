//
//  ShopMapVC.m
//  iGuidFC
//
//  Created by dampier on 14-10-5.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "ShopMapVC.h"
#import "FCMapController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FCMapInfoWindow.h"
#import "FCMapInfoWindow2.h"
#import "PopoverView.h"
#import "AppDelegate.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
#import "FCSettingVC.h"
#import <MapKit/MapKit.h>

@interface ShopMapVC ()

@end

@implementation ShopMapVC{
    GMSMapView *mapView_;
    MKMapView *mapView1_;
    //    int buttomViewHeight;
    GMSGroundOverlay *overlay0;
    GMSGroundOverlay *overlay1;
    GMSGroundOverlay *overlay2;
    UIButton *_myLocationButton;
    UIButton *_currentVoiceButton;
    NSArray *spots;
    NSArray *markers;
    CLLocationManager *myLocationManager;
    int buttomViewHeight;
    int zoomLevel;
    PopoverView *popView;
    POArticle *currentShop;
    GMSMarker *marker_;
    //    CLLocation *_centrolLocation;
}

#define margin 60
#define markerDefaultOpacity 0.4
#define markerHighLightOpacity 1
#define mapBearing 2.1
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define north 39.923083
#define south 39.912592
#define east 116.401985
#define west 116.392033

#define plistFileName @"guidesetting.plist"
#define keySatellite @"satelite"
#define KeyFullVersion @"fullversion"

#ifdef SP_VERSION
#define north 40.002486
#define south 39.979479
#define east 116.277966
#define west 116.254757
#endif

#ifdef TH
#define north 39.887664
#define south 39.872699
#define east 116.415049
#define west 116.391432
#endif


@synthesize x, y, lineNo, selectedSpotIndex, butomView, _currentLocation;
/*----------------------------------------------------*/
#pragma mark - Lifecycle -
/*----------------------------------------------------*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.918673
    //                                                            longitude:116.397293
    //                                                                 zoom:15];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        zoomLevel = 17.8;
    } else {
        zoomLevel = 16;
    }
    CLLocationCoordinate2D centrolPos = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.918145, 116.396986)];
    float bearingValue = -2.1;
#ifdef SP_VERSION
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        zoomLevel = 17.8;
    } else {
        zoomLevel = 15;
    }
    centrolPos = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.994597,116.268071)];
    bearingValue = 0;
#endif
#ifdef TH
    if (self.view.frame.size.width > 320) {
        zoomLevel = 16;
    } else {
        zoomLevel = 16;
    }
    centrolPos = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.884282, 116.412348)];
    bearingValue = 0;
#endif
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centrolPos.latitude
                                                            longitude:centrolPos.longitude
                                                                 zoom:zoomLevel
                                                              bearing:bearingValue
                                                         viewingAngle:0];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //    mapView_.settings.myLocationButton = YES;
    mapView_.settings.rotateGestures = NO;
    [mapView_ setMinZoom:zoomLevel maxZoom:18];
    mapView_.delegate = self;
    
    mapView_.mapType = kGMSTypeNone;
#ifdef SP_VERSION
    mapView_.mapType = kGMSTypeNormal;
    [self addSPMapCover];
#endif
#ifdef TH
    mapView_.mapType = kGMSTypeSatellite;
    [mapView_ setMinZoom:zoomLevel maxZoom:17];
#endif
    //    CGRect rect = CGRectMake(0, 20, 320, 460);
    //    mapView1_ = [[MKMapView alloc] initWithFrame:rect];
    //    [mapView1_ setMapType:MKMapTypeStandard];
    //    MKCoordinateSpan theSpan;
    //    theSpan.latitudeDelta=0.01;
    //    theSpan.longitudeDelta=0.01;
    //    MKCoordinateRegion theRegion;
    //    theRegion.center=centrolPos;
    //    theRegion.span=theSpan;
    //    [mapView1_ setRegion:theRegion];
    
    self.view = mapView_;
    
    //释放指针
    camera = nil;
    
    //    _myLocationButton = [self getLocationButton];
    //mapView_.settings.compassButton = YES;
    //    mapView_.settings.myLocationButton = YES;
    //mapView_.settings.zoomGestures = YES;
    //初始化数据
    [self initData];
}

-(void)dealloc {
    
    if (butomView) {
        butomView = nil;
    }
    popView = nil;
    currentShop = nil;
    marker_ = nil;
    
    if (mapView_) {
        [mapView_ clear];
        
        mapView_.delegate = nil;
        mapView_ = nil;
    }
    overlay0 = nil;
    overlay1 = nil;
    overlay2 = nil;
    if (_myLocationButton) {
        [_myLocationButton removeFromSuperview];
        _myLocationButton = nil;
    }
    if (_currentVoiceButton) {
        [_currentVoiceButton removeFromSuperview];
        _currentVoiceButton = nil;
    }
    spots = nil;
    selectedSpotIndex = nil;
    myLocationManager = nil;
    //    _centrolLocation = nil;
    _currentLocation = nil;
    markers = nil;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    overlay0.map = nil;
    overlay0 = nil;
    mapView_.mapType = kGMSTypeNone;
    // Dispose of any resources that can be recreated.
}
/*----------------------------------------------------*/
#pragma mark - Public Action -
/*----------------------------------------------------*/

//代理GMSMapViewDelegate的方法
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    FCMapInfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
//
//    return view;
//}
/*----------------------------------------------------*/
#pragma mark - Map event method -
/*----------------------------------------------------*/
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    marker_ = marker;
    [self highlightMarkerWithMarker:marker];
    
    [self showPop];
    
    return YES;
}

//在地图空白处点击，在非Marker处点击
- (void)mapView:(GMSMapView *) mapView didTapAtCoordinate: (CLLocationCoordinate2D) coordinate
{
    if (butomView) {
        CGRect rect = [butomView frame];
        if (rect.origin.y < self.view.frame.size.height) {
            
            [FCMapInfoWindow2 beginAnimations:nil context:nil];
            [FCMapInfoWindow2 setAnimationDuration:0.2];
            
            CGRect rect = [butomView frame];
            rect.origin.y = self.view.frame.size.height;
            [butomView setFrame:rect];
            
            CGRect rect1 = _myLocationButton.frame;
            rect1.origin.y = mapView_.frame.size.height - 45;
            [_myLocationButton setFrame:rect1];
            
            CGRect rect2 = _currentVoiceButton.frame;
            rect2.origin.y = mapView_.frame.size.height - 90;
            [_currentVoiceButton setFrame:rect2];
            
            for (GMSMarker *othermarker in markers) {
                if (othermarker.userData) {
                    othermarker.opacity = markerDefaultOpacity;
                }
            }
            //还原地图,向下移动
            CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(south, west);
            CGPoint point = [mapView_.projection pointForCoordinate:southWest];
            if (point.y < self.view.frame.size.height) {
                CGPoint cameraPos;
                cameraPos.x = self.view.frame.size.width/2;
                cameraPos.y = self.view.frame.size.height/2 - (butomView.frame.size.height - point.y);
                [mapView animateToLocation:[mapView_.projection coordinateForPoint:cameraPos]];
            }
            
            [FCMapInfoWindow2 commitAnimations];
        }
    }
    
}
- (void) mapView:(GMSMapView *) mapView didLongPressAtCoordinate:(CLLocationCoordinate2D) coordinate
{
    NSNumber *index = [self getTheNeareastSpotIndex:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] exceptIndex:-1];
    if (index) {
        GMSMarker * marker = [self markerWithIndex:[index integerValue]];
        if (marker) {
            [self showInfoWindow:marker];
        }
    }
}

- (void) mapView:(GMSMapView *) mapView didChangeCameraPosition:(GMSCameraPosition *) position
{
    double north1 = north;
    double south1 = south;
    double west1 = west;
    double east1 = east;
#ifdef TH
    north1 = 39.891233;
    south1 = south;
    west1 = west;
    east1 = 116.419856;
#endif
    
    //限制地图显示的范围
    BOOL isChanged = NO;
    //    CLLocationCoordinate2D pos = position.targetAsCoordinate;
    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(north1, east1)];
    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(south1, west1)];
    CGPoint northEastpoint = [mapView_.projection pointForCoordinate:northEast];
    CGPoint southWestpoint = [mapView_.projection pointForCoordinate:southWest];
    CGPoint cameraPos;
    cameraPos.x = self.view.frame.size.width/2;
    cameraPos.y = self.view.frame.size.height/2;
    //超出东面
    if (northEastpoint.x < self.view.frame.size.width) {
        cameraPos.x = self.view.frame.size.width/2 - (self.view.frame.size.width - northEastpoint.x);
        isChanged = YES;
    }
    //超出北面
    if (northEastpoint.y > 0) {
        cameraPos.y = self.view.frame.size.height/2 + northEastpoint.y;
        isChanged = YES;
    }
    //超出西面
    if (southWestpoint.x > 0) {
        cameraPos.x = self.view.frame.size.width/2 + southWestpoint.x;
        isChanged = YES;
    }
    //超出南面
    if (southWestpoint.y < butomView.frame.origin.y) {
        cameraPos.y = self.view.frame.size.height/2 - (butomView.frame.origin.y - southWestpoint.y);
        isChanged = YES;
    }
    if (isChanged) {
        [mapView animateToLocation:[mapView_.projection coordinateForPoint:cameraPos]];
    }
//    [self addMap];
}
/*----------------------------------------------------*/
#pragma mark - Popover Event -
/*----------------------------------------------------*/
- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    for (GMSMarker *othermarker in markers) {
        if (othermarker.userData) {
            othermarker.opacity = markerDefaultOpacity;
        }
    }
}
/*----------------------------------------------------*/
#pragma mark - location Event -
/*----------------------------------------------------*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    _currentLocation = [locations lastObject];
#ifdef SP_VERSION
    CLLocationCoordinate2D newLocation = [FCMapController offsetCoordinate:_currentLocation.coordinate];
    _currentLocation = [[CLLocation alloc] initWithLatitude:newLocation.latitude longitude:newLocation.longitude];
#endif
#ifdef TH
    
#endif
    
    if (![self isOut:_currentLocation.coordinate]) {
//        [mapView_ animateToLocation:_currentLocation.coordinate];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            [mapView_ animateToZoom:17];
//        } else {
//            [mapView_ animateToZoom:16];
//        }
        //        mapView_.myLocationEnabled = YES;
        [self showMyLocation:_currentLocation.coordinate isClear:NO];
        
    } else {
        [manager stopUpdatingLocation];
        [self showMyLocation:_currentLocation.coordinate isClear:YES];
    }
    //    self.title = [NSString stringWithFormat:@"%f, %f",_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
    //    [butomView updatePos:_currentLocation.coordinate];
    //[self.locationManager stopUpdatingLocation];
    
}
/*----------------------------------------------------*/
#pragma mark - private method -
/*----------------------------------------------------*/
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
    //显示商店弹出窗口
    [self showPop];
    
    //底部添加景点播放控制面板
    if (!butomView) {
        butomView = [[[NSBundle mainBundle] loadNibNamed:bottomViewName owner:self options:nil] objectAtIndex:0];
        
        [mapView_ addSubview:butomView];
        CGRect rect = butomView.frame;
        rect.origin.y = self.view.frame.size.height;
        rect.size.width = self.view.frame.size.width;
        [butomView setFrame:rect];
    }
    //添加指定标记，用于文章中地图元素的调用，说明相关位置
    if ((x == 0) && (y == 0)) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(x, y);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Hello World";
        marker.map = mapView_;
    }
    //添加外部被选中的spot
    if (selectedSpotIndex) {
        [self showInfoWindow:[self markerWithIndex:selectedSpotIndex.integerValue]];
    }
    
    //显示最近的景点
    if (_currentLocation) {
        [self showNearestSpot:_currentLocation];
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
- (void) showInfoWindow:(GMSMarker *) marker
{
    if (!marker.userData) {
        //        return;
    }
    
    POArticle * poMarker = (POArticle *)marker.userData;
    butomView.userData = poMarker;
    if ([poMarker.type isEqualToString:@"spot"]) {
        NSInteger index = [spots indexOfObject:marker.userData];
        [butomView changeSpot:spots currentIndex:index];
        
        CGRect rect = butomView.frame;
        //如果不在屏幕内从底部动画移入
        if (rect.origin.y >= self.view.frame.size.height || rect.origin.y < 0) {
            [FCMapInfoWindow2 beginAnimations:nil context:nil];
            
            [FCMapInfoWindow2 setAnimationDuration:0.2];
            
            rect.origin.y = self.view.frame.size.height - butomView.frame.size.height;
            [butomView setFrame:rect];
            
            CGRect rect1 = _myLocationButton.frame;
            rect1.origin.y -= buttomViewHeight;
            [_myLocationButton setFrame:rect1];
            
            CGRect rect2 = _currentVoiceButton.frame;
            rect2.origin.y -= buttomViewHeight;
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
            
            rect.origin.y = self.view.frame.size.height - buttomViewHeight;
            [butomView setFrame:rect];
            
            CGRect rect1 = _myLocationButton.frame;
            rect1.origin.y -= buttomViewHeight;
            [_myLocationButton setFrame:rect1];
            
            CGRect rect2 = _currentVoiceButton.frame;
            rect2.origin.y -= buttomViewHeight;
            [_currentVoiceButton setFrame:rect2];
            
            [FCMapInfoWindow2 commitAnimations];
        }
    }
    [self highlightMarkerWithMarker:marker];
}

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
    
    frame.origin.x = mapView_.frame.size.width - 40;
    frame.origin.y = mapView_.frame.size.height - 45;
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
    [mapView_ addSubview:_myLocationButton];
    
    //创建按钮，该按钮可以定位当前正在播放的景点
    _currentVoiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // 确定宽、高、X、Y坐标
    CGRect frame1;
    frame1.size.width = 35;
    frame1.size.height = 35;
    
    frame1.origin.x = mapView_.frame.size.width - 40;
    frame1.origin.y = mapView_.frame.size.height - 90;
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
    [mapView_ addSubview:_currentVoiceButton];
    
    _currentVoiceButton.hidden = YES;

}

- (GMSMarker *)markerWithIndex:(NSInteger) index
{
    //根据Index查找Marker
    POArticle * spot = (POArticle *)[spots objectAtIndex:index];
    GMSMarker *marker;
    for (GMSMarker *tmpmarker in markers) {
        POArticle * userData = (POArticle *)tmpmarker.userData;
        if ([userData.primaryid isEqual:spot.primaryid]) {
            marker = tmpmarker;
        }
    }
    return marker;
}

//改变marker颜色,高亮显示，并移动到屏幕内
- (void) highlightMarker:(NSInteger) index
{
    GMSMarker *marker = [self markerWithIndex:index];
    if (!marker) {
        return;
    }
    [self highlightMarkerWithMarker:marker];
}

- (void) highlightMarkerWithMarker:(GMSMarker *) marker
{
    currentShop = marker.userData;
    
    for (GMSMarker *othermarker in markers) {
        if (othermarker.userData) {
            othermarker.opacity = markerDefaultOpacity;
        }
    }
    marker.opacity = markerHighLightOpacity;
    /*
     CGPoint point = [mapView_.projection pointForCoordinate:marker.position];
    CGPoint cameraPoint;
    cameraPoint.x = self.view.frame.size.width/2;
    cameraPoint.y = self.view.frame.size.height/2;
    
    //移动地图
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
    if (mapView_.camera.zoom < zoomLevel) {
        [mapView_ animateToZoom:zoomLevel];
    }
    GMSCameraUpdate *camera =[GMSCameraUpdate setTarget:[mapView_.projection coordinateForPoint:cameraPoint]];
    [mapView_ animateWithCameraUpdate:camera];
    camera = nil;
     */
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
    
    CLLocation *location = mapView_.myLocation;
    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.920726 longitude:116.399032];
    if (!location) {
        location = _currentLocation;
    }
    
    //    if (location && ![self isOut:location.coordinate]) {
    if (location) {
        if ([self isOut:location.coordinate]) {
            NSString *alertString = @"You are not in the Forbidden City.";
#ifdef SP_VERSION
            alertString = @"You are not in the Summer Palace.";
#endif
#ifdef TH
            alertString = @"You are not in the Temple of Heaven.";
#endif
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Problem"
                                                            message:alertString
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            [mapView_ animateToLocation:location.coordinate];
            [self showNearestSpot:location];
        }
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
        GMSMarker * marker = [self markerWithIndex:[index integerValue]];
        if (marker) {
            [self showInfoWindow:marker];
        }
        marker = nil;
    }
}

- (void)play{
    _currentVoiceButton.hidden = NO;
}
//定位当前正在播放的景点位置
- (void) currentVoiceLocation:(id)sender
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:butomView.currentPlayingSpot.positionx longitude:butomView.currentPlayingSpot.positiony];
    if (location) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //        [butomView changeSpot:spots currentIndex:appDelegate.currentPlayingIndex];
        
        GMSMarker * marker = [self markerWithIndex:appDelegate.currentPlayingIndex];
        if (marker) {
            [self showInfoWindow:marker];
        }
        
        marker = nil;
        appDelegate = nil;
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
    
    [self showSpots];
    [self showAtm];
    //添加厕所标示
    [self addToilet];
    [self showTaxi];
    //    [self showSubway];
    [self showTicket];
    //    _centrolLocation = [[CLLocation alloc]initWithLatitude:39.918262 longitude:116.397179];
}

-(void) showSpots
{
    if (!spots) {
        spots = [[DaoArticle alloc] getAllShop];
    }
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    int limitedNum = appDelegate.limiteNum;
    float isFullVersion = [FCSettingVC getfloatByKey:KeyFullVersion];
    NSMutableArray *mapMarkers = [[NSMutableArray alloc] init];
    int i = 0;
    for (POArticle *spot in spots) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(spot.positionx, spot.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerDefaultOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        if ((isFullVersion == 0) && (i >= limitedNum)) {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor grayColor]];
        } else {
            marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:120.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        }
        //        marker.icon = [UIImage imageNamed:@"map-marker.png"];
        marker.userData = spot;
        
        marker.snippet = spot.title;
        marker.map = mapView_;
        
        [mapMarkers addObject:marker];
        i++;
    }
    markers = mapMarkers;
}


-(void) showTaxi
{
    NSArray *atms = [[DaoArticle alloc] getAllTaxi];
    for (POArticle *atm in atms) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(atm.positionx, atm.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerDefaultOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *atmimage = [UIImage imageNamed:@"taximarker.png"];
        marker.userData = atm;
        marker.icon = atmimage;
        marker.map = mapView_;
    }
}
-(void) showTicket
{
    NSArray *atms = [[DaoArticle alloc] getAllTicket];
    for (POArticle *atm in atms) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(atm.positionx, atm.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerHighLightOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *atmimage = [UIImage imageNamed:@"ticket.png"];
        marker.icon = atmimage;
        marker.map = mapView_;
    }
}

-(void) showSubway
{
    NSArray *atms = [[DaoArticle alloc] getAllSubway];
    for (POArticle *atm in atms) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(atm.positionx, atm.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerHighLightOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *atmimage = [UIImage imageNamed:@"metro.png"];
        marker.icon = atmimage;
        marker.map = mapView_;
        marker = nil;
    }
}

- (void)showMyLocation:(CLLocationCoordinate2D) position isClear:(BOOL) isClear {
    for (GMSMarker *marker in mapView_.markers) {
        if (marker.userData) {
            if ([marker.userData isKindOfClass:[NSString class]]) {
                if ([marker.userData isEqualToString:@"myLocation"]) {
                    marker.map = nil;
                }
            }
        }
    }
    if (!isClear) {
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = 0.7;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *atmimage = [UIImage imageNamed:@"myLocation.png"];
        marker.userData = @"myLocation";
        marker.groundAnchor = CGPointMake(0.5, 0.5);
        marker.icon = atmimage;
        marker.map = mapView_;
    }
}

-(void) showAtm
{
    NSArray *atms = [[DaoArticle alloc] getAllAtm];
    for (POArticle *atm in atms) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(atm.positionx, atm.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerHighLightOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *atmimage = [UIImage imageNamed:@"atm.png"];
        //        marker.userData = atm;
        marker.icon = atmimage;
        marker.map = mapView_;
        marker = nil;
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
        mylocation = _currentLocation;
    }
    
    //    CLLocation *mylocation = [[CLLocation alloc] initWithLatitude:39.920726 longitude:116.399032];
    if (mylocation) {
        int i = 0;
        for (POArticle *spot in spots) {
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

-(BOOL)isOut:(CLLocationCoordinate2D) position
{
    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate:CLLocationCoordinate2DMake(north, east)];
    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate:CLLocationCoordinate2DMake(south, west)];
    if (position.latitude > northEast.latitude) {
        return YES;
    }
    CGPoint southWestPoint = [mapView_.projection pointForCoordinate:southWest];
    
    CLLocationCoordinate2D southWest1 = [mapView_.projection coordinateForPoint:CGPointMake(southWestPoint.x, southWestPoint.y - buttomViewHeight)];
    if (position.latitude < southWest1.latitude) {
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

+(BOOL)isAbsolutOut:(CLLocationCoordinate2D) position
{
    CLLocationCoordinate2D northEast = [self offsetCoordinate:CLLocationCoordinate2DMake(north, east)];
    CLLocationCoordinate2D southWest = [self offsetCoordinate:CLLocationCoordinate2DMake(south, west)];
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
//纠偏，解决定位不准确的问题
+(CLLocationCoordinate2D) offsetCoordinate:(CLLocationCoordinate2D) position
{
    
    CLLocationCoordinate2D mapPosition = CLLocationCoordinate2DMake(39.917225, 116.397024);
    CLLocationCoordinate2D actualPosition = CLLocationCoordinate2DMake(39.915805, 116.390769);
    CLLocationCoordinate2D resultPosition = CLLocationCoordinate2DMake(position.latitude + (actualPosition.latitude - mapPosition.latitude), position.longitude + (actualPosition.longitude - mapPosition.longitude));
#ifdef SP_VERSION
    mapPosition = CLLocationCoordinate2DMake(39.997961, 116.269658);
    actualPosition = CLLocationCoordinate2DMake(39.996659, 116.263627);
    resultPosition = CLLocationCoordinate2DMake(position.latitude + (mapPosition.latitude - actualPosition.latitude), position.longitude + (mapPosition.longitude - actualPosition.longitude));
#endif
#ifdef TH
    resultPosition = position;
#endif
    
    //    NSLog(@"orignal %f %f, new %f, %f", position.latitude, position.longitude, resultPosition.latitude, resultPosition.longitude);
    return resultPosition;
}

-(void) addToilet
{
    NSArray *toilets = [[DaoArticle alloc] getAllToilet];
    for (POArticle *toilet in toilets) {
        //        CLLocationCoordinate2D position = [self offsetCoordinate: CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony)];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(toilet.positionx, toilet.positiony);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        
        marker.opacity = markerHighLightOpacity;
        //        marker.icon = [GMSMarker markerImageWithColor:[UIColor whiteColor]];
        UIImage *toilet = [UIImage imageNamed:@"toilet1.png"];
        //    toilet.size = CGSizeMake(32, 32);
        marker.icon = toilet;
        marker.map = mapView_;
        marker = nil;
    }
}

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
    
    //添加故宫地图图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *documentsDirectory= NSTemporaryDirectory();
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
    overlay.map = mapView_;
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
//            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *documentsDirectory= NSTemporaryDirectory();
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

-(void) dismissPop {
    [popView dismiss];
}

-(void) showPop {
    if (!marker_) {
        return;
    }
    
    [self highlightMarkerWithMarker:marker_];
    
    CGPoint point= [mapView_.projection pointForCoordinate:marker_.position];
    point.y = point.y -40;
    CGPoint cameraPoint;
    cameraPoint.x = self.view.frame.size.width/2;
    cameraPoint.y = self.view.frame.size.height/2;
    
    //移动地图
    if (point.y < 180) {
        float moveLength = 180 - point.y;
        point.y = point.y + moveLength;
        cameraPoint.y = cameraPoint.y - moveLength;
    }
    GMSCameraUpdate *camera =[GMSCameraUpdate setTarget:[mapView_.projection coordinateForPoint:cameraPoint]];
    [mapView_ animateWithCameraUpdate:camera];
    
    //弹出气泡
    FCMapInfoWindow *view = [[FCMapInfoWindow alloc] initWithFrame:CGRectMake(0, 0, 267, 59) shop:marker_.userData VC:self];
    //    FCMapInfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
    //    [view setFrame:CGRectMake(0, 0, 100, 60)];
    view.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f]; //Give it a background color
    view.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor; //Add a border
    view.layer.borderWidth = 0.5f; //One retina pixel width
    view.layer.cornerRadius = 2.f;
    view.layer.masksToBounds = YES;
    
    popView = [[PopoverView alloc] initWithFrame:CGRectMake(0, 0, 293, 59)];
    popView.delegate = self;
    [popView showAtPoint:point inView:self.view withContentView:view];
}

@end
