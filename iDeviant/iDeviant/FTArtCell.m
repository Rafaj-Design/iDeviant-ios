//
//  FTArtCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 26/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTArtCell.h"


@implementation FTArtCell


#pragma mark Creating elements

- (void)createImageView {
    [super createImageView];
    
    [self.cellImageView setFrame:CGRectMake(6, 6, 73, 73)];
    [self.cellImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.cellImageView setBackgroundColor:[UIColor colorWithHexString:@"B0C2B4" andAlpha:0.1]];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
}


@end
