//
//  SearchPlaceVC.h
//  iGuidFC
//
//  Created by dampier on 15/4/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyUtils.h"
#import "PlaceSkyModel.h"

@protocol SearchVCDelegate <NSObject>

@optional

- (void) selectPlaces:(PlaceSkyModel *) place depart:(BOOL) isDepart;

@end

@interface SearchPlaceVC : UIViewController<SkyQuerayLocationDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property id<SearchVCDelegate> delegate;
@property BOOL isDepart;

-(IBAction)closeAction:(id)sender;

@end
