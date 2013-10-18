//
//  FTArtCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 26/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTArtCell.h"


@interface FTArtCell ()

@end


@implementation FTArtCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //[self.textLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
    [self.textLabel setFont:[UIFont systemFontOfSize:17]];
    [self.textLabel setYOrigin:4];
    [self.textLabel setWidth:(self.width - 130)];
    
    //[self.detailTextLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
    [self.detailTextLabel setYOrigin:30];
    [self.detailTextLabel setHeight:30];
    [self.detailTextLabel setNumberOfLines:2];
    [self.detailTextLabel setWidth:(self.width - 130)];
    
    [_dateLabel setXOrigin:self.textLabel.xOrigin];
    [_dateLabel sizeToFit];
    
    [_authorLabel sizeToFit];
    [_authorLabel setXOrigin:(_dateLabel.right + 4)];
}

#pragma mark Creating elements

- (void)createLabels {
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, 150, 14)];
    [_dateLabel setText:@"1 hour ago"];
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"A4B1A2"]];
    [_dateLabel setBackgroundColor:[UIColor clearColor]];
    [_dateLabel setFont:[UIFont systemFontOfSize:10]];
    [self addSubview:_dateLabel];
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, 150, 14)];
    [_authorLabel setText:@"by Ondrej \"The\" Cool"];
    [_authorLabel setTextColor:[UIColor colorWithHexString:@"1E6BAC"]];
    [_authorLabel setBackgroundColor:[UIColor clearColor]];
    [_authorLabel setFont:[UIFont systemFontOfSize:10]];
    [self addSubview:_authorLabel];
}

- (void)createImageView {
    [super createImageView];
    
    [self.cellImageView setFrame:CGRectMake(6, 6, 73, 73)];
    [self.cellImageView setBackgroundColor:[UIColor colorWithHexString:@"B0C2B4" andAlpha:0.1]];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
    [self createLabels];
}


@end
