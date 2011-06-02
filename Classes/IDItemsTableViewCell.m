//
//  IDItemsTableViewCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 10/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDItemsTableViewCell.h"


@implementation IDItemsTableViewCell


#pragma mark Initialization

- (void)doInit {
	[super doInit];
	[cellImageView setFrame:CGRectMake(6, 6, 70, 70)];
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}


@end

