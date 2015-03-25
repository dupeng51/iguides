//
//  KMLGeometry.h
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLElement.h"
#import <MapKit/MapKit.h>

@interface KMLGeometry : KMLElement {
    struct {
        int inCoords:1;
    } flags;
}

- (void)beginCoordinates;
- (void)endCoordinates;

// Create (if necessary) and return the corresponding Map Kit MKShape object
// corresponding to this KML Geometry node.
- (MKShape *)mapkitShape;

// Create (if necessary) and return the corresponding MKOverlayPathView for
// the MKShape object.
- (MKOverlayPathView *)createOverlayView:(MKShape *)shape;

@end
