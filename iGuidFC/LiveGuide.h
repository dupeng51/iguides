//
//  LiveGuide.h
//  iGuidFC
//
//  Created by dampier on 14-8-20.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface LiveGuide : UITableViewController <MFMailComposeViewControllerDelegate>

-(IBAction)facebookToDavid:(id)sender;
-(IBAction)emailToDavid:(id)sender;


@end
