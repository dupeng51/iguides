//
//  ArticleController.h
//  AMSlideMenu
//
//  Created by dampier on 14-1-20.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleSectionController.h"

@interface ArticleController : UITableViewController

@property (strong, nonatomic) ArticleSectionController *childController;

- (void) initData:(NSString *) TableType;

@end
