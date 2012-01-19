//
//  IDTableViewCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDTableViewCell.h"


@implementation IDTableViewCell

@synthesize accessoryArrow;
@synthesize itemPath;
@synthesize categoryPath;


#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [super enableBackgroundWithImage:nil];
		[background setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[super enableBackgroundWithImage:nil];
		[background setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark Memory management

- (void)dealloc {
	[accessoryArrow release];
	[itemPath release];
	[categoryPath release];
    [super dealloc];
}


@end
