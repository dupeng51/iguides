//
//  LeftMenuVC.m
//  AMSlideMenu
//
//  Created by Artur Mkrtchyan on 12/24/13.
//  Copyright (c) 2013 Artur Mkrtchyan. All rights reserved.
//

#import "LeftMenuVC.h"
#import "Constants.h"
#import "KeychainItemWrapper.h"
#import "LocalSession.h"
#import "ServiceUtils.h"

@implementation LeftMenuVC
{
    KeychainItemWrapper *keychainItem;
}

- (void)dealloc
{
    keychainItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLogin:) name:NotificationSignInSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLogin:) name:NotificationSignUpSuccess object:nil];
    
    [self.userImage setBackgroundColor:[UIColor whiteColor]];
    [self.userImage.layer setCornerRadius:30];
    [self.userImage setClipsToBounds:YES];
    
    //get login info
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:IdentifierKeychain accessGroup:nil];
    NSString *email = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSData *passData = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *pass = [[NSString alloc] initWithBytes:[passData bytes] length:[passData length] encoding:NSUTF8StringEncoding];
    //login
    if (email && pass && email.length > 0 && pass.length > 0) {
        LocalSession *localSession = [[LocalSession alloc] init];
        [localSession setDelegate:self];
        [localSession postSigninWithEmail:email password:pass];
    }
    
}

- (void)returnLogin:(LocalResultData *) resultData
{
    if (resultData) {
        if (resultData.code.intValue == 1) {
            //fail to login
            NSLog(@"Auto login failed!");
            [ServiceUtils removePassword];
        } else if (resultData.code.intValue == 0) {
            //login success
            [self.userBtn setTitle:resultData.username forState:UIControlStateNormal];
            
        } else if (resultData.code.intValue == 2) {
            NSLog(@"%@", resultData.msg);
        }
    }
}



-(void) setLogin:(NSNotification *) params
{
    NSString *username = [params.userInfo objectForKey:UserNameKey];
    [self.userBtn setTitle:username forState:UIControlStateNormal];
}

- (IBAction) userAction:(id)sender
{
    if ([LocalSession userName] && [LocalSession userName].length > 0) {
        NSString *segueIdentifier = StoryBoardIDUserProfile;
        if (segueIdentifier && segueIdentifier.length > 0)
        {
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }
    } else {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginID"];
        [self showDetailViewController:viewController sender:self];
    }
    
}

@end
