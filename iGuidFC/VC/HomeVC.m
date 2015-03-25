//
//  HomeVC.m
//  AMSlideMenu
//
//  Created by dampier on 14-3-7.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "HomeVC.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import "ArticleSectionController.h"
#import "FCMapController.h"
#import "ArticleController.h"
#import "ChinaThingVC.h"
#import "IntroModel.h"
#import "IntroControll.h"
#import "AppDelegate.h"
#import "FCSettingVC.h"
#import "FCSmartPlayingVC.h"
#import <MessageUI/MessageUI.h>

@interface HomeVC ()

@end

@implementation HomeVC
{
    UIViewController *childController;
    FCMapController *mapController;
    FCSmartPlayingVC *smartController;
    IntroControll *imageview;
    UIView *originalView;
    NSTimer *_timer;
    BOOL _hidden;
    NSArray *_spots;
    NSArray *photoTitles_;
    NSString *extension;
    UIImage *selectedImage;
    CLLocationManager *myLocationManager;
    CLLocation *_currentLocation;
}

#define buttomViewHeight   50
#define iPadButtomViewHeight 100
#define photoNum 35

#ifdef SP_VERSION
#define photoNum 45
#endif

#ifdef TH
#define photoNum 17
#endif

#ifdef Yu
#define photoNum 21
#endif

#ifdef LT
#define photoNum 16
#endif

@synthesize img, playStatusView, playStateButon, playStateIcon;

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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
    [img addGestureRecognizer:singleTap];
    singleTap = nil;

    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    
    [self initData];
    [self initView];
    
//    self.wantsFullScreenLayout = YES;
//    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) dealloc
{
    if (imageview) {
        imageview = nil;
    }
    if (mapController) {

        mapController = nil;
    }
    if (childController) {

        childController= nil;
    }
    
    originalView = nil;
    if (_timer) {
        [_timer invalidate];
        _timer= nil;
    }
    
    img = nil;
    playStatusView = nil;
    playStateButon = nil;
    _spots = nil;
    photoTitles_ = nil;
    extension = nil;
    selectedImage = nil;
    myLocationManager = nil;
    _currentLocation = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self initView];
    //开启线控接受功能
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    
    if([CLLocationManager locationServicesEnabled]) {
        if (!myLocationManager) {
            myLocationManager = [[CLLocationManager alloc] init];
            myLocationManager.delegate = self;
            myLocationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
            myLocationManager.distanceFilter = 20.0f;
            if ([myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [myLocationManager requestWhenInUseAuthorization];
            }
            [myLocationManager startUpdatingLocation];
//            [myLocationManager startMonitoringSignificantLocationChanges];
        }
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) initData
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(updatePlayState)
                                            userInfo:nil
                                             repeats:YES];
    
    photoTitles_ = [NSArray arrayWithObjects:@"City wall and watching tower",
                    @"Sundial", @"Glory sunshine and the glazed-tile roof",
                    @"Tranquility around the curved canal with bridges above (Front part of the Gate of Supreme Harmony)",
                    @"Red columns in contrast to the white snow-paved slope",
                    @"Newly replaced yellow tiles",
                    @"Quietness and solemnity (Walking way)",
                    @"Guarding (The marble-made hornless dragon)",
                    @"Stair railing (Beneath the Hall of Preserving Harmony)",
                    @"Stair railing & walk (Beneath the Hall of Supreme Harmony)",
                    @"Loner (The crane statue in front of the Hall of Supreme Harmony)",
                    @"Chimeras & auspicious animal statues along on the roof",
                    @"Forbidden City never ends (Coal Hill to its north)",
                    @"Hall of Preserving Harmony",
                    @"Wonderful roves and wooden structures",
                    @"Exquisite window frames",
                    @"Dancing snow (In front of the Hall of Preserving harmony)",
                    @"Deity on the phoenix back (Animal figures on all roves)",
                    @"Grandeur of the watching tower (The northeastern tower)",
                    @"Door", nil];
}

-(void)initView
{
    //导航栏增加背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cloud.jpg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    myLocationManager.delegate = nil;
    myLocationManager = nil;
    //关闭线控接受功能
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mapClick:(id)sender
{
    if (!mapController)
    {
        mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
    }
    [self.navigationController pushViewController: mapController animated:(true)];
    
}
/*
#pragma mark - remote Control
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //	if (event.type == UIEventTypeRemoteControl) {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            [mapController.butomView play:self];
            break;
        }
        case UIEventSubtypeRemoteControlPlay:
        {
            NSLog(@"UIEventSubtypeRemoteControlPlay...");
            break;
        }
        case UIEventSubtypeRemoteControlPause:
        {
            NSLog(@"UIEventSubtypeRemoteControlPause...");
            break;
        }
        case UIEventSubtypeRemoteControlStop:
        {
            NSLog(@"UIEventSubtypeRemoteControlStop...");
            break;
        }
        case UIEventSubtypeRemoteControlPreviousTrack:
            [mapController.butomView previousVoice:self];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            //              播放下一曲按钮
            [mapController.butomView nextVoice:self];
            NSLog(@"UIEventSubtype RemoteControl Next Track...");
            break;
            
        default:
            break;
    }
    //    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
*/

/*
#pragma mark - Table view data source
//当使用静态tabelview时，注销掉下面的代码，静态tabelview才显示


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 */

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
/*----------------------------------------------------*/
#pragma mark - location Event -
/*----------------------------------------------------*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
   
    NSLog(@"did Update Locations");
    if (![FCMapController isAbsolutOut:((CLLocation *)[locations lastObject]).coordinate] && [FCMapController isAbsolutOut:_currentLocation.coordinate] && !((AppDelegate*)[[UIApplication sharedApplication] delegate]).isShowAlarm) {
        NSString *alertString = @"As you are in the Forbidden City, please start to use smart guide!";
#ifdef SP_VERSION
        alertString = @"As you are in the Summer Palace, please start to use smart guide!";
#endif
#ifdef TH
        alertString = @"As you are in the Temple of Heaven, please start to use smart guide!";
#endif
#ifdef Yu
        alertString = @"As you are in the Yu Garden, please start to use smart guide!";
#endif
#ifdef LT
        alertString = @"As you are in the Lama Temple, please start to use smart guide!";
#endif
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Guide"
                                                        message:alertString
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK",
                              nil];
        [alert show];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isShowAlarm = YES;

    } else {
        [manager stopUpdatingLocation];
    }
    _currentLocation = [locations lastObject];
}


#pragma mark - Navigation

- (IBAction)showPlayingMap:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isSmartMode) {
        if (!smartController)
        {
            smartController = [self.storyboard instantiateViewControllerWithIdentifier:@"smartVC"];
            
        }
        [self.navigationController pushViewController: smartController animated:(true)];
    } else {
        if (!mapController)
        {
            mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
        }
        mapController.selectedSpotIndex = [NSNumber numberWithInteger: appDelegate.currentPlayingIndex];
        [self.navigationController pushViewController: mapController animated:(true)];
    }
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        
    }
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell * cell = (UITableViewCell *)sender;
        switch (cell.tag) {
            case 1:
            {
                //About FC
                POArticle * spot = (POArticle *)[[[DaoArticle alloc] getAllTips] objectAtIndex:0];
                ArticleSectionController *articlSection = (ArticleSectionController *)[segue destinationViewController];
                articlSection.title = @"Tips For Your Visit";
                articlSection.masterkeyid = spot.primaryid;
                break;
            }
            case 4:
            {
                //About Summer Palace
                POArticle * spot = (POArticle *)[[[DaoArticle alloc] getAllAbout] objectAtIndex:0];
                ArticleSectionController *articlSection = (ArticleSectionController *)[segue destinationViewController];
                articlSection.title = @"About The Summer Palace";
#ifdef TH
                articlSection.title = @"The Temple of Heaven";
#endif
#ifdef LT
                articlSection.title = @"The Lama Temple";
#endif
                articlSection.masterkeyid = spot.primaryid;
                break;
            }
            case 7:
            {
                //Learn Tai Chi with Eric
//                POArticle * spot = (POArticle *)[[[DaoArticle alloc] getAllAbout] objectAtIndex:0];
                ArticleSectionController *articlSection = (ArticleSectionController *)[segue destinationViewController];
#ifdef TH
                articlSection.title = @"Learn Tai Chi with Eric";
#endif
                articlSection.masterkeyid = [NSNumber numberWithInt:111];
                break;
            }
            case 8:
            {
                //shop
                break;
            }
            case 9:
            {
                //Lamaism and Buddhism
                ArticleSectionController *articlSection = (ArticleSectionController *)[segue destinationViewController];

                articlSection.title = @"Lamaism and Buddhism";
                articlSection.masterkeyid = [NSNumber numberWithInt:302];
                break;
            }
            case 10:
            {
                //The Coming of Buddhism
                ArticleSectionController *articlSection = (ArticleSectionController *)[segue destinationViewController];
                
                articlSection.title = @"The Coming of Buddhism";
                articlSection.masterkeyid = [NSNumber numberWithInt:301];
                break;
            }
            default:
                break;
        }
        cell = nil;
    };
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//点击主界面图片，进入浏览图片
-(void) onClickImage
{
//    [self showEmail:@"zen.jpg"];
//    [self sendPhoto];
//    return;
    
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= photoNum; i++) {
//        IntroModel *model = [[IntroModel alloc] initWithTitle:@"" description:[photoTitles_ objectAtIndex:i-1] image:[NSString stringWithFormat:@"photo%d", i] type:@"jpg"];
        NSString *desc = @"";
        if (i == photoNum) {
            desc = @"Waiting for your photo...";
        }
        NSString *namePre = @"photo";
#ifdef SP_VERSION
        namePre = @"Summer Palace";
#endif
#ifdef TH
        namePre = @"templeHeaven";
#endif
#ifdef Yu
        namePre = @"YuGarden";
#endif
#ifdef LT
        namePre = @"Lama";
#endif
        IntroModel *model = [[IntroModel alloc] initWithTitle:@"" description:desc image:[NSString stringWithFormat:@"%@%d", namePre, i] type:@"jpg"];
        [pages addObject:model];
        model = nil;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    if (!imageview) {
        imageview = [[IntroControll alloc] initWithFrame:rect pages:pages email:YES];
    }
    UITapGestureRecognizer * regnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto:)];
    [imageview addGestureRecognizer:regnizer];
    [self.view addSubview:imageview];
    
    
    [self setHidenNav:YES];
    pages = nil;
    regnizer = nil;
    
}
//点击浏览图片，退出浏览
-(void) clickPhoto:(UITapGestureRecognizer *)tap
{
    [self setHidenNav:NO];
    [imageview removeFromSuperview];
    [imageview removeGestureRecognizer:[imageview.gestureRecognizers objectAtIndex:0]];

    imageview = nil;
//    self.view = originalView;
}

-(void) setHidenNav:(BOOL) hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}

#pragma mark - init
-(void)updatePlayState
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer.isPlaying) {
//        if (_hidden) {
            [self setPlayStateHidden:NO];
            [_timer setFireDate:[NSDate distantPast]];
            _hidden = NO;
//        }
        [self setPlayContent];
    } else {
//        if (!_hidden) {
            [self setPlayStateHidden:YES];
//            [_timer setFireDate:[NSDate distantFuture]];
            _hidden = YES;
//        }
    }
    appDelegate = nil;
}
//更新正在播放的信息
-(void) setPlayContent
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.audioPlayer.isPlaying) {
        if (!_spots) {
            _spots = [[DaoArticle alloc] findAllSpotsByLineNo:0];
        }
        POArticle *spot = [_spots objectAtIndex: appDelegate.currentPlayingIndex];
        NSString *title = [NSString stringWithFormat:@"%@\n%@", spot.title, spot.remark ];
        [playStateButon setTitle:title forState:UIControlStateNormal] ;
        
        spot = nil;
        title = nil;
    }
    appDelegate = nil;
}
//设置播放状态是否显示
-(void)setPlayStateHidden:(BOOL) hidden
{
    CGRect rect =playStatusView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    if (!hidden) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            rect.origin.y = playStatusView.superview.frame.size.height - iPadButtomViewHeight;
        } else {
            rect.origin.y = playStatusView.superview.frame.size.height - buttomViewHeight;
        }
        
        [playStatusView setFrame:rect];
        playStatusView.alpha = 0.6;
        playStateButon.alpha = 1;
        playStateIcon.alpha = 1;
    } else {
        rect.origin.y = playStatusView.superview.frame.size.height;
        [playStatusView setFrame:rect];
        playStatusView.alpha = 0;
        playStateButon.alpha = 0;
        playStateIcon.alpha = 0;
    }
    
    [UIView commitAnimations];
}

- (IBAction)playModeTap:(id)sender
{
    if (!mapController)
    {
        mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mapController.selectedSpotIndex = [NSNumber numberWithInteger: appDelegate.currentPlayingIndex];
    [self.navigationController pushViewController: mapController animated:(true)];
    appDelegate = nil;
}

-(void)sendPhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^(){
//                         [self showEmail];
                         [self setHidenNav:YES];
                     }];
}
// When the user is done picking the image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *url =[info objectForKey:UIImagePickerControllerReferenceURL];
    int strateIndex = url.absoluteString.length ;
    extension = [url.absoluteString substringFromIndex:strateIndex -3];
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //disapper photo galery
    [picker dismissViewControllerAnimated:YES
                               completion:^(){
                                   [self showEmail];
                               }];
}


- (void)showEmail{
    
    NSString *emailTitle = @"Great Photo";
    NSString *messageBody = @"Hey, I'm ***, I hope this photo can show in this app.";
    NSArray *toRecipents = [NSArray arrayWithObject:@"iguidecontact@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (mc) {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Determine the file name and extension
        //    NSArray *filepart = [file componentsSeparatedByString:@"."];
        //    NSString *filename = [filepart objectAtIndex:0];
        //    NSString *extension = [filepart objectAtIndex:1];
        
        // Get the resource path and read the file using NSData
        //    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
        //    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        // Determine the MIME type
        NSString *mimeType;
        if ([extension isEqualToString:@"JPG"]) {
            mimeType = @"image/jpeg";
        } else if ([extension isEqualToString:@"PNG"]) {
            mimeType = @"image/png";
        } else if ([extension isEqualToString:@"DOC"]) {
            mimeType = @"application/msword";
        } else if ([extension isEqualToString:@"PPT"]) {
            mimeType = @"application/vnd.ms-powerpoint";
        } else if ([extension isEqualToString:@"HTML"]) {
            mimeType = @"text/html";
        } else if ([extension isEqualToString:@"PDF"]) {
            mimeType = @"application/pdf";
        }
        
        // Add attachment
        [mc addAttachmentData:UIImageJPEGRepresentation(selectedImage, 1.0) mimeType:mimeType fileName:@"Great Photos"];
        
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

//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (!smartController)
        {
            smartController = [self.storyboard instantiateViewControllerWithIdentifier:@"smartVC"];
            
        }
        [FCSettingVC setSmartGuide];
        smartController.isPlay = YES;
//        smartController._currentLocation = _currentLocation;
        [self.navigationController pushViewController: smartController animated:(true)];


//        [mapController showNearestSpot:_currentLocation];
    }
    NSLog(@"单击第:%d",buttonIndex);
}

@end
