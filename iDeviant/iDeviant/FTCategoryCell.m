//
//  FTCategoryCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTCategoryCell.h"
#import "FTStarButton.h"


@interface FTCategoryCell ()

@property (nonatomic, readonly) FTStarButton *starButton;

@end


@implementation FTCategoryCell


#pragma mark Creating elements

- (void)createStarButton {
    _starButton = [FTStarButton buttonWithType:UIButtonTypeCustom];
    [_starButton setFrame:CGRectMake(263, 8, 28, 28)];
    [self addSubview:_starButton];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createStarButton];
}

#pragma mark Settings

- (void)setCategoryData:(NSDictionary *)categoryData {
    _categoryData = categoryData;
}

- (void)setFeedType:(FTConfigFeedType)feedType {
    _feedType = feedType;
    [_starButton setFeedType:_feedType];
    [_starButton setCategoryData:_categoryData];
}

#pragma mark Initialization

+ (FTCategoryCell *)categoryCellForTable:(UITableView *)tableView withTitle:(NSString *)title andData:(NSDictionary *)categoryData {
    static NSString *cellId = @"categoryCellId";
    FTCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FTCategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell setCategoryData:categoryData];
    [cell.textLabel setText:title];
    return cell;
}


@end
