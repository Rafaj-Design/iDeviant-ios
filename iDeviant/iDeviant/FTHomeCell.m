//
//  FTHomeCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeCell.h"


@implementation FTHomeCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setYOrigin:35];
    [self.textLabel setFont:[UIFont systemFontOfSize:17]];
    
    [self.detailTextLabel setYOrigin:61];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
}

#pragma mark Creating elements

- (void)createImageView {
    [super createImageView];
    
    [self.cellImageView setFrame:CGRectMake(17, 26, 63, 63)];
    [self.cellImageView.layer setCornerRadius:(self.cellImageView.width / 2)];
    [self.cellImageView setBackgroundColor:[UIColor colorWithHexString:@"B0C2B4" andAlpha:0.1]];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
}


@end
