//
//  FCMapInfoWindow.m
//  AMSlideMenu
//
//  Created by dampier on 14-2-22.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FCMapInfoWindow.h"
#import "ArticleSectionController.h"
#import "ShopMapVC.h"
#import <MapKit/MapKit.h>

@implementation FCMapInfoWindow
{
    POArticle * shop_;
    UIViewController *vc_;
}

-(void)dealloc
{
    shop_ = nil;
    vc_ = nil;
}

- (id)initWithFrame:(CGRect)frame shop:(POArticle *) shop VC:(UIViewController *) vc
{
    self = [super initWithFrame:frame];
    if (self) {
        shop_ = shop;
        vc_ = vc;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 59)];
        [imageView setImage:[UIImage imageNamed:shop_.imagename]];
        [self addSubview:imageView];
        
        UIImageView *splitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 10, 1, 39)];
        [splitImageView setImage:[UIImage imageNamed:@"split.png"]];
        [self addSubview:splitImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 7, 150, 21)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
        titleLabel.text = shop_.title;
        
        [self addSubview:titleLabel];
        
        UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 30, 150, 21)];
        [remarkLabel setText: shop_.remark];
        [remarkLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
        [self addSubview:remarkLabel];
        
        UIImageView *discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(194, 0, 30, 30)];
        [discountImageView setImage:[UIImage imageNamed:@"discount-icon.png"]];
        [self addSubview:discountImageView];
        
        UIButton *directBtn = [[UIButton alloc] initWithFrame:CGRectMake(225, 9, 42, 42)];
        [directBtn setBackgroundImage:[UIImage imageNamed:@"directions-icon.png"] forState:UIControlStateNormal];
        [directBtn addTarget:self action:@selector(directTaped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:directBtn];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 225, frame.size.height)];
        [btn addTarget:self action:@selector(infoWindowTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}

- (UIViewController*)viewController{
    UIViewController *currentViewController;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return currentViewController;
}

- (void) infoWindowTaped:(id) sender
{
//    UIViewController *viewController = [self viewController];
    ShopMapVC *viewController =(ShopMapVC *) vc_;
    ArticleSectionController *childController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
    
    childController.masterkeyid = shop_.primaryid;
    
    childController.title = shop_.title;
    childController.articleTitle = shop_.title;
    [viewController.navigationController pushViewController: childController animated:(true)];
    
    [viewController dismissPop];
}

-(void)directTaped
{
    //coordinates for the place we want to display
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(shop_.positionx,shop_.positiony);
    rdOfficeLocation = [FCMapInfoWindow AppleMapOffsetCoordinate:rdOfficeLocation];
    //Apple Maps, using the MKMapItem class
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
    //        MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[CLPlacemark ]];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = [NSString stringWithFormat:@"%@ / %@", shop_.title, shop_.remark] ;
    [item openInMapsWithLaunchOptions:nil];
}

-(void)openActionSheet:(id)sender {
    //give the user a choice of Apple or Google Maps
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Open in Maps" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [sheet showInView:self];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //coordinates for the place we want to display
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(shop_.positionx,shop_.positiony);
    if (buttonIndex==0) {
        rdOfficeLocation = [FCMapInfoWindow AppleMapOffsetCoordinate:rdOfficeLocation];
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:rdOfficeLocation addressDictionary:nil];
//        MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:[CLPlacemark ]];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        item.name = @"ReignDesign Office";
        [item openInMapsWithLaunchOptions:nil];
    } else if (buttonIndex==1) {
        //Google Maps
        //construct a URL using the comgooglemaps schema
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",rdOfficeLocation.latitude,rdOfficeLocation.longitude]];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            NSLog(@"Google Maps app is not installed");
            //left as an exercise for the reader: open the Google Maps mobile website instead!
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+(CLLocationCoordinate2D) AppleMapOffsetCoordinate:(CLLocationCoordinate2D) position
{
    CLLocationCoordinate2D resultPosition;
#ifdef TH
    CLLocationCoordinate2D mapPosition = CLLocationCoordinate2DMake(39.880517, 116.407371);
    CLLocationCoordinate2D actualPosition = CLLocationCoordinate2DMake(39.8819145, 116.4135414);
    resultPosition = CLLocationCoordinate2DMake(position.latitude + (actualPosition.latitude - mapPosition.latitude), position.longitude + (actualPosition.longitude - mapPosition.longitude));
#endif
    
#ifdef SP_VERSION
//    mapPosition = CLLocationCoordinate2DMake(39.997961, 116.269658);
//    actualPosition = CLLocationCoordinate2DMake(39.996659, 116.263627);
//    resultPosition = CLLocationCoordinate2DMake(position.latitude + (mapPosition.latitude - actualPosition.latitude), position.longitude + (mapPosition.longitude - actualPosition.longitude));
#endif

    
    //    NSLog(@"orignal %f %f, new %f, %f", position.latitude, position.longitude, resultPosition.latitude, resultPosition.longitude);
    return resultPosition;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
