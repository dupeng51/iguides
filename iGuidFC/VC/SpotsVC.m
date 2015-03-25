//
//  SpotsVC.m
//  SpecialFC
//
//  Created by dampier on 14-3-20.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "SpotsVC.h"
#import "DaoArticle.h"
#import "POArticle.h"
#import "AppDelegate.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "ArticleSectionController.h"
#import "FCMapController.h"

@interface SpotsVC ()

@end

@implementation SpotsVC{
    NSArray * articles;
}

- (void) dealloc
{
    articles = nil;
}

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

    
    DaoArticle *dao = [DaoArticle alloc];
    articles = [dao getAllSpots1];
    dao = nil;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
//    [self.tableView setContentOffset:CGPointMake(0,480) animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"spot";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    POArticle *poa = articles[indexPath.row];
    
    //title
    UILabel *textview = (UILabel *)[cell viewWithTag:1];
    textview.text = poa.title;
    textview = nil;
    //chinese title
    UILabel *textview2 = (UILabel *)[cell viewWithTag:2];
    textview2.text = poa.remark;
    textview2 = nil;
    //image
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 75, 62)];
    img.image  = [UIImage imageNamed:poa.imagename];
    [img setUserInteractionEnabled:YES];
    [img.layer setMasksToBounds:YES];
    [img.layer setCornerRadius:4];
    img.tag = indexPath.row;
    //添加点击图片相应事件
    UITapGestureRecognizer * regnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto:)];
    [img addGestureRecognizer:regnizer ];
    [cell addSubview:img];
    
    //map button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 42, cell.frame.size.height/2 -20, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"location2.png"] forState:UIControlStateNormal];
    btn.tag = indexPath.row;
    
    UITapGestureRecognizer * regnizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMapBtn:)];
    [btn addGestureRecognizer:regnizer1];
    [cell addSubview:btn];


    
    regnizer = nil;
    img = nil;
    poa = nil;
//    CellIdentifier = nil;
    
//    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleSectionController * childController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
    
    POArticle *poa = articles[indexPath.row];
    
    childController.title = poa.title;
    childController.articleTitle = poa.title;
    
    //SEL selector;
    childController.masterkeyid = poa.primaryid;
    
    
    //    NSNumber *primaryid = [NSNumber numberWithInt: *(poa.primaryid)];
    //    [sectionController setValue:primaryid forKey:@"keyid"];
    
    //[sectionController setKeyID:primaryid];
    //[sectionController setKeyID: primaryid];
    
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.articleID = poa.primaryid;
    [self.navigationController pushViewController: childController animated:(true)];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    poa = nil;
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


#pragma mark - Navigation
/*
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton * btn = (UIButton *)sender;
//    UITableViewCell *cell = (UITableViewCell *)(btn.superview.superview);
    NSInteger rowindex = btn.tag;
    
    POArticle * spot = [articles objectAtIndex:rowindex];
    
    FCMapController *childVC = (FCMapController *)[segue destinationViewController];
    
    childVC.selectedSpotIndex =  [NSNumber numberWithInteger:rowindex];
    childVC = nil;
}
*/
#pragma mark - event
-(void) clickPhoto:(UITapGestureRecognizer *)sender
{
    //用tag传值判断
    NSInteger row = ((UIImageView *)sender.view).tag;
    
    NSMutableArray *images = [NSMutableArray array];
    for (POArticle * spot in articles) {
        UIImage *img = [UIImage imageNamed:spot.imagename];
        if (img) {
            FSBasicImage *image = [[FSBasicImage alloc] initWithImage:img  name:spot.title];
            [images addObject:image];
        }
    }
    if ([images count] > 0) {
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:images];
        FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex: row];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.navigationController pushViewController:imageViewController animated:YES];
//            [self.navigationController presentViewController:imageViewController animated:YES completion:nil];
        }
        else {
            [self.navigationController pushViewController:imageViewController animated:YES];
        }
    }
}

-(void) clickMapBtn:(UITapGestureRecognizer *)sender
{
    //用tag传值判断
    NSInteger row = ((UIButton *)sender.view).tag;
    
    FCMapController *childVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
    childVC.selectedSpotIndex = [NSNumber numberWithInteger:row];
    [self.navigationController pushViewController:childVC animated:YES];
    childVC = nil;
}

#pragma mark - Private Method


@end
