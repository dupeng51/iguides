//
//  FCMapInfoWindow.h
//  AMSlideMenu
//
//  Created by dampier on 14-2-22.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POArticle.h"

@interface FCMapInfoWindow : UIView<UIActionSheetDelegate>

- (id)initWithFrame:(CGRect)frame shop:(POArticle *) shop VC:(UIViewController *) vc;


@property IBOutlet UILabel *Title;
@property IBOutlet UILabel *Remark;
@property IBOutlet UIImageView *image;


@end
