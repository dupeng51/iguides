//
//  Constants.m
//  iGuidFC
//
//  Created by dampier on 15/6/3.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const LocalURL = @"http://tripeekaboo.com/";
NSString * const LocalURLPath = @"elong/hotelAPI.php";

NSString * const DomesticURL = @"http://dupeng.gotoip3.com";
NSString * const DomesticURLPath = @"elong/hotelAPI.php";

//NSString * const DomesticURL = @"http://42.96.207.121";
//NSString * const DomesticURLPath = @"hotelAPI.php";

NSString * const TestURL = @"http://192.168.1.103";
NSString * const SignupPath = @"elong/process_signup.php";
NSString * const SigninPath = @"elong/process_login.php";
NSString * const SignoutPath = @"elong/logout.php";

NSString * const NotificationSignInSuccess = @"NotificationSignInSuccess";
NSString * const NotificationSignUpSuccess = @"NotificationSignUpSuccess";
NSString * const NotificationCreditCardSet = @"NotificationCreditCardSet";

NSString * const IdentifierRegisterVC = @"RegisterVC";
NSString * const IdentifierCreditCardVC = @"CreditCardVC";

NSString * const IdentifierKeychain = @"iGuideChinaKeychainIdentifier";

NSString * const EmailKey = @"emailkey";
NSString * const UserNameKey= @"usernamekey";

NSString * const StoryBoardIDUserProfile = @"userInfoRow";

NSString * const ELongURL = @"http://api.elong.com";
NSString * const ELongURLPath = @"rest";
NSString * const user1 = @"d701f15be3a8ec996ced6d06fad2d91f";
NSString * const appKey1 = @"65c495a0c78500e308413fbece9c331f";
NSString * const secretKey1 = @"ea4013051ec2f3b150d9e2a6c86c5f98";
NSString * const hotelDetailURL = @"http://api.elong.com/xml/v2.0/hotel/en";

NSString * const ELMethodOrderCreate = @"hotel.order.create";
NSString * const ELMethodCommonCreditcardValidate = @"common.creditcard.validate";

@end
