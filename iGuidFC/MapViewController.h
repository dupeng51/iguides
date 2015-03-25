//
//  MapViewController.h
//  AMSlideMenu
//
//  Created by dampier on 14-1-18.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
