//
//  SearchFlightsVC.h
//  iGuidFC
//
//  Created by dampier on 15/4/14.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPlaceVC.h"
#import "Kal.h"

@interface SearchFlightsVC : UITableViewController<SearchVCDelegate, KalDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UILabel *startPlace;
@property (nonatomic, strong) IBOutlet UILabel *toPlace;
@property (nonatomic, strong) IBOutlet UILabel *tripDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *tripDate;
@property (nonatomic, strong) IBOutlet UILabel *passengerLabel;
@property (nonatomic, strong) IBOutlet UILabel *carbinLabel;
@property (nonatomic, strong) IBOutlet UISwitch *directSwitch;

@property (nonatomic,strong) IBOutlet UIButton *searchBtn;

-(IBAction)skyBtn:(id)sender;

@end
