//
//  FTDeviationsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDeviationsViewController.h"
#import "FTDeviationsListingViewController.h"
#import "FTDeviationsHeaderView.h"


@interface FTDeviationsViewController ()

@end


@implementation FTDeviationsViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}

#pragma mark Settings

- (void)setCategoryData:(NSArray *)categoryData {
    [super setCategoryData:categoryData];
}

- (void)setCategoryCode:(NSString *)categoryCode {
    [super setCategoryCode:categoryCode];
    [super getDataForCategory:categoryCode];
}

#pragma mark Actions

- (void)refresh {
    
}

#pragma mark Table view delegate & datasource methods

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.categoryData.count > 0) {
        return 56;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.categoryData.count > 0) {
        return 44;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *withItems = [NSString stringWithFormat:@"%@ %@", FTLangGet(@"Deviations from"), self.title];
    NSString *items = ((self.categoryCode.length <= 1) ? FTLangGet(@"Deviations") : withItems);
    FTDeviationsHeaderView *dh = [[FTDeviationsHeaderView alloc] initWithFrame:CGRectMake(0, 60, 320, 56)];
    [dh setBlurTintColor:[UIColor colorWithHexString:@"C0CDBF"]];
    if (self.categoryData.count > 0) {
        if (self.categoryCode.length <= 1) {
            if (section == 0) {
                [dh setTitle:FTLangGet(@"Subcategories")];
            }
        }
        else {
            if (section == 0) {
                [dh setTitle:[NSString stringWithFormat:@"%@ %@", FTLangGet(@"Subcategories in"), self.title]];
            }
        }
    }
    if (!dh.title) {
        [dh setTitle:items];
    }
    return dh;
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
            FTDeviationsListingViewController *c = [[FTDeviationsListingViewController alloc] init];
            [c setFeedType:self.feedType];
            [c setTitle:[category objectForKey:@"name"]];
            if ([category objectForKey:@"fullPath"]) {
                [c setCategoryCode:[category objectForKey:@"fullPath"]];
            }
            else {
                if (self.categoryCode) {
                    [c setCategoryCode:[NSString stringWithFormat:@"%@/%@", self.categoryCode, [category objectForKey:@"path"]]];
                }
                else {
                    [c setCategoryCode:[category objectForKey:@"path"]];
                }
            }
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
