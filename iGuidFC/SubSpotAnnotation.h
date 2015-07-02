//
//  SubSpotAnnotation.h
//  iGuidFC
//
//  Created by dampier on 15/3/27.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    ANNOTYPESubspot = 1,
    ANNOTYPETaxi,
    ANNOTYPEAtm,
    ANNOTYPEToilet,
    ANNOTYPETicket,
    ANNOTYPESubway,
    ANNOTYPEMylocation,
    ANNOTYPECheckpint,
    ANNOTYPEHotel,
    ANNOTYPEShop
} AnnoType;

@interface SubSpotAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic) int annotationType;

@property(nonatomic, strong) id userData;

@property (nonatomic, readwrite) MKAnnotationView *view;

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;



@end
