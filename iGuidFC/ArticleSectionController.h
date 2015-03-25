//
//  ArticleSectionController.h
//  AMSlideMenu
//
//  Created by dampier on 14-1-22.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ArticleSectionController : UITableViewController<UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>
{

    
}

@property (copy, nonatomic) NSNumber *masterkeyid;

//用于在tabelview中显示
@property (copy, nonatomic) NSString *articleTitle;

//share fb
@property NSString *link_;
@property NSString *caption_;
@property NSString *picture_;

- (void)playMode:(AVAudioPlayer *) audioPlayer;


@end
