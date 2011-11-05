//
//  IDSearchController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDSearchController.h"


@implementation IDSearchController


#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[super setIsSearchBar:YES];
	
	[self setTitle:@"search"];
	
	//[super enableRefreshButton];
	//[super getDataForSearchString:@"poem"];
	
	//[super setData:[NSArray arrayWithObject:@""]];
	[super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-search.png"]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Table delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0) {
		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	else {
        if (isLandscape) return 217;
		else return 372;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [data count];
	if (count == 0) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setScrollEnabled:FALSE];
    }
    else{
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tableView setScrollEnabled:TRUE];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0) {
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	else {
		static NSString *cellIdentifier = @"EmptyCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		}
        
		return cell;
	}
}

- (void)doLayoutSubviews {
	[table reloadData];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
