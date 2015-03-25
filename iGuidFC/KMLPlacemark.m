//
//  KMLPlacemark.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLPlacemark.h"
#import "KMLPoint.h"
#import "KMLLineString.h"

@implementation KMLPlacemark

@synthesize style, styleUrl, geometry, name, placemarkDescription;

#define ELTYPE(typeName) (NSOrderedSame == [elementName caseInsensitiveCompare:@#typeName])
- (void)dealloc
{
    style = nil;
    geometry = nil;
    name = nil;
    placemarkDescription = nil;
    styleUrl = nil;
    mkShape = nil;
    overlayView = nil;
    annotationView = nil;
//    [super dealloc];
}

- (BOOL)canAddString
{
    return flags.inName || flags.inStyleUrl || flags.inDescription;
}

- (void)addString:(NSString *)str
{
    if (flags.inStyle)
        [style addString:str];
    else if (flags.inGeometry)
        [geometry addString:str];
    else
        [super addString:str];
}

- (void)beginName
{
    flags.inName = YES;
}
- (void)endName
{
    flags.inName = NO;
//    name = nil;
    name = [accum copy];
    [self clearString];
}

- (void)beginDescription
{
    flags.inDescription = YES;
}
- (void)endDescription
{
    flags.inDescription = NO;
    placemarkDescription = [accum copy];
    [self clearString];
}

- (void)beginStyleUrl
{
    flags.inStyleUrl = YES;
}
- (void)endStyleUrl
{
    flags.inStyleUrl = NO;
//    [styleUrl = nil;
    styleUrl = [accum copy];
    [self clearString];
}

- (void)beginStyleWithIdentifier:(NSString *)ident
{
    flags.inStyle = YES;
//    [style = nil;
    style = [[KMLStyle alloc] initWithIdentifier:ident];
}
- (void)endStyle
{
    flags.inStyle = NO;
}

- (void)beginGeometryOfType:(NSString *)elementName withIdentifier:(NSString *)ident
{
    flags.inGeometry = YES;
    if (ELTYPE(Point))
        geometry = [[KMLPoint alloc] initWithIdentifier:ident];
    else if (ELTYPE(Polygon))
        geometry = [[KMLPolygon alloc] initWithIdentifier:ident];
    else if (ELTYPE(LineString))
        geometry = [[KMLLineString alloc] initWithIdentifier:ident];
}
- (void)endGeometry
{
    flags.inGeometry = NO;
}

- (KMLGeometry *)geometry
{
    return geometry;
}

- (KMLPolygon *)polygon
{
    return [geometry isKindOfClass:[KMLPolygon class]] ? (id)geometry : nil;
}

- (void)_createShape
{
    if (!mkShape) {
        mkShape = [geometry mapkitShape];
        mkShape.title = name;
        // Skip setting the subtitle for now because they're frequently
        // too verbose for viewing on in a callout in most kml files.
        //        mkShape.subtitle = placemarkDescription;
    }
}

- (id <MKOverlay>)overlay
{
    [self _createShape];
    
    if ([mkShape conformsToProtocol:@protocol(MKOverlay)])
        return (id <MKOverlay>)mkShape;
    
    return nil;
}

- (id <MKAnnotation>)point
{
    [self _createShape];
    
    // Make sure to check if this is an MKPointAnnotation.  MKOverlays also
    // conform to MKAnnotation, so it isn't sufficient to just check to
    // conformance to MKAnnotation.
    if ([mkShape isKindOfClass:[MKPointAnnotation class]])
        return (id <MKAnnotation>)mkShape;
    
    return nil;
}

- (MKOverlayView *)overlayView
{
    if (!overlayView) {
        id <MKOverlay> overlay = [self overlay];
        if (overlay) {
            overlayView = [geometry createOverlayView:overlay];
            [style applyToOverlayPathView:overlayView];
        }
    }
    return overlayView;
}


- (MKAnnotationView *)annotationView
{
    if (!annotationView) {
        id <MKAnnotation> annotation = [self point];
        if (annotation) {
            MKPinAnnotationView *pin =
            [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            pin.canShowCallout = YES;
            pin.animatesDrop = YES;
            annotationView = pin;
        }
    }
    return annotationView;
}

-(NSArray *) coords
{
    NSString *strPoints = ((KMLPolygon *)geometry).outerRing;
    return [self strsToCoords:strPoints];
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

@end
