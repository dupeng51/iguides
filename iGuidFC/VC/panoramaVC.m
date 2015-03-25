//
//  panoramaVC.m
//  SpecialFC
//
//  Created by dampier on 14-4-2.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "panoramaVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface panoramaVC ()

@end

@implementation panoramaVC

GMSPanoramaView *panoView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    panoView_.delegate = self;
    self.view = panoView_;
    
    [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake(39.913758, 116.397276)];
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



- (void) panoramaView:(GMSPanoramaView *) view didMoveToPanorama:(GMSPanorama *) panorama
{
    if (panorama) {
        NSLog(panorama.panoramaID);
    }
}

- (void) panoramaView:(GMSPanoramaView *) view error:(NSError *) error onMoveNearCoordinate:		(CLLocationCoordinate2D) coordinate
{
    if (error) {
        NSLog(error);
    }
}

@end
