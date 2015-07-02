//
//  LoginVC.m
//  iGuidFC
//
//  Created by dampier on 15/6/2.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "LoginVC.h"
#import "UIViewController+AMSlideMenu.h"
#import "Constants.h"
#import "RegisterVC.h"
#import "ServiceUtils.h"

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithTitle:@"Signup" style:UIBarButtonItemStylePlain target:self action:@selector(signupAction:)];
    self.navigationItem.rightBarButtonItem = signupButton;
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext) {
        [self.passwordField becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyGo) {
        if ([self checkValidityTextField]) {
            LocalSession *localSession = [[LocalSession alloc] init];
            [localSession setDelegate:self];
            [localSession postSigninWithEmail:self.emailField.text password:self.passwordField.text];
            [self enableFields:NO];
        }
        
    }
    return YES;
}

#pragma mark - LocalDelegation

- (void)returnLogin:(LocalResultData *) resultData
{
    if (resultData) {
        if (resultData.code.intValue == 1) {
            //fail to login
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:resultData.msg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,
                                  nil];
            [alert show];
            [self enableFields:YES];
        } else if (resultData.code.intValue == 0) {
            //login success
            [ServiceUtils savePassword:self.passwordField.text email:resultData.email];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:resultData.username forKey:UserNameKey];
            [params setValue:resultData.email forKey:EmailKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSignInSuccess object:nil userInfo:params];
            [self closeAction:nil];
        } else if (resultData.code.intValue == 2) {
            NSLog(@"%@", resultData.msg);
            [self enableFields:YES];
        }
    }
}

#pragma mark - Action

- (void) closeAction:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[self mainSlideMenu] openLeftMenuAnimated:YES];
    }];
}

- (void) signupAction:(id) sender
{
    RegisterVC * registerVC = [self.storyboard instantiateViewControllerWithIdentifier:IdentifierRegisterVC];
    [self.navigationController pushViewController: registerVC animated:true];
}

#pragma mark - Inner Method

-(void) enableFields:(BOOL) enable
{
    [self.emailField setEnabled:enable];
    [self.passwordField setEnabled:enable];
}

- (BOOL)checkValidityTextField
{
    if (self.emailField.text==nil || self.emailField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Email is empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    if (self.passwordField.text==nil || self.passwordField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Password is empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }

    return YES;
}

@end
