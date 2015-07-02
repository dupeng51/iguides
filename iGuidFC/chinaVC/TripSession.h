//
//  TripSession.h
//  iGuidFC
//
//  Created by dampier on 15/5/21.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TripDelegation <NSObject>

@optional

- (void)returnData:(id ) data;

@end

@interface TripSession : NSObject

@property id<TripDelegation> delegate;

-(void) getGuiderList:(NSString *) dataString;

@end
