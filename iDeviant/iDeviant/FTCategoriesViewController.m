//
//  FTCategoriesViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTCategoriesViewController.h"


@interface FTCategoriesViewController ()

@end


@implementation FTCategoriesViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    [super setCategoryData:data];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createSearchBar];
    [super createSearchController];
}


@end
