//
//  KMLPlacemark.h
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLGeometry.h"
#import "KMLStyle.h"
#import "KMLPolygon.h"

@interface KMLPlacemark : KMLElement {
    KMLStyle *style;
    KMLGeometry *geometry;
    
    NSString *name;
    NSString *placemarkDescription;
    
    NSString *styleUrl;
    
    MKShape *mkShape;
    
    MKAnnotationView *annotationView;
    MKOverlayPathView *overlayView;
    
    struct {
        int inName:1;
        int inDescription:1;
        int inStyle:1;
        int inGeometry:1;
        int inStyleUrl:1;
    } flags;
}

- (void)beginName;
- (void)endName;

- (void)beginDescription;
- (void)endDescription;

- (void)beginStyleWithIdentifier:(NSString *)ident;
- (void)endStyle;

- (void)beginGeometryOfType:(NSString *)type withIdentifier:(NSString *)ident;
- (void)endGeometry;

- (void)beginStyleUrl;
- (void)endStyleUrl;

// Corresponds to the title property on MKAnnotation
@property (nonatomic, readonly) NSString *name;
// Corresponds to the subtitle property on MKAnnotation
@property (nonatomic, readonly) NSString *placemarkDescription;

@property (nonatomic, readonly) KMLGeometry *geometry;
@property (nonatomic, readonly) KMLPolygon *polygon;

@property (nonatomic, retain) KMLStyle *style;
@property (nonatomic, readonly) NSString *styleUrl;

- (id <MKOverlay>)overlay;
- (id <MKAnnotation>)point;

- (MKOverlayView *)overlayView;
- (MKAnnotationView *)annotationView;
- (NSArray *) coords;

@end
