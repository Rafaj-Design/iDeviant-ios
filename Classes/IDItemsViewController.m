	//
//  IDItemsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDItemsViewController.h"
#import "IDImageDetailViewController.h"
#import "IDAdultCheck.h"
#import "NSString+HTML.h"


@implementation IDItemsViewController

@synthesize predefinedSearchTerm;
@synthesize predefinedCategory;

#pragma mark Initialization

- (void)doInit {
	predefinedSearchTerm = nil;
	predefinedCategory = nil;
}

- (id)initWithSearch:(NSString *)search andCategory:(NSString *)category {
	self = [super init];
	if (self) {
		[self doInit];
		
		predefinedCategory = category;
		[predefinedCategory retain];
		
		predefinedSearchTerm = search;
		[predefinedSearchTerm retain];
	}
	return self;
}

- (id)initWithCategory:(NSString *)category {
	self = [super init];
	if (self) {
		[self doInit];
		
		predefinedCategory = category;
		[predefinedCategory retain];
	}
	return self;
}

- (id)initWithSearch:(NSString *)search {
	self = [super init];
	if (self) {
		[self doInit];
		
		predefinedSearchTerm = search;
		[predefinedSearchTerm retain];
	}
	return self;
}

- (id)init {
	self = [super init];
	if (self) {
		[self doInit];
	}
	return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self createTableView];
	
	if (predefinedSearchTerm)
		[super getDataForSearchString:predefinedSearchTerm];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
//	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super launchItemInTableView:tableView withIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView itemCellForRowAtIndexPath:indexPath];
}


#pragma mark - IDImageDetailViewControllerDelegate

- (void)didFinishAtIndex:(NSInteger)index {
	
	NSInteger section = [table numberOfSections];
	if (section > 0)
		section -= 1;
	
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:index inSection:section];
	[table scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark Memory management

- (void)dealloc {
	[predefinedSearchTerm release];
	[predefinedCategory release];
	
    [super dealloc];
}


@end
