//
//  FTDeviationsListingViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDeviationsListingViewController.h"


@interface FTDeviationsListingViewController ()

@end


@implementation FTDeviationsListingViewController


#pragma mark Creating elements

- (void)createSearchSelector {
    
}

- (void)createAllElements {
    [super createAllElements];
    [super createSearchBar];
    [super createSearchController];
    [super createRefreshView];
    
    [self createSearchSelector];
}

#pragma mark Table view delegate & data source methods


@end
