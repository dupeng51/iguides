//
//  SearchPlaceVC.m
//  iGuidFC
//
//  Created by dampier on 15/4/29.
//  Copyright (c) 2015年 Artur Mkrtchyan. All rights reserved.
//

#import "SearchPlaceVC.h"


@interface SearchPlaceVC ()

@end

@implementation SearchPlaceVC{
    NSArray *searchResults;
    SkyUtils *skyUtils;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    skyUtils = nil;
    searchResults = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return 0;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",
                               ((PlaceSkyModel *)[searchResults objectAtIndex:indexPath.row]).placeName,
                               ((PlaceSkyModel *)[searchResults objectAtIndex:indexPath.row]).countryName] ;
    } else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate selectPlaces:[searchResults objectAtIndex:indexPath.row] depart:self.isDepart];
    }];
}

#pragma mark - SkyQuerayLocation Delegate

- (void) responsePlaces:(NSArray *) places
{
    searchResults = places;
//    [self.tableView reloadData];
}

#pragma mark - Private Method

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (!skyUtils) {
        skyUtils = [[SkyUtils alloc] init];
        skyUtils.delegate = self;
    }
    [skyUtils queryLocation:searchText];
}

#pragma mark - Actions

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    CityMap *cityMap = segue.destinationViewController;
    //    NSInteger indexRow = [self.tableView indexPathForCell: ((UITableViewCell *)sender)].row;
    //    cityMap.city = (AllCitys *)[searchResults objectAtIndex:indexRow];
    //    //    [self.navigationController pushViewController:cityMap animated:YES];
    //    [self presentViewController:cityMap animated:YES completion:nil];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

@end
