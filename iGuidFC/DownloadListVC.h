//
//  DownloadListVCTableViewController.h
//  iGuidFC
//
//  Created by dampier on 15/3/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DOWNLOADSTATUS_NULL = 0,
    DOWNLOADSTATUS_DOWNLOADING,
    DOWNLOADSTATUS_COMPLETED
} DownloadStatus;

@interface DownloadListVC : UITableViewController

-(void) addSpotToDownload:(int) spotid;
+(NSString *) directoryWithSpotID:(NSString *) spotid;

-(IBAction)downloadAction:(id)sender;

+(NSArray *) getBackgroundPaths:(NSString *) spotid;

@end
