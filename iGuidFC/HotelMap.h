//
//  HotelMap.h
//  iGuidFC
//
//  Created by dampier on 15/5/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ELongHotelData.h"

@interface HotelMap : UIViewController

@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) IBOutlet UILabel* addressLabel;

@property (nonatomic, strong) ELongHotelData* hotelXML;

@end
