//
//  FTStarButton.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTStarButton.h"
#import "FAImageView.h"
#import "FTFavorites.h"


@interface FTStarButton ()

@property (nonatomic, readonly) FAImageView *starView;

@end


@implementation FTStarButton


#pragma mark Creating elements

- (void)createStarImageView {
    _starView = [[FAImageView alloc] initWithFrame:CGRectMake(3, 3, 22, 22)];
    [_starView setUserInteractionEnabled:NO];
    [_starView setImage:nil];
    [_starView.defaultView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_starView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createStarImageView];
}

#pragma mark Settings

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [_starView.defaultView setTextColor:[UIColor colorWithHexString:@"454545" andAlpha:1]];
        [_starView setDefaultIconIdentifier:@"icon-star"];
    }
    else {
        
        [_starView.defaultView setTextColor:[UIColor colorWithHexString:@"454545" andAlpha:0.4]];
        [_starView setDefaultIconIdentifier:@"icon-star-empty"];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}

- (void)setCategoryData:(NSDictionary *)categoryData {
    _categoryData = categoryData;
}

- (void)setFullPath:(NSString *)fullPath {
    _fullPath = fullPath;
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:_categoryData];
    [d setValue:_fullPath forKey:@"fullPath"];
    [self setSelected:[FTFavorites isCategoryInFavorites:d forFeedType:_feedType]];
}

#pragma mark Actions

- (void)didPressButton:(FTStarButton *)sender {
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:_categoryData];
    [d setValue:_fullPath forKey:@"fullPath"];
    if (self.selected) {
        [FTFavorites removeCategoryFromFavorites:d forFeedType:_feedType];
    }
    else {
        [FTFavorites addCategoryToFavorites:d forFeedType:_feedType];
    }

    [self setSelected:!self.selected];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
}


@end
