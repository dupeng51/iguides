//
//  Agents.h
//  iGuidFC
//
//  Created by dampier on 15/4/15.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agents : NSObject

@property (nonatomic, retain) NSString * bookingNumber;
@property (nonatomic, retain) NSNumber * idString;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * optimisedForMobile;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;


-(UIImage *) getAgentImage;

@end
