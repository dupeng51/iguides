//
//  KMLLineString.h
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLGeometry.h"

@interface KMLLineString : KMLGeometry {
    CLLocationCoordinate2D *points;
    NSUInteger length;
}

@property (nonatomic, readonly) CLLocationCoordinate2D *points;
@property (nonatomic, readonly) NSUInteger length;

@end
