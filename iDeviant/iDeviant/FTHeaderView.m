//
//  FTHeaderView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHeaderView.h"


@interface FTHeaderView ()

@property (nonatomic, readonly) UILabel *titleLabel;

@end


@implementation FTHeaderView


#pragma mark Creating elements

- (void)createTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (56 - 6 - 16), (self.width - 30), 16)];
    [_titleLabel setText:_title];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[UIColor colorWithHexString:@"3A4740"]];
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_titleLabel];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTitle];
}

#pragma mark Settings

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleLabel setText:_title];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setBackgroundColor:[UIColor colorWithHexString:@"C0CDBF" andAlpha:0.95]];
}


@end
