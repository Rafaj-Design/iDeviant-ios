//
//  IDHistoryViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHistoryViewController.h"


@implementation IDHistoryViewController


#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"loading"];
	
	[super enableRefreshButton];
	[super getDataForSearchString:@"nude"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
