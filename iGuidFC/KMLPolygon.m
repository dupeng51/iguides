//
//  KMLPolygon.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLPolygon.h"
#import "KMLParser.h"
#import "KMLPoint.h"

@implementation KMLPolygon

- (void)dealloc
{
    outerRing = nil;
    innerRings = nil;
//    [super dealloc];
}

- (BOOL)canAddString
{
    return polyFlags.inLinearRing && flags.inCoords;
}

- (void)beginOuterBoundary
{
    polyFlags.inOuterBoundary = YES;
}
- (void)endOuterBoundary
{
    polyFlags.inOuterBoundary = NO;
    outerRing = [accum copy];
    [self clearString];
}

- (void)beginInnerBoundary
{
    polyFlags.inInnerBoundary = YES;
}
- (void)endInnerBoundary
{
    polyFlags.inInnerBoundary = NO;
    NSString *ring = [accum copy];
    if (!innerRings) {
        innerRings = [[NSMutableArray alloc] init];
    }
    [innerRings addObject:ring];
    ring = nil;
    [self clearString];
}

- (void)beginLinearRing
{
    polyFlags.inLinearRing = YES;
}
- (void)endLinearRing
{
    polyFlags.inLinearRing = NO;
}

- (MKShape *)mapkitShape
{
    // KMLPolygon corresponds to MKPolygon
    
    // The inner and outer rings of the polygon are stored as kml coordinate
    // list strings until we're asked for mapkitShape.  Only once we're here
    // do we lazily transform them into CLLocationCoordinate2D arrays.
    
    // First build up a list of MKPolygon cutouts for the interior rings.
    NSMutableArray *innerPolys = nil;
    if (innerRings) {
        innerPolys = [[NSMutableArray alloc] initWithCapacity:[innerPolys count]];
        for (NSString *coordStr in innerRings) {
            CLLocationCoordinate2D *coords = NULL;
            NSUInteger coordsLen = 0;
            strToCoords(coordStr, &coords, &coordsLen);
            [innerPolys addObject:[MKPolygon polygonWithCoordinates:coords count:coordsLen]];
            free(coords);
        }
    }
    // Now parse the outer ring.
    CLLocationCoordinate2D *coords = NULL;
    NSUInteger coordsLen = 0;
    strToCoords(outerRing, &coords, &coordsLen);
    
    // Build a polygon using both the outer coordinates and the list (if applicable)
    // of interior polygons parsed.
    MKPolygon *poly = [MKPolygon polygonWithCoordinates:coords count:coordsLen interiorPolygons:innerPolys];
    free(coords);
    innerPolys = nil;
    return poly;
}

- (MKOverlayPathView *)createOverlayView:(MKShape *)shape
{
    // KMLPolygon corresponds to MKPolygonView
    
    MKPolygonView *polyView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon *)shape];
    return polyView;
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

- (NSString *) outerRing
{
    return outerRing;
}

// Convert a KML coordinate list string to a C array of CLLocationCoordinate2Ds.
// KML coordinate lists are longitude,latitude[,altitude] tuples specified by whitespace.
- (NSArray *) strsToCoords:(NSString *)str
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    NSArray *tuples = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString *tuple in tuples) {
        double lat, lon;
        NSScanner *scanner = [[NSScanner alloc] initWithString:tuple];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@","]];
        BOOL success = [scanner scanDouble:&lon];
        if (success)
            success = [scanner scanDouble:&lat];
        if (success) {
            KMLPoint *point = [[KMLPoint alloc] init];
            point.point = CLLocationCoordinate2DMake(lat, lon);
            [points addObject:point];
        }
        scanner = nil;
    }
    return points;
}

- (bool) pointinPolygon:(CLLocationCoordinate2D) p
{
    bool result = false;
    NSArray *points = [self strsToCoords:outerRing];
    for (int i = 0; i < points.count - 1; i++) {
        CLLocationCoordinate2D point = ((KMLPoint *)points[ i ]).point;
        CLLocationCoordinate2D point1 = ((KMLPoint *)points[ i + 1 ]).point;
        if( ( ( ( point1.latitude <= p.latitude ) && ( p.latitude < point.latitude ) ) || ( ( point.latitude <= p.latitude ) && ( p.latitude < point1.latitude ) ) ) && ( p.longitude < ( point.longitude - point1.longitude ) * ( p.latitude - point1.latitude ) / ( point.latitude - point1.latitude ) + point1.longitude ) )
        {
            result = !result;
        }
    }
    
//    for( int i = 0; i < points.Length - 1; i++ )
//    {
//        if( ( ( ( points[ i + 1 ].Y <= p.Y ) && ( p.Y < points[ i ].Y ) ) || ( ( points[ i ].Y <= p.Y ) && ( p.Y < points[ i + 1 ].Y ) ) ) && ( p.X < ( points[ i ].X - points[ i + 1 ].X ) * ( p.Y - points[ i + 1 ].Y ) / ( points[ i ].Y - points[ i + 1 ].Y ) + points[ i + 1 ].X ) )
//        {
//            result = !result;
//        }
//    }
    return result;
}

@end
