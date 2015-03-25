//
//  FamilyVC.m
//  iGuidFC
//
//  Created by dampier on 14-7-14.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FamilyVC.h"

@interface FamilyVC ()

@end

@implementation FamilyVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openFCAppStore:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-forbidden-city/id856108271";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openFCVideoYoutube:(id)sender
{
    NSString *iTunesLink = @"http://youtu.be/GSdY-wr5tRg";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openFCVideoYouku:(id)sender
{
    NSString *iTunesLink = @"http://v.youku.com/v_show/id_XNzI5NTE1ODMy.html";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openMusicAppStore:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-music/id881391239";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openMusicLite:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-music-lite/id889681784";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openSPAppStore:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-summer-palace/id898181716";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (IBAction)openTHAppStore:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-temple-of-heaven/id923892964";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
- (IBAction)openYuAppStore:(id)sender
{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/iguide-yu-garden/id931802054";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
