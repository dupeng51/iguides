//
//  NavigationBar.m
//  SpecialFC
//
//  Created by dampier on 14-4-4.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar
UIImageView* backgroundView;
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundImage:[UIImage imageNamed:@"cloud.jpg" ]];
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [self setBackgroundImage:[UIImage imageNamed:@"cloud.jpg" ]];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            [self setBackgroundColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
        }
    }
    return self;
}

-(void)setBackgroundImage:(UIImage*)image
{
    if(image == nil)
    {
        [backgroundView removeFromSuperview];
    }
    else
    {
        backgroundView = [[UIImageView alloc] initWithImage:image];
        backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
        backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
        backgroundView = nil;
    }
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
