//
//  KMLStyle.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLStyle.h"
#import "UIColor.h"

@implementation KMLStyle

- (BOOL)canAddString
{
    return flags.inColor || flags.inWidth || flags.inFill || flags.inOutline;
}

- (void)beginLineStyle
{
    flags.inLineStyle = YES;
}
- (void)endLineStyle
{
    flags.inLineStyle = NO;
}

- (void)beginPolyStyle
{
    flags.inPolyStyle = YES;
}
- (void)endPolyStyle
{
    flags.inPolyStyle = NO;
}

- (void)beginColor
{
    flags.inColor = YES;
}
- (void)endColor
{
    flags.inColor = NO;
    
    if (flags.inLineStyle) {
        strokeColor = [UIColor colorWithKMLString:accum];
    } else if (flags.inPolyStyle) {
        fillColor = [UIColor colorWithKMLString:accum];
    }
    
    [self clearString];
}

- (void)beginWidth
{
    flags.inWidth = YES;
}
- (void)endWidth
{
    flags.inWidth = NO;
    strokeWidth = [accum floatValue];
    [self clearString];
}

- (void)beginFill
{
    flags.inFill = YES;
}
- (void)endFill
{
    flags.inFill = NO;
    fill = [accum boolValue];
    [self clearString];
}

- (void)beginOutline
{
    flags.inOutline = YES;
}
- (void)endOutline
{
    stroke = [accum boolValue];
    [self clearString];
}

- (void)applyToOverlayPathView:(MKOverlayPathView *)view
{
    view.strokeColor = strokeColor;
    view.fillColor = fillColor;
    view.lineWidth = strokeWidth;
}

@end