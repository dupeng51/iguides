//
//  RoutsMapVC.m
//  iGuidFC
//
//  Created by dampier on 14-4-8.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "RoutsMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FCMapInfoWindow.h"
#import "FCMapInfoWindow2.h"
#import "PopoverView.h"
#import "AppDelegate.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import "FCMapController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RoutsMapVC ()

@end

@implementation RoutsMapVC{
    GMSMapView *mapView_;
    //    int buttomViewHeight;
    GMSGroundOverlay *overlay1;
    GMSGroundOverlay *overlay2;
    GMSGroundOverlay *overlay3;
    UIButton *_myLocationButton;
    UIButton *_currentVoiceButton;
    CLLocationManager *myLocationManager;
    CLLocation *_currentLocation;
    CLLocation *_centrolLocation;
    int zoomLevel;
}
#define margin 60
#define buttomViewHeight   115
#define markerDefaultOpacity 0.4
#define markerHighLightOpacity 1
#define mapBearing 2.1
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define north 39.923083
#define south 39.912592
#define east 116.401985
#define west 116.392033

@synthesize x, y, segmentedControl, lineNo, selectedSpotIndex;

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        zoomLevel = 17.8;
    } else {
        zoomLevel = 16;
    }
    
    CLLocationCoordinate2D centrolPos = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.918303, 116.397293)];
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centrolPos.latitude
                                                            longitude:centrolPos.longitude
                                                                 zoom:zoomLevel
                                                              bearing:-2.1
                                                         viewingAngle:0];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.rotateGestures = NO;
    [mapView_ setMinZoom:zoomLevel maxZoom:18];
    mapView_.mapType = kGMSTypeNone;
    mapView_.delegate = self;
    self.view = mapView_;
    //释放指针
    camera = nil;
    
    //初始化数据
    [self initData];
}

-(void)dealloc {
    
    if (mapView_) {
        [mapView_ clear];
        [mapView_ removeFromSuperview];
        mapView_.delegate = nil;
        mapView_ = nil;
    }
    overlay1 = nil;
    overlay2 = nil;
    overlay3 = nil;
    if (_myLocationButton) {
        [_myLocationButton removeFromSuperview];
        _myLocationButton = nil;
    }
    if (_currentVoiceButton) {
        [_currentVoiceButton removeFromSuperview];
        _currentVoiceButton = nil;
    }
    selectedSpotIndex = nil;
    myLocationManager = nil;
    _centrolLocation = nil;
    _currentLocation = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initView];
    
    //开启定位
    //    CLLocationManager *locationManager;//定义Manager
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        if (!myLocationManager) {
            myLocationManager = [[CLLocationManager alloc] init];
        }
        myLocationManager.delegate = self;
        myLocationManager.desiredAccuracy=kCLLocationAccuracyBest;
        myLocationManager.distanceFilter = 10.0f;
        [myLocationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
    }
    // 开始定位
    //    [locationManager startUpdatingLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //至空，以避免重复显示
    selectedSpotIndex = nil;
}
/*----------------------------------------------------*/
#pragma mark - Public Action -
/*----------------------------------------------------*/
-(IBAction)switchAction:(id)sender
{
    [self switchToLine:[sender selectedSegmentIndex]];
    
}
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
	/*
     //弹出气泡
     FCMapInfoWindow *view = [[FCMapInfoWindow alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
     //    FCMapInfoWindow *view =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
     
     view.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f]; //Give it a background color
     view.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor; //Add a border
     view.layer.borderWidth = 0.5f; //One retina pixel width
     view.layer.cornerRadius = 2.f;
     view.layer.masksToBounds = YES;
     
     
     //距离marker上方40pix处显示气泡
     point.y = point.y - 40;
     //    [PopoverView showPopoverAtPoint:point inView:self.view withContentView:[daysView autorelease] delegate:self]; //Show calendar with no title
     [PopoverView showPopoverAtPoint:point inView:self.view withTitle:@"wu men" withContentView:view delegate:self]; //Show calendar with title
     */
    
    //    marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:2550.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.1f]];
    
    
	return YES;
}

- (void) mapView:(GMSMapView *) mapView didChangeCameraPosition:(GMSCameraPosition *) position
{
    //限制地图显示的范围
    BOOL isChanged = NO;
    //    CLLocationCoordinate2D pos = position.targetAsCoordinate;
    CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(north, east)];
    CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(south, west)];
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
    if (southWestpoint.y < self.view.frame.size.height) {
        cameraPos.y = self.view.frame.size.height/2 - (self.view.frame.size.height - southWestpoint.y);
        isChanged = YES;
    }
    //    if (position.targetAsCoordinate.latitude < south) {
    //        pos.latitude = south;
    //        isChanged = YES;
    //    }
    //    if (position.targetAsCoordinate.longitude < west) {
    //        pos.longitude = west;
    //        isChanged = YES;
    //    }
    //    if (position.targetAsCoordinate.latitude > north) {
    //        pos.latitude = north;
    //        isChanged = YES;
    //    }
    //    if (position.targetAsCoordinate.longitude > east) {
    //        pos.longitude = east;
    //        isChanged = YES;
    //    }
    if (isChanged) {
        [mapView animateToLocation:[mapView_.projection coordinateForPoint:cameraPos]];
    }
}

/*----------------------------------------------------*/
#pragma mark - location Event -
/*----------------------------------------------------*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    _currentLocation = [locations lastObject];
    if (![self isOut:_currentLocation.coordinate]) {
        [mapView_ animateToLocation:_currentLocation.coordinate];
//        [mapView_ animateToZoom:16];
        mapView_.myLocationEnabled = YES;
    }
    //[self.locationManager stopUpdatingLocation];
    
}
/*----------------------------------------------------*/
#pragma mark - private method -
/*----------------------------------------------------*/
- (void)initView
{
    //添加定位按钮
    [self addLocationButton];
    
    //添加指定标记，用于文章中地图元素的调用，说明相关位置
    if ((x == 0) && (y == 0)) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(x, y);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Hello World";
        marker.map = mapView_;
    }
    //显示指定路线
    [self switchToLine:lineNo];
    segmentedControl.selectedSegmentIndex = lineNo;
    
    
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
    
    if (!mapView_.myLocationEnabled)
    {
        mapView_.myLocationEnabled = YES;
    };
    
    CLLocation *location = mapView_.myLocation;
    //    CLLocation *location = [[CLLocation alloc] initWithLatitude:39.920726 longitude:116.399032];
    if (!location) {
        location = _currentLocation;
    }
    
    if (location) {
        [mapView_ animateToLocation:location.coordinate];
    }
    location = nil;
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


- (void) initData
{
//    [self showSpots];
    _centrolLocation = [[CLLocation alloc]initWithLatitude:39.918262 longitude:116.397179];
}

//切换到线路
- (void) switchToLine:(NSInteger) _lineNo
{
    
    switch (_lineNo) {
        case 0:
        {
            [mapView_ clear];
            overlay2 = nil;
            overlay3 = nil;
            NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"map_tourfc01" ofType:@"jpg"];
            UIImage *icon1 = [UIImage imageWithContentsOfFile:filePath1];
            if (!overlay1) {
                CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.912719,116.391853)];
                CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.923077,116.402301)];
                GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
                overlay1 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon1];
                overlayBounds = nil;
                overlay1.bearing = -2.1;
            }
            
            overlay1.map = mapView_;
            icon1 = nil;
            break;
        }
        case 1:
        {
            [mapView_ clear];
            overlay1 = nil;
            overlay3 = nil;
            NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"map_tourfc02" ofType:@"jpg"];
            UIImage *icon = [UIImage imageWithContentsOfFile:filePath2];
            if (!overlay2) {
                CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.912719,116.391853)];
                CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.923077,116.402301)];
                GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
                overlay2 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
                overlayBounds = nil;
                overlay2.bearing = -2.1;
            }
            
            overlay2.map = mapView_;
            icon = nil;
            break;
        }
        case 2:
        {
            [mapView_ clear];
            overlay1 = nil;
            overlay2 = nil;
            NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"map_tourfc03" ofType:@"jpg"];
            UIImage *icon = [UIImage imageWithContentsOfFile:filePath3];
            if (!overlay3) {
                CLLocationCoordinate2D southWest = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.912719,116.391853)];
                CLLocationCoordinate2D northEast = [FCMapController offsetCoordinate: CLLocationCoordinate2DMake(39.923077,116.402301)];
                GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
                overlay3 = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
                overlayBounds = nil;
                overlay3.bearing = -2.1;
            }
            
            overlay3.map = mapView_;
            icon = nil;
            break;
        }
        default:
            break;
    }
}
-(BOOL)isOut:(CLLocationCoordinate2D) position
{
    if (position.latitude > north) {
        return YES;
    }
    if (position.latitude < south) {
        return YES;
    }
    if (position.longitude < west) {
        return YES;
    }
    if (position.longitude > east) {
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
    return resultPosition;
}

@end
