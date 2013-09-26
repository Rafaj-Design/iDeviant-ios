//
//  FTHomeCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeCell.h"


@implementation FTHomeCell


#pragma mark Creating elements

- (void)createImageView {
    [super createImageView];
    
    [self.cellImageView setFrame:CGRectMake(17, 27, 63, 63)];
    [self.cellImageView.layer setCornerRadius:(self.cellImageView.width / 2)];
    [self.cellImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.cellImageView setImage:[UIImage imageNamed:@"kitten.jpg"]];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.accessoryView setAlpha:0.5];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
}


@end
