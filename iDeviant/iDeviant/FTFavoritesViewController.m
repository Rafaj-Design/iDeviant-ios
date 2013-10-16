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

- (void)createAllElements {
    [super createAllElements];
    
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


@end
