//
//  CreditCardVC.h
//  iGuidFC
//
//  Created by dampier on 15/6/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELongSession.h"

@interface CreditCardVC : UITableViewController<UITextFieldDelegate, ELongDelegation, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>

- (IBAction) doneAction:(id)sender;

- (void) initData:(NSString *) priceString isGangAo:(BOOL) isGangAo;

@end
