//
//  SegmentedVC.m
//  SpecialFC
//
//  Created by dampier on 14-3-15.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "SegmentedVC.h"

@implementation SegmentedVC

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //兼容IOS6
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                        [UIColor whiteColor], UITextAttributeTextColor, 0, UITextAttributeTextShadowOffset, nil];
            [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
            NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
            [self setTintColor:RGB(172, 49, 22)];
        }

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
