//
//  KMLPoint.h
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLGeometry.h"

// A KMLPoint element corresponds to an MKAnnotation and MKPinAnnotationView
@interface KMLPoint : KMLGeometry {
    CLLocationCoordinate2D point;
}

@property (nonatomic) CLLocationCoordinate2D point;

@end
