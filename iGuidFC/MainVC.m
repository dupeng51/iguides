//
//  MainVC.m
//  AMSlideMenu
//
//  Created by Artur Mkrtchyan on 12/24/13.
//  Copyright (c) 2013 Artur Mkrtchyan. All rights reserved.
//

#import "MainVC.h"
#import "Constants.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    view.backgroundColor = [UIColor purpleColor];
//    [self fixStatusBarWithView:view];
}

/*----------------------------------------------------*/
#pragma mark - Overriden Methods -
/*----------------------------------------------------*/

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"firstRow";
    //forbidden city's menu
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"secondRow";
            break;
        case 2:
            identifier = @"smartRow";
            break;
        case 3:
            identifier = @"musicRow";
            break;
        case 4:
            identifier = @"liveGuideRow";
            break;
        case 5:
            identifier = @"familyRow";
            break;
        case 6:
            identifier = @"settingsRow";
            break;
    }
#ifdef TH
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"secondRow";
            break;
        case 2:
            identifier = @"smartRow";
            break;
        case 3:
            identifier = @"musicRow";
            break;
        case 4:
            identifier = @"liveGuideRow";
            break;
        case 5:
            identifier = @"shopsRow";
            break;
        case 6:
            identifier = @"familyRow";
            break;
        case 7:
            identifier = @"settingsRow";
            break;
    }
#endif
    
#ifdef China
    switch (indexPath.row) {
        case 1:
            identifier = @"firstRow";
            break;
        case 2:
            identifier = @"secondRow";
            break;
        case 3:
            identifier = @"ThirdRow";
            break;
        case 4:
            identifier = @"ForthRow";
            break;
        case 5:
            identifier = @"FifthRow";
            break;
        case 6:
            identifier = @"LimosRow";
            break;
        case 7:
            identifier = @"sevenRow";
            break;
    }
#endif
    
    return identifier;
}

- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRow";
            break;
        case 1:
            identifier = @"secondRow";
            break;
        case 2:
            identifier = @"thirdRow";
            break;
        case 3:
            identifier = @"fourthRow";
            break;
        case 4:
            identifier = @"fifthRow";
            break;
        case 5:
            identifier = @"sixRow";
            break;
    }
    
    return identifier;
}

- (CGFloat)leftMenuWidth
{
    int menuWidth = 250;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Some code for iPhone
        menuWidth = 250;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Some code for iPad
        menuWidth = self.view.frame.size.width - 200;
    }
    return menuWidth;
}

- (CGFloat)rightMenuWidth
{
    int menuWidth = 250;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Some code for iPhone
        menuWidth = 250;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Some code for iPad
        menuWidth = self.view.frame.size.width - 200;
    }
    return menuWidth;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
}

- (AMPrimaryMenu)primaryMenu
{
    return AMPrimaryMenuLeft;
}


// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

// Enabling Deepnes on left menu
- (BOOL)deepnessForRightMenu
{
    return YES;
}

@end
