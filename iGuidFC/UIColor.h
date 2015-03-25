//
//  UIColor.h
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (KMLExtras)

// Parse a KML string based color into a UIColor.  KML colors are agbr hex encoded.
+ (UIColor *)colorWithKMLString:(NSString *)kmlColorString;

@end
