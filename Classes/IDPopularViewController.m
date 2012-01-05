//
//  IDPopularViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDPopularViewController.h"


@implementation IDPopularViewController


#pragma mark Initialization

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"popular"];
	
	[super enableRefreshButton];
	[super getDataForSearchString:@"special%3Apopular&type=deviation"];
    //boost%3Apopular+meta%3Aall+max_age%3A8h&type=deviation
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end
