//
//  POArticle.m
//  AMSlideMenu
//
//  Created by dampier on 14-1-21.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "POArticle.h"

@implementation POArticle

@synthesize primaryid, title, type, voice_filename, voice_filetype, positionx, remark, line1no, line2no, line3no, imagename;

- (void) dealloc
{
    primaryid = nil;
    title = nil;
    type = nil;
    voice_filetype = nil;
    voice_filename = nil;
    _voice_filename1 = nil;
    remark = nil;
    imagename = nil;
    _picture = nil;
    _link = nil;
    _caption = nil;
    
    _spotID = nil;
    _cityID = nil;
}
@end
