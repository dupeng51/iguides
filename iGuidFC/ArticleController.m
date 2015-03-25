//
//  ArticleController.m
//  AMSlideMenu
//
//  Created by dampier on 14-1-20.
//  Copyright (c) 2014年 Artur Mkrtchyan. All rights reserved.
//

#import "ArticleController.h"
#import "AppDelegate.h"
#import "POArticle.h"
#import "ArticleSectionController.h"
#import "DaoArticle.h"

@interface ArticleController ()

@end

@implementation ArticleController
{
NSArray * articles;
}

@synthesize childController;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)dealloc
{
    articles = nil;
    if (childController) {
        [childController removeFromParentViewController];
        childController = nil;
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
    NSString *CellIdentifier = @"article";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    POArticle *poa = articles[indexPath.row];
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    cellLabel.text = poa.title;
    
    cell.tag =  [poa.primaryid integerValue];
    
    cellLabel = nil;
    poa = nil;
    CellIdentifier = nil;
    
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
    ArticleSectionController *sectionController = (ArticleSectionController *)[segue destinationViewController];
    UITableViewCell *tableviewcell = sender;
    sectionController.masterkeyid = tableviewcell.tag;
}
*/

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    childController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleSectionView"];
    
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

#pragma mark - Private Method
- (void) initData:(NSString *) TableType
{
    DaoArticle *dao = [DaoArticle alloc];
//    articles = [dao geta];
    dao = nil;
}

@end
