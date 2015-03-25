//
//  KMLLineString.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLLineString.h"

@implementation KMLLineString

@synthesize points, length;

- (void)dealloc
{
    if (points)
        free(points);
//    [super dealloc];
}

- (void)endCoordinates
{
    flags.inCoords = NO;
    
    if (points)
        free(points);
    
    strToCoords(accum, &points, &length);
    
    [self clearString];
}

- (MKShape *)mapkitShape
{
    // KMLLineString corresponds to MKPolyline
    return [MKPolyline polylineWithCoordinates:points count:length];
}

- (MKOverlayPathView *)createOverlayView:(MKShape *)shape
{
    // KMLLineString corresponds to MKPolylineView
    MKPolylineView *lineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)shape];
    return lineView;
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
        scanner  = nil;
    }
    
    *coordsOut = coords;
    *coordsLenOut = read;
}

@end
