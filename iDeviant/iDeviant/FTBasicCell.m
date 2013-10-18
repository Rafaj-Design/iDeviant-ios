//
//  FTBasicCell.m
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"


@implementation FTBasicCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_cellImageView) {
        [self.textLabel setXOrigin:(_cellImageView.right + 16)];
        [self.detailTextLabel setXOrigin:(_cellImageView.right + 16)];
    }
    
    if (_layoutType == FTBasicCellLayoutTypeSmall) {
        [self.textLabel setFont:[UIFont systemFontOfSize:16]];
        [self.textLabel setYOrigin:(self.textLabel.yOrigin + 1)];
        
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:11]];
        [self.detailTextLabel setYOrigin:(self.detailTextLabel.yOrigin - 0)];
    }
    [self.textLabel setTextColor:[UIColor colorWithHexString:@"353535"]];
    [self.detailTextLabel setTextColor:[UIColor colorWithHexString:@"859482"]];
    //[self.textLabel sizeToFit];
}

- (CGFloat)cellHeight {
    return 54;
}

+ (CGFloat)cellHeight {
    return 54;
}

#pragma mark Creating elements

- (void)createAllElements {
    
}

- (void)createImageView {
    _cellImageView = [[FTImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [_cellImageView setClipsToBounds:YES];
    [_cellImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_cellImageView];
}

#pragma mark Initialization

+ (FTBasicCell *)cellForTable:(UITableView *)tableView {
    return nil;
}

- (void)setupView {
    [self setBackgroundColor:[UIColor colorWithHexString:@"D6E0D4"]];
    
    UIView *selectedView = [[UIView alloc] init];
    [selectedView setBackgroundColor:[UIColor colorWithHexString:@"D1DACF"]];
    [self setSelectedBackgroundView:selectedView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self createAllElements];
    }
    return self;
}

#pragma mark Settings

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [self.accessoryView setAlpha:0.2];
    }
}


@end
