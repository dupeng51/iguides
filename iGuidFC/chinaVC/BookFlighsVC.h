//
//  BookFlighsVC.h
//  iGuidFC
//
//  Created by dampier on 15/4/23.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "SkySession.h"

@interface BookFlighsVC : UITableViewController<SkySessionDelegation, BookDelegation, UIActionSheetDelegate>

@property (retain, strong) NSArray *priceOtions;

-(void) initData:(Itinerary *) outItinerary inItinerary:(Itinerary *) inItinerary session:(SkySession *) session params:(NSDictionary *) params;

@end
