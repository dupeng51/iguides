//
//  HotelDetailVC.h
//  iGuidFC
//
//  Created by dampier on 15/5/22.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELongSession.h"

@interface HotelDetailVC : UIViewController<ELongDelegation, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView* tableView;

-(void) initData:(NSString *) hotelID arrivalDate:(NSDate *) arrivalDate departureDate:(NSDate *)departureDate;

@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end