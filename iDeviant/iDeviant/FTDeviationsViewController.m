//
//  FTDeviationsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDeviationsViewController.h"


@interface FTDeviationsViewController ()

@end


@implementation FTDeviationsViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [super createTableView];
    [self createSearchBar];
    [self createSearchController];
}


@end
