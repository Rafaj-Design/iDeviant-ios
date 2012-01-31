//
//  IDDailyDeviationsController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDDailyDeviationsController.h"

@implementation IDDailyDeviationsController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
//	[self setTitle:@"loading"];
	
	[super enableRefreshButton];
//	[super getDataForSearchString:@"icons"];
	[super getDataForParams:@"special:dd"];
}


@end
