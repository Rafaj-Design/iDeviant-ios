//
//  IDHomeTableViewCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 10/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDHomeTableViewCell.h"


@implementation IDHomeTableViewCell

@synthesize backgroundImageView;
@synthesize iconImageView;


#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark Memory management

- (void)dealloc {
	[backgroundImageView release];
	[iconImageView release];
    [super dealloc];
}


@end
