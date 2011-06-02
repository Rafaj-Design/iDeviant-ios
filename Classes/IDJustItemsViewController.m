//
//  IDJustItemsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 28/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDJustItemsViewController.h"


@implementation IDJustItemsViewController

@synthesize justCategory;
@synthesize justGallery;
@synthesize justSearch;


#pragma mark Initialization

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[super enableRefreshButton];
	
	if (justCategory) [super getDataForCategory:justCategory];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
	[justCategory release];
	[justGallery release];
	[justSearch release];
    [super dealloc];
}


@end
