//
//  FTGenericPageViewController.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 01/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTGenericPageViewController.h"


@implementation FTGenericPageViewController

@synthesize contentView;

#pragma mark Memory management

- (void)dealloc {
	[contentView release];
    [super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
