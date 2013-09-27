//
//  FTHomeViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTDeviationsViewController.h"
#import "FTHomeCell.h"


@interface FTHomeViewController ()

@end


@implementation FTHomeViewController


#pragma mark Data

- (void)fillData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Home" ofType:@"plist"];
    [super setData:[NSArray arrayWithContentsOfFile:path]];
}

- (NSDictionary *)objectForIndexPath:(NSIndexPath *)indexPath {
    return [super.data objectAtIndex:indexPath.row];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super createTableView];
    [self createSearchBar];
    [self createSearchController];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"iDeviant")];
}

#pragma mark Table view delegate & datasource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchController.searchResultsTableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else {
        static NSString *identifier = @"HomeCell";
        FTHomeCell *cell = (FTHomeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FTHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSDictionary *d = [self objectForIndexPath:indexPath];
        [cell.textLabel setText:FTLangGet([d objectForKey:@"name"])];
        [cell.detailTextLabel setText:FTLangGet([d objectForKey:@"description"]).lowercaseString];
        return cell;
    }
}

- (void)handlePresetControllerForIndexPath:(NSIndexPath *)indexPath {
    id d = [self.data objectAtIndex:indexPath.row];
    if ([d objectForKey:@"controller"]) {
        NSString *className = [d objectForKey:@"controller"];
        Class class = NSClassFromString(className);
        if (class) {
            FTViewController *c = (FTViewController *)[[class alloc] init];
            [c setTitle:FTLangGet([d objectForKey:@"name"])];
            if ([[d objectForKey:@"type"] isEqualToString:@"modal"]) {
                [c setNeedsCloseButton:YES];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
                [self presentViewController:nc animated:YES completion:^{
                    
                }];
            }
            else {
                [self.navigationController pushViewController:c animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchController.searchResultsTableView) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else {
        [self handlePresetControllerForIndexPath:indexPath];
    }
}




@end
