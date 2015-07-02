//
//  RegisterVC.m
//  iGuidFC
//
//  Created by dampier on 15/6/3.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "RegisterVC.h"
#import "UIViewController+AMSlideMenu.h"
#import "Constants.h"
#import "KeychainItemWrapper.h"
#import "ServiceUtils.h"

@interface RegisterVC ()

@end

@implementation RegisterVC
{
    UITextField *emailField;
    UITextField *usernameField;
    UITextField *passwordField1;
    UITextField *passwordField2;
}
- (void)dealloc
{
    emailField = nil;
    usernameField = nil;
    passwordField1 = nil;
    passwordField2 = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.dataSource = self;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 2) {
        return 2;
    }else{
        
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSString *cellIdentifier ;
    if (indexPath.section == 0){
        cellIdentifier = @"emailCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        emailField = (UITextField *)[cell viewWithTag:1];
    }else if (indexPath.section == 1){
        cellIdentifier = @"usernameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        usernameField = (UITextField *)[cell viewWithTag:1];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cellIdentifier = @"passwordCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            passwordField1 = (UITextField *)[cell viewWithTag:1];
            [passwordField1 setReturnKeyType:UIReturnKeyNext];
        }else if (indexPath.row == 1){
            cellIdentifier = @"passwordCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            passwordField2 = (UITextField *)[cell viewWithTag:1];
            [passwordField2 setPlaceholder:@"Confirm Password"];
            [passwordField2 setReturnKeyType:UIReturnKeyGo];
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeyNext) {
        if ([textField isEqual:emailField]) {
            [usernameField becomeFirstResponder];
        } else if ([textField isEqual:usernameField]){
            [passwordField1 becomeFirstResponder];
        }
        else if ([textField isEqual:passwordField1]){
            [passwordField2 becomeFirstResponder];
        }
        
    } else if (textField.returnKeyType==UIReturnKeyGo) {
        if ([self checkValidityTextField]) {
            LocalSession * localsession =[[LocalSession alloc] init];
            [localsession setDelegate:self];
            [localsession postSignupWithName:usernameField.text email:emailField.text password:passwordField1.text];
            
            [self enableFields:NO];
        }
    }

    return YES;
}

#pragma mark - LocalDelegation

- (void)returnSignup:(LocalResultData *) resultData
{
    if (resultData) {
        if ([resultData.code intValue] ==1) {
            //error for user
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:resultData.msg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,
                                  nil];
            [alert show];
            [self enableFields:YES];
        } else if ([resultData.code intValue ] == 0) {
            //save username and password
            [ServiceUtils savePassword:passwordField2.text email:resultData.email];
            
            //login success
            [self.parentViewController dismissViewControllerAnimated:YES completion:^{
                [[self mainSlideMenu] openLeftMenuAnimated:YES];
            }];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:usernameField.text forKey:UserNameKey];
            [params setValue:emailField.text forKey:EmailKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSignUpSuccess object:nil userInfo:params];
        } else if ([resultData.code intValue] == 2) {
            //error for developer
            [self enableFields:YES];
            NSLog(@"%@", resultData.msg);
        }
    } else {
        [self enableFields:YES];
    }
}

#pragma mark - Inner Method
-(void) enableFields:(BOOL) enable
{
    [usernameField setEnabled:enable];
    [emailField setEnabled:enable];
    [passwordField1 setEnabled:enable];
    [passwordField2 setEnabled:enable];
}

- (BOOL)checkValidityTextField
{
    if (emailField.text==nil || emailField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Email is empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    if (usernameField.text==nil || usernameField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"User Name is empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    
    if (passwordField1.text==nil || passwordField1.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Password is empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    if (passwordField2.text==nil || passwordField2.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please input password twice."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
        [alert show];
        return NO;
    }
    if (![passwordField1.text isEqualToString: passwordField2.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Passwords do not match."
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
