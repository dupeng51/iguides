//
//  Carriers.m
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Carriers.h"


@implementation Carriers

-(void)dealloc {
    _code = nil;
    _displayCode = nil;
    _idString = nil;
    _imageUrl = nil;
    _name = nil;
    
    _image = nil;
}

-(UIImage *) getCarriearImage
{
    if (!self.image) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        self.image = [UIImage imageWithData:data];
    }
    return self.image;
}

@end
