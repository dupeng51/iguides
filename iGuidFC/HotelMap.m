//
//  HotelMap.m
//  iGuidFC
//
//  Created by dampier on 15/5/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "HotelMap.h"
#import "SubSpotAnnotation.h"
#import "MapVC.h"

@interface HotelMap ()

@end

@implementation HotelMap

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SubSpotAnnotation *point = [[SubSpotAnnotation alloc] init];
    point.title = self.hotelXML.Detail.Name;
    point.annotationType = ANNOTYPEHotel;
//    point.subtitle = spot.remark;
    point.coordinate = CLLocationCoordinate2DMake(self.hotelXML.Detail.GoogleLat.doubleValue, self.hotelXML.Detail.GoogleLon.doubleValue);
    [self.mapView addAnnotation:point];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [annotations addObject:point];
    
    MKCoordinateRegion region = [MapVC regionForAnnotations:annotations mapView:self.mapView];
    [self.mapView setRegion:region animated:YES];
    
    [self.addressLabel setText:self.hotelXML.Detail.Address];
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

@end
