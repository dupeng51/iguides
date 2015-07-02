//
//  POArticle.h
//  AMSlideMenu
//
//  Created by dampier on 14-1-21.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POArticle : NSObject{
    
}
@property NSNumber *primaryid;
@property (nonatomic,retain) NSString *title;
@property (nonatomic) double positionx;
@property (nonatomic) double positiony;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *voice_filetype;
@property (nonatomic,retain) NSString *voice_filename;
@property (nonatomic,retain) NSString *voice_filename1;
@property (nonatomic,retain) NSString *remark;
@property  int orderno;
@property  int line1no;
@property  int line2no;
@property  int line3no;
@property (nonatomic,retain) NSString *imagename;
@property (nonatomic,retain) NSString *link;
@property (nonatomic,retain) NSString *caption;
@property (nonatomic,retain) NSString *picture;

@property NSNumber *spotID;
@property NSNumber *cityID;

@end
