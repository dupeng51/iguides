//
//  CreditCardVC.m
//  iGuidFC
//
//  Created by dampier on 15/6/16.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "CreditCardVC.h"
#import "ServiceUtils.h"

@interface CreditCardVC ()

@end

#define PriceCell @"priceCell"
#define CardNoCell @"cardNoCell"
#define NameCell @"nameCell"
#define ExpirationCell @"expirationCell"
#define CvvCell @"cvvCell"
#define IdTypeCell @"idTypeCell"
#define IdnoCell @"idnoCell"
#define DoneCell @"doneCell"

#define idCard @"Chinese Mainland ID Card"
#define passportCard @"Passport"
#define otherIDCard @"Other"

#define PickerHieght 216

@implementation CreditCardVC
{
    BOOL validNo;
    BOOL isNeedCVV;
    BOOL isNameValid;
    
    UITextField *cardNoField;
    UITextField *nameField;
    UILabel *expirationLabel;
    UITextField *cvvField;
    UILabel *idtypeLabel;
    UITextField *idNoField;
    
    NSInteger year;
    NSInteger month;
    NSString *idType;
    BOOL gangAo;
    
    UIButton *popoverView;
    UIPickerView * datePickerView;
    
    NSString * price;
}

- (void)dealloc
{
    cardNoField = nil;
    nameField = nil;
    expirationLabel = nil;
    cvvField = nil;
    idtypeLabel = nil;
    idNoField = nil;
    
    price = nil;
    
    popoverView = nil;
    datePickerView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) initData:(NSString *) priceString isGangAo:(BOOL) isGangAo
{
    validNo = NO;
    isNeedCVV = NO;
    isNameValid = NO;
    year = -1;
    month = -1;
    
    price = priceString;
    
    gangAo = isGangAo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            int i = 3;
            if (isNeedCVV) {
                i++;
            }
            return i;
            break;
        }
        case 2:
        {
            return 2;
            break;
        }
        case 3:
        {
            return 1;
            break;
        }
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:PriceCell];
            UILabel *priceLabel = (UILabel *)[cell viewWithTag:1];
            [priceLabel setText:price];
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CardNoCell];
                    cardNoField = (UITextField *)[cell viewWithTag:1];
                    break;
                }
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:NameCell];
                    nameField = (UITextField *)[cell viewWithTag:1];
                    break;
                }
                case 2:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:ExpirationCell];
                    expirationLabel = (UILabel *)[cell viewWithTag:1];
                    break;
                }
                case 3:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CvvCell];
                    cvvField = (UITextField *)[cell viewWithTag:1];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:IdTypeCell];
                    idtypeLabel = (UILabel *)[cell viewWithTag:1];
                    break;
                }
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:IdnoCell];
                    idNoField = (UITextField *)[cell viewWithTag:1];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:DoneCell];
            break;
        }
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 && indexPath.section == 1) {
        //Expiration Date
        [self showDatePicker:NO];
    }
    if (indexPath.row == 0 && indexPath.section == 2) {
        //ID Type
        [self showIDType];
    }
    if (indexPath.section == 3) {
        //Done
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        if ([textField isEqual:cardNoField]) {
            [nameField becomeFirstResponder];
        } else if ([textField isEqual:nameField]){
            [expirationLabel becomeFirstResponder];
        }
        else if ([textField isEqual:cvvField]){
            [self showIDType];
            [idtypeLabel becomeFirstResponder];
        }
        
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        if ([self checkValidityTextField]) {
            
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:cardNoField]) {
        if (textField.text.length > 0) {
            ELongSession *session = [[ELongSession alloc] init];
            [session setDelegate:self];
            [session creditcardValidate:textField.text];
        }
    }
    if ([textField isEqual:nameField]) {
        if (textField.text.length > 0) {
            NSMutableArray * names = [[NSMutableArray alloc] init];
            [names addObject:nameField.text];
            
            ELongSession *session = [[ELongSession alloc] init];
            [session setDelegate:self];
            [session orderCheckguest:names isGangAo:gangAo];
        }
    }
}

#pragma mark - actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            idType = @"IdentityCard";
            [idtypeLabel setText:idCard];
            break;
        }
        case 1:
        {
            idType = @"Passport";
            [idtypeLabel setText:passportCard];
            break;
        }
        case 2:
        {
            idType = @"Other";
            [idtypeLabel setText:otherIDCard];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Actions

-(IBAction)doneAction:(id)sender
{
    if ([self checkValidityTextField]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:cardNoField.text forKey:@"Number"];
        if (isNeedCVV) {
            [params setValue:cvvField.text forKey:@"CVV"];
        }
        [params setValue:[NSString stringWithFormat:@"%ld", year] forKey:@"ExpirationYear"];
        [params setValue:[NSString stringWithFormat:@"%ld", month] forKey:@"ExpirationMonth"];
        [params setValue:nameField.text forKey:@"HolderName"];
        [params setValue:idType forKey:@"IdType"];
        [params setValue:idNoField.text forKey:@"IdNo"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreditCardSet object:nil userInfo:params];
        [self.navigationController popoverPresentationController];
    }
}

#pragma mark - Elong Delegate

- (void)returnCreditCardValidate:(BOOL) isValidate needCVV:(BOOL) needCVV
{
    validNo = isValidate;
    if (isValidate) {
        [cardNoField setTextColor:[UIColor blackColor]];
        isNeedCVV = needCVV;
        
        [self.tableView reloadData];
    } else {
        [cardNoField setTextColor:[UIColor redColor]];
        [ServiceUtils alart:@"Invalid Card No!"];
        [cardNoField becomeFirstResponder];
    }
}

- (void)returnCheckGuest:(NSArray *) names
{
    for (NSDictionary *dict in names) {
        if (![[dict objectForKey:@"IsValid"] boolValue]) {
            isNameValid = NO;
//            NSString *name = [dict objectForKey:@"Name"];
            [ServiceUtils alart:@"Invalid name."];
            [nameField becomeFirstResponder];
            return;
        }
    }
    isNameValid = YES;
}

#pragma mark - Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        //year
        return  2039 -[ServiceUtils currentYear] +1;
    }
    if (component == 1) {
        //month
        return 12;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld", [ServiceUtils currentYear] + row];
    }
    if (component == 1) {
        return [NSString stringWithFormat:@"%ld", row+1];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        year = [ServiceUtils currentYear] + row;
    }
    if (component == 1) {
        month = row+1;
    }
}

#pragma mark - Inner Method

-(void) showExpirationDate
{
    
}

-(void) showIDType
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:idCard, passportCard, otherIDCard, nil];
    actionSheet.tag = 2;
    
    [actionSheet showInView:self.view];

}

-(BOOL) checkValidityTextField
{
    if (!validNo) {
        [ServiceUtils alart:@"Invalid Card No."];
        [cardNoField becomeFirstResponder];
        return NO;
    } else {
        if (isNeedCVV && cvvField.text.length== 0) {
            [ServiceUtils alart:@"CVV is empty."];
            [cvvField becomeFirstResponder];
            return NO;
        }
    }
    if (cardNoField.text.length == 0) {
        [ServiceUtils alart:@"Credit Card No is empty."];
        [cardNoField becomeFirstResponder];
        return NO;
    }
    if (!isNameValid) {
        [ServiceUtils alart:@"Invalid Name."];
        [nameField becomeFirstResponder];
        return NO;
    }
    if (nameField.text.length == 0) {
        [ServiceUtils alart:@"Name is empty."];
        [nameField becomeFirstResponder];
        return NO;
    }
    if (year == -1 || month == -1) {
        [ServiceUtils alart:@"Expiration Date is empty."];
        [self showDatePicker:NO];
    }
    if (!idType) {
        [ServiceUtils alart:@"ID Type is empty."];
        [self showIDType];
    }
    if (idNoField.text.length == 0) {
        [ServiceUtils alart:@"ID No is empty."];
        [idNoField becomeFirstResponder];
    }
    return YES;
}

- (void) showDatePicker:(BOOL) hidden {
    if (hidden) {
        [UIView beginAnimations:@"datePickerView1" context:nil];
        [popoverView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
        [UIView commitAnimations];
    } else {
        if (!popoverView) {
            CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - PickerHieght, self.view.frame.size.width, PickerHieght);
            datePickerView = [[UIPickerView alloc] initWithFrame:frame];
            [datePickerView setBackgroundColor:[UIColor whiteColor]];
            datePickerView.delegate = self;
            datePickerView.dataSource = self;
            datePickerView.showsSelectionIndicator = YES;
            
            popoverView = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
            [popoverView addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
            popoverView.backgroundColor = [UIColor clearColor];
            
            [popoverView addSubview:datePickerView];
            [self.view addSubview:popoverView];
        }
        
        [UIView beginAnimations:@"datePickerView" context:nil];
        [popoverView setFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
        [UIView commitAnimations];
    }
}

- (void) doneClicked
{
    if (year == -1) {
        year = [ServiceUtils currentYear];
    }
    
    if (month == -1) {
        month = 1;
    }
    [expirationLabel setTextColor:[UIColor blackColor]];
    expirationLabel.text = [NSString stringWithFormat:@"%ld/%ld", month, year];

    [self showDatePicker:YES];
}


@end
