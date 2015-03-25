//
//  ArticleSectionController.m
//  AMSlideMenu
//
//  Created by dampier on 14-1-22.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "ArticleSectionController.h"
#import "AppDelegate.h"
#import "POSection.h"
#import "FCMapController.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FCSettingVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "ShopCardVC.h"


@interface ArticleSectionController ()

@end

@implementation ArticleSectionController
{
    FCMapController *mapController;
    //播放模式，如果为yes，则动态滚动显示内容
    BOOL isPlayMode;
    AVAudioPlayer * _audioPlayer;
    NSTimer *_timer;
    //当前播放行号
    int index;
    int oldIndex;
    UIImage *mainImage;
    UIBarButtonItem *_shareButton;
    UIBarButtonItem *_mapButton;
    SLComposeViewController *slComposerSheet;
    NSArray * articles;
    //缓存Cell
    NSMutableDictionary *_cellCache;
    int CELL_CONTENT_WIDTH;
    MPMoviePlayerViewController *moviePlayer;
}
@synthesize masterkeyid, articleTitle, link_, caption_, picture_;
#define imageIdentifier  @"image"
#define textIdentifier  @"text"
#define positionIdentifier  @"position"
#define titleIdentifier  @"title"
#define relatedIdentifier  @"related"
#define videoIdentifier  @"video"
#define photoIdentifier  @"photos"
#define phoneIdentifier  @"phone"
#define emailIdentifier  @"email"
#define discountIdentifier  @"discount"

#define KeyVoiceType @"voicetype"

#define TITLEFONT_SIZE 17.0f
#define FONT_SIZE 16.0f
#define CELL_CONTENT_MARGIN 10.0f
#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

#define TableTypeFC   @"fc"
#define Description @"iGuid, make your travel smart"


#pragma mark - LifeCycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}


- (void) dealloc
{
    mapController = nil;
    masterkeyid = nil;
    articles = nil;
    _cellCache = nil;
    _timer = nil;
    _audioPlayer = nil;
    _shareButton = nil;
    slComposerSheet = nil;
    articleTitle = nil;
    link_= nil;
    caption_= nil;
    picture_ = nil;
    mainImage = nil;
    moviePlayer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    //设置监控 每秒刷新一次时间
    if (isPlayMode) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
        }
//        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [_timer setFireDate:[NSDate distantFuture]];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取缓存的Cell
    UITableViewCell *cell = [self getCellFromIndexPath:indexPath tableview:tableView];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
- (UITableViewCell *)getCellFromIndexPath:(NSIndexPath*)indexPath tableview:(UITableView *) tableView
{
    int row = indexPath.row;
//    UITableViewCell *cachedCell = [_cellCache objectForKey:@(row)];
//    if (cachedCell)
//    {
//        return cachedCell;
//    }
    
    UITableViewCell *cell;
    
    POSection *articleSection = articles[row];
    if ([articleSection.type isEqualToString:imageIdentifier]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:imageIdentifier];
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
        if (!mainImage) {
            mainImage = [UIImage imageNamed:articleSection.imagename];
        }
//        CGFloat height = CELL_CONTENT_WIDTH * mainImage.size.height /mainImage.size.width;
//        [imageview setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, height)];
//        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        imageview.image = [UIImage imageNamed:articleSection.imagename];
        
    }
    if ([articleSection.type isEqualToString:textIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:textIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        
//        textview.font = [UIFont systemFontOfSize:FONT_SIZE];
//        [textview sizeToFit];
        
        [textview setLineBreakMode: UILineBreakModeWordWrap];
        [textview setMinimumFontSize:FONT_SIZE];
        [textview setNumberOfLines:0];
        [textview setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//        [textview setTag:1];
        
//        [[textview layer] setBorderWidth:2.0f];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSString *text = articleSection.textcontent;
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [textview setText: text];
        [textview setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height+ (CELL_CONTENT_MARGIN * 2), 33.0f))];
        [textview sizeToFit];
    }
    if ([articleSection.type isEqualToString:positionIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:positionIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        textview.text = articleSection.textcontent;
    }
    if ([articleSection.type isEqualToString:videoIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
        UILabel *videoLabel = (UILabel *)[cell viewWithTag:1];
        [videoLabel setText:articleSection.textcontent];
    }
    if ([articleSection.type isEqualToString:titleIdentifier]) {
        cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        
        [textview setLineBreakMode: UILineBreakModeWordWrap];
        [textview setMinimumFontSize:TITLEFONT_SIZE];
        [textview setNumberOfLines:0];
        [textview setFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE]];
//        [textview setTextColor:[UIColor whiteColor]];
        //        [textview setTag:1];
        
        //        [[textview layer] setBorderWidth:2.0f];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSString *text;
        if (articleSection.textcontent) {
            text = articleSection.textcontent;
        } else {
            text = articleTitle;
        };
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [textview setText: text];
        [textview setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height+ (CELL_CONTENT_MARGIN * 2), 33.0f))];
        [textview sizeToFit];
        
        //添加渐变色
        CAGradientLayer *gradient = [CAGradientLayer layer];
        float ft = MAX(size.height+ (CELL_CONTENT_MARGIN * 2), 33.0f);
        [gradient setFrame: CGRectMake(0, 0, self.view.bounds.size.width, ft)];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)RGB(236, 98, 51).CGColor,
                           (id)RGB(128, 0, 0).CGColor,
                           nil];

        UIView *tableBackgroundView = [[UIView alloc] init];
        [tableBackgroundView.layer insertSublayer:gradient atIndex:0];
        [cell setBackgroundView:tableBackgroundView];
        
//        if (cell.layer.sublayers.count <= 2) {
//            [cell.layer insertSublayer:gradient atIndex:0];
//            NSLog([NSString stringWithFormat:@"%@ %d", text, cell.layer.sublayers.count]);
//        }
    }
    if ([articleSection.type isEqualToString:relatedIdentifier]) {
        cell = [tableView dequeueReusableCellWithIdentifier:relatedIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        
        [textview setLineBreakMode: UILineBreakModeWordWrap];
        [textview setMinimumFontSize:TITLEFONT_SIZE];
        [textview setNumberOfLines:0];
        [textview setFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE]];
//        [textview setTextColor:[UIColor whiteColor]];
        //        [textview setTag:1];
        
        //        [[textview layer] setBorderWidth:2.0f];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSString *text;
        if (articleSection.textcontent) {
            text = articleSection.textcontent;
        };
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [textview setText: text];
        [textview setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 3), MAX(size.height+ (CELL_CONTENT_MARGIN * 2), 33.0f))];
        [textview sizeToFit];
    }
    if ([articleSection.type isEqualToString:phoneIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:phoneIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        textview.text = articleSection.textcontent;
    }
    if ([articleSection.type isEqualToString:emailIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:emailIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        textview.text = articleSection.textcontent;
    }
    if ([articleSection.type isEqualToString:photoIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:photoIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        textview.text = articleSection.textcontent;
    }
    if ([articleSection.type isEqualToString:discountIdentifier]){
        cell = [tableView dequeueReusableCellWithIdentifier:discountIdentifier];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        textview.text = articleSection.textcontent;
    }
    //缓存Cell
//    [_cellCache setObject:cell forKey:@(row)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    POSection *articleSection = articles[row];
    CGSize size;
    
    if ([articleSection.type isEqualToString:textIdentifier]) {
//        POSection *articleSection = [articles objectAtIndex:[indexPath row]];
        NSString *text = articleSection.textcontent;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = size.height + (CELL_CONTENT_MARGIN * 2);
        
        text = nil;
        return MAX(height, 33.0f);
    }
    if ([articleSection.type isEqualToString:imageIdentifier]) {
        POSection *articleSection = [articles objectAtIndex:[indexPath row]];
        UIImage *image = [UIImage imageNamed:articleSection.imagename];
        
        CGFloat height = CELL_CONTENT_WIDTH * image.size.height /image.size.width;
        
        image = nil;
        articleSection = nil;
        return height;
    }
    if ([articleSection.type isEqualToString:positionIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:positionIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:videoIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:photoIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:phoneIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:emailIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:videoIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:discountIdentifier]) {
        UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:discountIdentifier];
        return tableViewCell.frame.size.height;
    }
    if ([articleSection.type isEqualToString:titleIdentifier]) {
        NSString *text;
        if (articleSection.textcontent) {
            text = articleSection.textcontent;
        } else {
            text = articleTitle;
        };
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = size.height + (CELL_CONTENT_MARGIN * 2);
        
        text = nil;
        return MAX(height, 33.0f);
    }
    if ([articleSection.type isEqualToString:relatedIdentifier]) {
        NSString *text;
        if (articleSection.textcontent) {
            text = articleSection.textcontent;
        };
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 3), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = size.height + (CELL_CONTENT_MARGIN * 2);
        
        text = nil;
        return MAX(height, 33.0f);
    }

    
    articleSection = nil;
    
    // 這裏返回需要的高度
    return size.height;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POSection *poa = articles[indexPath.row];
    
    if ([poa.type isEqualToString:positionIdentifier]) {
//        if (!mapController) {
//            mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
//        }
//        mapController.x = poa.positionx;
//        mapController.y = poa.positiony;
        
//        [self.navigationController pushViewController: mapController animated:(true)];
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=donghuamen&center=%f,%f", poa.positionx, poa.positiony]]];
        } else {
            NSString *path = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", poa.positionx, poa.positiony];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
        }
//        } else {
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                 message:@"Sorry, you haven't installed Google Map"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"OK"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//
//                 NSLog(@"Can't use comgooglemaps://");
//        }
    }
    if ([poa.type isEqualToString:relatedIdentifier]) {
        ArticleSectionController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
        DaoArticle *dao = [DaoArticle alloc];
        NSArray *section = [dao getArticleByID:poa.imagename];
        POArticle * relatedPO = [section objectAtIndex:0];
        
        childController.title = @"Mysteries Article";
        childController.articleTitle = relatedPO.title;
        childController.link_ = relatedPO.link;
        childController.picture_ = relatedPO.picture;
        childController.caption_ = relatedPO.caption;
        
        //SEL selector;
        childController.masterkeyid = relatedPO.primaryid;
        [self.navigationController pushViewController: childController animated:(true)];
    }
    
    if ([poa.type isEqualToString:videoIdentifier]) {
        NSString *filepath   =   [[NSBundle mainBundle] pathForResource:poa.imagename ofType:nil];
        NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
//        moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
        MPMoviePlayerViewController *moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
        moviePlayerView.moviePlayer.view.transform = CGAffineTransformConcat(moviePlayerView.moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
        moviePlayerView.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:moviePlayerView animated:YES completion:^{}];
    }
    if ([poa.type isEqualToString:emailIdentifier]) {
        [self showEmail:poa.textcontent];
    }
    
    if ([poa.type isEqualToString:phoneIdentifier]) {
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", poa.textcontent]]];
        }
    }
    if ([poa.type isEqualToString:discountIdentifier]) {
        ShopCardVC *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"shopCard"];
        [self.navigationController pushViewController: childController animated:(true)];
    }
    if ([poa.type isEqualToString:photoIdentifier]) {
        NSMutableArray *images = [NSMutableArray array];
        NSArray *stringArray = [poa.imagename componentsSeparatedByString:@"."];
        int count = [stringArray[1] integerValue];
        for (int i = 1; i<=count; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.jpg", stringArray[0], i]];
            if (img) {
                FSBasicImage *image = [[FSBasicImage alloc] initWithImage:img  name:@""];
                [images addObject:image];
            }
        }
        if ([images count] > 0) {
            FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:images];
            FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex: 0];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.navigationController pushViewController:imageViewController animated:YES];
                //            [self.navigationController presentViewController:imageViewController animated:YES completion:nil];
            }
            else {
                [self.navigationController pushViewController:imageViewController animated:YES];
            }
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

#pragma mark - set Play Mode
- (void) playMode:(AVAudioPlayer *) audioPlayer
{
    isPlayMode = YES;
    _audioPlayer =audioPlayer;
}

#pragma mark - Private Method

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

#pragma mark - Private Method

-(void)initView
{
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = _shareButton;
    
//    _mapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(mapAction:)];
//    [_mapButton setTitle:@"Map"];
//    self.navigationItem.rightBarButtonItem = _mapButton;
}
-(void)mapAction:(id)sender
{
    
}

- (void)showEmail:(NSString *) emailAdress{
    
    NSString *emailTitle = @"";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:emailAdress];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc) {
        mc.mailComposeDelegate = self;
//        [mc setSubject:emailTitle];
//        [mc setMessageBody:messageBody isHTML:NO];
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
    }
    
}
-(void)shareAction:(id)sender
{
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:link_];
    params.name = articleTitle;
    params.caption = caption_;
    params.picture = [NSURL URLWithString:picture_];
    params.description = Description;
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       articleTitle, @"name",
                                       caption_, @"caption",
                                       Description, @"description",
                                       link_, @"link",
                                       picture_, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params1
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
     
    /*
     // If the Facebook app is installed and we can present the share dialog
     if([FBDialogs canPresentShareDialogWithPhotos]) {
         /// Package the image inside a dictionary
         UIImage *img = mainImage;
         FBShareDialogPhotoParams *params = [[FBShareDialogPhotoParams alloc] init];
         params.photos = @[img];
         
         [FBDialogs presentShareDialogWithPhotoParams:params
                                          clientState:nil
                                              handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                  if (error) {
                                                      NSLog(@"Error: %@", error.description);
                                                  } else {
                                                      NSLog(@"Success!");
                                                  }
                                              }];
   
//         if (!appCall) {
//             [self performPublishAction:^{
//                 FBRequestConnection *connection = [[FBRequestConnection alloc] init];
//                 connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
//                 | FBRequestConnectionErrorBehaviorAlertUser
//                 | FBRequestConnectionErrorBehaviorRetry;
//                 
//                 [connection addRequest:[FBRequest requestForUploadPhoto:img]
//                      completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
//                          [self showAlert:@"Photo Post" result:result error:error];
//                          if (FBSession.activeSession.isOpen) {
//                              _shareButton.enabled = YES;
//                          }
//                      }];
//                 [connection start];
//                 
//                 _shareButton.enabled = NO;
////             }];
//         }
     
     
     } else {
     //The user doesn't have the Facebook for iOS app installed, so we can't present the Share Dialog
         UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Note" message:@"It seems you don't have Facebook installed, You need to have Facebook to share the photo" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alter show];
     }
    */
}
// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}
// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)initData
{
    CELL_CONTENT_WIDTH = self.view.frame.size.width;
    
    link_ = @"http://www.forbiddencitywizdavid.com/fc.html";
    picture_ = @"http://www.forbiddencitywizdavid.com/images/pic_fc01.jpg";
    caption_ = @"comes from iGuide Forbidden City";
    if (!articleTitle) {
        articleTitle = @"The Forbedden City";
    }
    //如果为空，则默认为Tips的
    if (!masterkeyid) {
        POArticle * spot = (POArticle *)[[[DaoArticle alloc] getAllTips] objectAtIndex:0];
        masterkeyid = spot.primaryid;
        self.title = spot.title;
        spot = nil;
    }
    DaoArticle *dao = [DaoArticle alloc];
    articles = [dao findAllArticleSectionsByID:masterkeyid];
    _cellCache = [NSMutableDictionary dictionary];
    
    index = -1;
    oldIndex = -1;
    dao = nil;
}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark - 动态显示播放内容
- (void)updateTime {
    if (isPlayMode && _audioPlayer.currentTime > 0) {
        float female = [FCSettingVC getfloatByKey:KeyVoiceType];
        int i = 0;
        for (POSection *section in articles) {
            if (female) {
                if (section.starttime1 && !(section.endtime1)) {
                    if (_audioPlayer.currentTime > [section.starttime1 doubleValue]) {
                        index = i;
                    }
                } else if (section.starttime1 && section.endtime1) {
                    if (_audioPlayer.currentTime > [section.starttime1 doubleValue] && _audioPlayer.currentTime < [section.endtime1 doubleValue]) {
                        index = i;
                    }
                }
            } else {
                if (section.starttime && !(section.endtime)) {
                    if (_audioPlayer.currentTime > [section.starttime doubleValue]) {
                        index = i;
                    }
                } else if (section.starttime && section.endtime) {
                    if (_audioPlayer.currentTime > [section.starttime doubleValue] && _audioPlayer.currentTime < [section.endtime doubleValue]) {
                        index = i;
                    }
                }
            }
            
            i++;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if (oldIndex != index) {
            //当播放下一段时，选中并移动到屏幕中心UITableViewScrollPositionMiddle
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            oldIndex = index;
        } else {
            //当播放当前段落时，选中直选中但不移动
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
}

@end
