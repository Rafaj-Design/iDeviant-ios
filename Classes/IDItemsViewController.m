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

- (void)getDataForParams:(NSString *)params {

		NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=%@", params] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *feedURL = [NSURL URLWithString:url];
	
		feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		feedParser.delegate = self;
		feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
}


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

#pragma mark Table view delegate & data source methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView itemCellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super launchItemInTableView:tableView withIndexPath:indexPath];
}

#pragma mark View delegate methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self createTableView];
	
	if (predefinedSearchTerm) [super getDataForSearchString:predefinedSearchTerm];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark Memory management

- (void)dealloc {
	[predefinedSearchTerm release];
	[predefinedCategory release];
    [super dealloc];
}


@end
