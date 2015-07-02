//
//  SubSpotAnnotation.m
//  iGuidFC
//
//  Created by dampier on 15/3/27.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SubSpotAnnotation.h"

@implementation SubSpotAnnotation

-(void) dealloc
{
    _title = nil;
    _subtitle = nil;
    _view = nil;
    _userData =nil;
}
- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!self.view) {
        static NSString * const identifier = @"MyCustomAnnotation";
        self.view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (self.view) {
            self.view.annotation = self;
        } else {
            self.view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:identifier];
        }
        switch (self.annotationType) {
            case ANNOTYPESubspot:
                self.view.image = [UIImage imageNamed: @"marker_map.png"];
                self.view.alpha = 0.4f;
                break;
            case ANNOTYPETaxi:
                self.view.image = [UIImage imageNamed: @"taximarker.png"];
                break;
            case ANNOTYPEAtm:
                self.view.image = [UIImage imageNamed: @"atm.png"];
                break;
            case ANNOTYPEToilet:
                self.view.image = [UIImage imageNamed: @"toilet1.png"];
                break;
            case ANNOTYPETicket:
                self.view.image = [UIImage imageNamed: @"ticket.png"];
                break;
            case ANNOTYPESubway:
                self.view.image = [UIImage imageNamed:@"metro.png"];
                break;
            case ANNOTYPECheckpint:
                self.view.image = [UIImage imageNamed:@"checkpoint.png"];
                break;
            case ANNOTYPEMylocation:
                self.view.image = [UIImage imageNamed:@"myLocation.png"];
                self.view.alpha = 0.7f;
                break;
            case ANNOTYPEHotel:
                self.view.image = [UIImage imageNamed: @"marker_map.png"];
                break;
            case ANNOTYPEShop:
                self.view.image = [UIImage imageNamed: @"discount1.png"];
                break;
            default:
                break;
        }
        
    } else {
        self.view.annotation = self;
    }
    return self.view;
}

@end
