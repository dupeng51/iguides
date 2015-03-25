//
//  HomeVC.h
//  AMSlideMenu
//
//  Created by dampier on 14-3-7.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeVC : UITableViewController<MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property IBOutlet UIImageView *img;
@property IBOutlet UIView *playStatusView;
@property IBOutlet UIButton *playStateButon;
@property IBOutlet UIButton *playStateIcon;

- (IBAction)mapClick:(id)sender;
- (IBAction)playModeTap:(id)sender;

- (IBAction)showPlayingMap:(id)sender;

-(void)sendPhoto;

@end
