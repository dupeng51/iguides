//
//  ChinaThingVC.h
//  SpecialFC
//
//  Created by dampier on 14-3-19.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleSectionController.h"

@interface ChinaThingVC : UITableViewController

@property (strong, nonatomic) ArticleSectionController *childController;
//- (void) initData:(NSString *) TableType;
@end
