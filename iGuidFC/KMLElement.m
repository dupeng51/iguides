//
//  KMLElement.m
//  KMLViewer
//
//  Created by dampier on 14-5-6.
//
//

#import "KMLElement.h"

@implementation KMLElement

@synthesize identifier;

- (id)initWithIdentifier:(NSString *)ident
{
    if (self = [super init]) {
        identifier = ident;
    }
    return self;
}

- (void)dealloc
{
    identifier = nil;
    accum = nil;
}

- (BOOL)canAddString
{
    return NO;
}

- (void)addString:(NSString *)str
{
    if ([self canAddString]) {
        if (!accum)
            accum = [[NSMutableString alloc] init];
        [accum appendString:str];
    }
}

- (void)clearString
{
    accum = nil;
    accum = nil;
}

@end
