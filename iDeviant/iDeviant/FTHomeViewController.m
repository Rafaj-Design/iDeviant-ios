//
//  FTHomeViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeViewController.h"
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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


@end
