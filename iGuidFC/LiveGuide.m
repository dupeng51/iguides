//
//  LiveGuide.m
//  iGuidFC
//
//  Created by dampier on 14-8-20.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "LiveGuide.h"
#import "POArticle.h"
#import "DaoArticle.h"
#import "ArticleController.h"

@implementation LiveGuide

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        ArticleSectionController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
        
        POArticle *poa = [[[DaoArticle alloc] getAllDavid] objectAtIndex:0];
        
        childController.title = @"About David Dou";
        
        //SEL selector;
        childController.masterkeyid = poa.primaryid;
        [self.navigationController pushViewController: childController animated:(true)];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    }
}

-(IBAction)facebookToDavid:(id)sender
{
    [LiveGuide openUrl:@"https://www.facebook.com/david.dou.90"];
}

+(void) openUrlInBrowser:(NSString *) url
{
    if (url.length > 0) {
        NSURL *linkUrl = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:linkUrl];
    }
}
+(void) openUrl:(NSString *) urlString
{
    
    //check if facebook app exists
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        
        // Facebook app installed
        NSArray *tokens = [urlString componentsSeparatedByString:@"/"];
        NSString *profileName = [tokens lastObject];
        
        //call graph api
        NSURL *apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@",profileName]];
        NSData *apiResponse = [NSData dataWithContentsOfURL:apiUrl];
        
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:apiResponse options:NSJSONReadingMutableContainers error:&error];
        
        //check for parse error
        if (error == nil) {
            
            NSString *profileId = [jsonDict objectForKey:@"id"];
            
            if (profileId.length > 0) {//make sure id key is actually available
                NSURL *fbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",profileId]];
                [[UIApplication sharedApplication] openURL:fbUrl];
            }
            else{
                [LiveGuide openUrlInBrowser:urlString];
            }
            
        }
        else{//parse error occured
            [LiveGuide openUrlInBrowser:urlString];
        }
        
    }
    else{//facebook app not installed
        [LiveGuide openUrlInBrowser:urlString];
    }
}

-(IBAction)emailToDavid:(id)sender
{
    NSString *emailTitle = @"Booking from **";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"daviddoutour@hotmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc) {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alart"
        //                                                        message:@"You havn't login your Email, please add your email accounts in Settings."
        //                                                       delegate:self
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
        NSLog(@"User havn't login your Email");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
