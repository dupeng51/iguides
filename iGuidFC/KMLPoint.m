//
//  KMLPoint.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLPoint.h"

@implementation KMLPoint

@synthesize point;

- (void)endCoordinates
{
    flags.inCoords = NO;
    
    CLLocationCoordinate2D *points = NULL;
    NSUInteger len = 0;
    
    strToCoords(accum, &points, &len);
    if (len == 1) {
        point = points[0];
    }
    free(points);
    
    [self clearString];
}

- (MKShape *)mapkitShape
{
    // KMLPoint corresponds to MKPointAnnotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = point;
    return annotation;
}
// Convert a KML coordinate list string to a C array of CLLocationCoordinate2Ds.
// KML coordinate lists are longitude,latitude[,altitude] tuples specified by whitespace.
static void strToCoords(NSString *str, CLLocationCoordinate2D **coordsOut, NSUInteger *coordsLenOut)
{
    NSUInteger read = 0, space = 10;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * space);
    
    NSArray *tuples = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString *tuple in tuples) {
        if (read == space) {
            space *= 2;
            coords = realloc(coords, sizeof(CLLocationCoordinate2D) * space);
        }
        
        double lat, lon;
        NSScanner *scanner = [[NSScanner alloc] initWithString:tuple];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@","]];
        BOOL success = [scanner scanDouble:&lon];
        if (success)
            success = [scanner scanDouble:&lat];
        if (success) {
            CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
            if (CLLocationCoordinate2DIsValid(c))
                coords[read++] = c;
        }
        scanner = nil;
    }
    
    *coordsOut = coords;
    *coordsLenOut = read;
}
// KMLPoint does not override createOverlayView: because there is no such
// thing as an overlay view for a point.  They use MKAnnotationViews which
// are vended by the KMLPlacemark class.

@end
