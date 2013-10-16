//
//  FTFavoritesViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTFavoritesViewController.h"


@interface FTFavoritesViewController ()

@end


@implementation FTFavoritesViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [super setCategoryData:[FTFavorites favorites]];
    
    [[FTFavorites sharedFavorites] setDelegate:self];
}

#pragma mark Creating elements

- (void)createSegmentedDataSortingSelector {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[FTLangGet(@"Popular"), FTLangGet(@"Newest")]];
    [seg setFrame:CGRectMake(5, 7, (self.view.width - 10), 24)];
    [seg setAutoresizingWidth];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 38)];
    [v setBackgroundColor:[UIColor colorWithHexString:@"D6E0D4"]];
    [v addSubview:seg];
    [self.tableView setTableHeaderView:v];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createSegmentedDataSortingSelector];
    
    [super.refreshControl removeFromSuperview];
    [self.navigationItem setRightBarButtonItem:nil];
}

#pragma mark Favorites delegate

- (void)favorites:(FTFavorites *)favorites didRemoveCategory:(NSDictionary *)categoryData {
    NSMutableArray *cats = [NSMutableArray arrayWithArray:super.categoryData];
    [cats removeObject:categoryData];
    [super setCategoryData:cats];
    [self.tableView reloadData];
}

#pragma mark Table view delegate & datasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *category = [self.categoryData objectAtIndex:indexPath.row];
    static NSString *cellId = @"cellId";
    FTBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell.textLabel setText:[category objectForKey:@"name"]];
    return cell;
}


@end
