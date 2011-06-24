//
//  IDSettingsViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDSettingsViewController.h"


@implementation IDSettingsViewController


#pragma mark View delegate methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view delegate & data source methods

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


@end
