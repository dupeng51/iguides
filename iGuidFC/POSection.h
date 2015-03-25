//
//  POSection.h
//  AMSlideMenu
//
//  Created by dampier on 14-1-22.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSection : NSObject

@property (nonatomic,retain) NSNumber *primaryid;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *textcontent;
@property (nonatomic,retain) UIImage *imagecontent;
@property double positionx;
@property double positiony;
@property (nonatomic,retain) NSString *imagename;
@property (nonatomic) NSInteger orderno;
@property (nonatomic, retain) NSNumber *starttime;
@property (nonatomic, retain) NSNumber *endtime;
@property (nonatomic, retain) NSNumber *starttime1;
@property (nonatomic, retain) NSNumber *endtime1;
@end
