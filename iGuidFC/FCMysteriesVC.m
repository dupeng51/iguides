//
//  FCMysteriesVC.m
//  SpecialFC
//
//  Created by dampier on 14-3-29.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "FCMysteriesVC.h"
#import "ArticleController.h"
#import "AppDelegate.h"
#import "POArticle.h"
#import "ArticleSectionController.h"
#import "DaoArticle.h"
#import "POSection.h"

@interface FCMysteriesVC ()

@end

@implementation FCMysteriesVC
{
    NSArray * articles;
    int CELL_CONTENT_WIDTH;
}

#define TITLEFONT_SIZE 16.0f
#define FONT_SIZE 24.0f
#define CELL_CONTENT_MARGIN 10.0f

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

    //设置导航栏颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(float)128 / 255.0 green:(float)0 / 255.0 blue:(float)0/ 255.0 alpha:1.0]];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) initData
{
    CELL_CONTENT_WIDTH = self.view.frame.size.width;
    DaoArticle *dao = [DaoArticle alloc];
    articles = [dao getAllMysteries];
    dao = nil;
}

- (void)dealloc
{
    articles = nil;
//    if (childController) {
//        [childController removeFromParentViewController];
//        childController = nil;
//    }
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
    return [articles count] +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        //显示图片
        NSString *CellIdentifier = @"imageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        //显示title
        NSString *CellIdentifier = @"titleCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *textview = (UILabel *)[cell viewWithTag:1];
        
        POArticle *poa = articles[indexPath.row -1];
        
        [textview setLineBreakMode: UILineBreakModeWordWrap];
        [textview setMinimumFontSize:TITLEFONT_SIZE];
        [textview setNumberOfLines:0];
        [textview setFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE]];
        //        [textview setTag:1];
        
        //        [[textview layer] setBorderWidth:2.0f];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSString *text = poa.title;
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [textview setText: text];
        [textview setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height+ (CELL_CONTENT_MARGIN * 2), 33.0f))];
        [textview sizeToFit];
        
        cell.tag =  [poa.primaryid integerValue];
        
        textview = nil;
        poa = nil;
        CellIdentifier = nil;
        text = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    if (row == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return 593;
        } else {
            return 230;
        }
        
    }
    POArticle *articleSection = articles[row- 1];
    NSString *text = articleSection.title;
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size:TITLEFONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = size.height + (CELL_CONTENT_MARGIN * 2);
    
    text = nil;
    articleSection = nil;
    return MAX(height, 33.0f);
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    ArticleSectionController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
    
    POArticle *poa = articles[indexPath.row-1];
    
    childController.title = @"Mysteries Article";
    childController.articleTitle = poa.title;
    childController.link_ = poa.link;
    childController.picture_ = poa.picture;
    childController.caption_ = poa.caption;
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
