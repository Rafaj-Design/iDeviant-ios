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


#pragma mark Data

- (void)reloadData {
    [super setCategoryData:[FTFavorites favoritesForFeedType:[FTConfig sharedConfig].favoritesFeedType]];
    [self createEditButton];
    [self.tableView reloadData];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [super setCategoryData:[FTFavorites favoritesForFeedType:[FTConfig sharedConfig].favoritesFeedType]];
    [self createEditButton];
    
    [[FTFavorites sharedFavorites] setDelegate:self];
}

#pragma mark Creating elements

- (void)createEditButton {
    if (self.categoryData.count > 0) {
        if (self.tableView.isEditing) {
            UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(switchEditMode:)];
            [self.navigationItem setRightBarButtonItem:edit animated:YES];
        }
        else {
            UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(switchEditMode:)];
            [self.navigationItem setRightBarButtonItem:edit animated:YES];
        }
    }
    else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)createSegmentedDataSortingSelector {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[FTLangGet(@"Popular"), FTLangGet(@"Newest")]];
    [seg setTintColor:[UIColor colorWithHexString:@"D0DE00"]];
    [seg addTarget:self action:@selector(didSwitchFeedSelector:) forControlEvents:UIControlEventValueChanged];
    [seg setSelectedSegmentIndex:[FTConfig sharedConfig].favoritesFeedType];
    [seg setFrame:CGRectMake(5, 10, (self.view.width - 10), 24)];
    [seg setAutoresizingWidth];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [v setBackgroundColor:[UIColor colorWithHexString:@"A0ABA2"]];
    [v addSubview:seg];
    [self.tableView setTableHeaderView:v];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createSegmentedDataSortingSelector];
    
    [super.refreshControl removeFromSuperview];
    [self.navigationItem setRightBarButtonItem:nil];
}

#pragma mark Actions

- (void)didSwitchFeedSelector:(UISegmentedControl *)sender {
    [[FTConfig sharedConfig] setFavoritesFeedType:sender.selectedSegmentIndex];
    [self reloadData];
}

- (void)switchEditMode:(UIBarButtonItem *)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self createEditButton];
}

#pragma mark Favorites delegate

- (void)favorites:(FTFavorites *)favorites didRemoveCategory:(NSDictionary *)categoryData withFeedType:(FTConfigFeedType)feedType {
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath.row != destinationIndexPath.row) {
        [FTFavorites moveCategoryAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row forFeedType:self.feedType];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *category = [self.categoryData objectAtIndex:indexPath.row];
        [FTFavorites removeCategoryFromFavorites:category forFeedType:self.feedType];
    }
}

#pragma mark Feed settings

- (FTConfigFeedType)feedType {
    return [[FTConfig sharedConfig] favoritesFeedType];
}


@end
