//
//  FTDeviationsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDeviationsViewController.h"


@interface FTDeviationsViewController ()

@end


@implementation FTDeviationsViewController


#pragma mark - Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super createTableView];
}

#pragma mark - Settings

- (void)setCategoryData:(NSArray *)categoryData {
    [super setCategoryData:categoryData];
    //[self.tableView reloadData];
}

- (void)setCategoryCode:(NSString *)categoryCode {
    [super setCategoryCode:categoryCode];
    [super getDataForCategory:categoryCode];
}

#pragma mark - Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.categoryData.count > 0) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView) {
        if (self.searchData) return self.searchData.count;
        else return 0;
    }
    else {
        if (self.categoryData.count > 0 && section == 0) {
            return self.categoryData.count;
        }
        else {
            return self.data.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.searchController.searchResultsTableView && self.categoryData.count > 0 && indexPath.section == 0) {
        return [self categoryCellForTableView:tableView withIndexPath:indexPath];
    }
    else {
        return [self artCellForTableView:tableView withIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchController.searchResultsTableView) {
        FTMediaRSSParserFeedItem *item = [self.searchData objectAtIndex:indexPath.row];
        [self showDetailFor:item inDataSet:self.searchData];
    }
    else {
        if (self.categoryData.count > 0 && indexPath.section == 0) {
            NSDictionary *category = [self.categoryData objectAtIndex:indexPath.row];
            FTDeviationsViewController *c = [[FTDeviationsViewController alloc] init];
            [c setTitle:[category objectForKey:@"name"]];
            [c setCategoryCode:[category objectForKey:@"path"]];
            [c setCategoryData:[category objectForKey:@"subcategories"]];
            [self.navigationController pushViewController:c animated:YES];
        }
        else {
            FTMediaRSSParserFeedItem *item = [self.data objectAtIndex:indexPath.row];
            [super showDetailFor:item inDataSet:self.data];
        }
    }
}


@end
