//
//  DownloadListVCTableViewController.m
//  iGuidFC
//
//  Created by dampier on 15/3/30.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "DownloadListVC.h"
#import "DaoArticle.h"
#import "POSpot.h"
#import "AFDownloadRequestOperation.h"
#import "AppDelegate.h"
#import "SSZipArchive.h"

@interface DownloadListVC ()

@end


#define pauseIconName @"f04c.png"
#define playIconName @"f04b.png"


@implementation DownloadListVC
{
    NSArray * spots;
}

- (void) dealloc
{
    spots = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    DaoArticle *dao = [DaoArticle alloc];
    spots = [dao getDownloadBigSpot];
    
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.panGestureRecognizer.cancelsTouchesInView = NO;
//    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [spots count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"spot";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    POSpot *poa = spots[indexPath.row];
    
    //title
    UILabel *textview = (UILabel *)[cell viewWithTag:1];
    textview.text = poa.name;
    //chinese title
    UILabel *textview2 = (UILabel *)[cell viewWithTag:2];
    textview2.text = poa.desc;
    //image
    UIImageView *img = (UIImageView *)[cell viewWithTag:3];
    img.image  = [UIImage imageNamed:poa.imageName];
    [img setUserInteractionEnabled:YES];
    [img.layer setMasksToBounds:YES];
    [img.layer setCornerRadius:4];
    
    //get download operation
    AFDownloadRequestOperation *operation = [self getDownloadOperationWithSpotID:poa.pid.intValue];

    //download progress
    UIView *progressView = (UIView *) [cell viewWithTag:5];
    NSLog(@"%d", poa.downloadStatus.intValue);
    
    //download/stop button
    UIButton *btn = (UIButton *)[cell viewWithTag:4];
    
    if (poa.downloadStatus.intValue == DOWNLOADSTATUS_COMPLETED) {
        //        [self setProgressView:progressView percent:1 cell:cell];
        [progressView setAlpha:0];
        [btn setHidden:YES];
    }
    
    if (!operation) {
        operation = [self newOperationWithSpotid:poa.pid.stringValue];
    }
    operation.progressview = progressView;
    if (operation.isExecuting) {
        [btn setImage:[UIImage imageNamed:pauseIconName] forState:UIControlStateNormal];
    } else {
        [btn setImage:[UIImage imageNamed:playIconName] forState:UIControlStateNormal];
    }
    // set progress block
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        [self setProgressView:operation.progressview percent:percentDone cell:cell];
        
        
        NSLog(@"spotid %@ percentDone------%f", poa.pid.stringValue,percentDone);
        //                    NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
        //                    NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
        //                    NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
        //                    NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
        //                    NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
    }];
    // set complete block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self unZipFile:poa.pid.stringValue];
        
        DaoArticle *dao = [DaoArticle alloc];
        if ([dao setBigSpotWithDownloadStatus:DOWNLOADSTATUS_COMPLETED spotid:poa.pid.stringValue]) {
//            spots = [dao getDownloadBigSpot];
//            [self.tableView reloadData];
        }
        if (progressView) {
            [progressView setAlpha:0];
            [btn setHidden:YES];
        }
        
//        NSLog(@"Successfully downloaded file to %@");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [btn setTranslatesAutoresizingMaskIntoConstraints:YES];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    [btn setCenter:CGPointMake( cell.contentView.frame.size.width - 40,  cell.contentView.center.y)];
    
//    UITapGestureRecognizer * regnizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadBtn:)];
//    [btn addGestureRecognizer:regnizer1];
    [cell addSubview:btn];
    cell.tag = [poa.pid intValue];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        NSString *spotid = ((POSpot *)spots[indexPath.row]).pid.stringValue;
        NSString *filePath = [DownloadListVC directoryWithSpotID:spotid];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];

        [appDelegate removeOperation:((POSpot *)spots[indexPath.row]).pid.intValue];
        
        DaoArticle *dao = [DaoArticle alloc];
        if ([dao setBigSpotWithDownloadStatus:DOWNLOADSTATUS_NULL spotid:spotid]) {
            spots = [dao getDownloadBigSpot];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"editingStyleForRowAtIndexPath");
    
    return UITableViewCellEditingStyleDelete;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Public Method

-(void) addSpotToDownload:(int) spotid
{
    AFDownloadRequestOperation *operation = [self getDownloadOperationWithSpotID:spotid];
    if (!operation) {
        DaoArticle *dao = [DaoArticle alloc];
        POSpot *spot =[dao getBigSpotWithID:[NSString stringWithFormat:@"%d", spotid]];
        if (spot.downloadStatus.intValue == DOWNLOADSTATUS_NULL) {
            [dao setBigSpotWithDownloadStatus:DOWNLOADSTATUS_DOWNLOADING spotid:[NSString stringWithFormat:@"%d", spotid]];
        }
        if (spot.downloadStatus.intValue == DOWNLOADSTATUS_COMPLETED) {
            return;
        }
        spots = [dao getDownloadBigSpot];
        [[self newOperationWithSpotid:[NSString stringWithFormat:@"%d", spotid]] start];
        [self.tableView reloadData];
    } else {
        if (operation.isPaused) {
            [operation resume];
        }
        
    }
}

+(NSString *) directoryWithSpotID:(NSString *) spotid {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:spotid];
    if (![[NSFileManager defaultManager] fileExistsAtPath: path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+(NSArray *) getBackgroundPaths:(NSString *) spotid {
    NSString *musicPath = [[DownloadListVC directoryWithSpotID:spotid] stringByAppendingPathComponent:@"music"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
        NSArray *musicFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:musicPath error:nil];
        NSMutableArray *musicPaths = [[NSMutableArray alloc] init];
        for (NSString *filename in musicFileNames) {
            [musicPaths addObject:[musicPath stringByAppendingPathComponent:filename]];
        }
        return musicPaths;
    }
    return nil;
}

#pragma mark - Action Method

-(IBAction)downloadAction:(id)sender;
{
    UIButton *downloadBtn = (UIButton *)sender;
    UIView *cellView =downloadBtn;
    while (cellView && ![cellView isKindOfClass:[UITableViewCell class]]){
        cellView = cellView.superview;
    }
//    int row = [self.tableView indexPathForCell: ((UITableViewCell *)cellView)].row;

//    int spotid = ((POSpot *)spots[row]).pid.intValue;
    int spotid = cellView.tag;
    AFDownloadRequestOperation *operation =[self getDownloadOperationWithSpotID:spotid];
    if (operation) {
        if (operation.isExecuting) {
            [operation pause];
//            [operation cancel];
//            [self stopDownloading:spotid];

            [downloadBtn setImage:[UIImage imageNamed:playIconName] forState:UIControlStateNormal];
        } else {
            if (operation.isPaused) {
                [operation prepareDownload];
                [operation resume];
//                [operation start];
            } else {
                [operation prepareDownload];
                [operation start];
            }
            [downloadBtn setImage:[UIImage imageNamed:pauseIconName] forState:UIControlStateNormal];
        }
    }else {
        [downloadBtn setImage:[UIImage imageNamed:pauseIconName] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Inner Method

-(void) stopDownloading:(int) spotid
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    AFDownloadRequestOperation *operation = [appdelegate getOperationWithSpotid:spotid];
    [operation cancel];
    [appdelegate removeOperation:spotid];
    
}



-(void) setProgressView:(UIView *) progressView percent:(float) percent cell:(UITableViewCell *) cell
{
    [progressView setFrame:CGRectMake(percent * cell.contentView.frame.size.width, 0, cell.contentView.frame.size.width *(1-percent), cell.contentView.frame.size.height)];
}

-(AFDownloadRequestOperation *) getDownloadOperationWithSpotID:(int ) spotid {
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    for (AFDownloadRequestOperation *operation in appDelegate.downloadOperations) {
        POSpot *spot =(POSpot *)(operation.userData);
        if (spot.pid.intValue == spotid) {
            return operation;
        }
    }
    return nil;
}

-(AFDownloadRequestOperation *) newOperationWithSpotid:(NSString *) spotid
{
    DaoArticle *dao = [DaoArticle alloc];
    POSpot *spot = [dao getBigSpotWithID:spotid];
    NSString *urlStr = spot.downloadurl;
//    NSString *urlStr = @"http://media.animusic2.com.s3.amazonaws.com/Animusic-ResonantChamber480p.mov";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
//    NSString *filePath = [[DownloadListVC directoryWithSpotID:spotid] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",spotid]];
    NSString *filePath = [DownloadListVC directoryWithSpotID:spotid];
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *MUSICFile = [documentsDirectory stringByAppendingPathComponent:@"music.zip"];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:filePath shouldResume:YES];
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate addDownloadOperationsObject:operation];
    
    operation.userData = spot;
    
//    [operation start];
    return operation;
}

- (void) unZipFile:(NSString *) spotid
{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *zipPath = [[DownloadListVC directoryWithSpotID:spotid] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",spotid]];
    BOOL isDirectory;
    if ([fileManager fileExistsAtPath:zipPath isDirectory:&isDirectory]) {
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:zipPath error:&error];
        if (!error && fileDict) {
            NSNumber *fileSize = [fileDict objectForKey:NSFileSize];
            NSLog(@"%f", fileSize.floatValue);
        }
    }
    NSString *path = [DownloadListVC directoryWithSpotID:spotid];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:path];

//    [self initData];
    
    //delete file
    if ([fileManager removeItemAtPath:zipPath error:&error]) {
        NSLog(@"Successfully delete file:%@", zipPath);
    } else {
        NSLog(@"Error: %@", error);
    }
    
    
    NSLog(@"Successfully upzip file to %@", path);
}

@end

