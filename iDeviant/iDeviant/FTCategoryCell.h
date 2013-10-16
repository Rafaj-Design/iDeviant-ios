//
//  FTCategoryCell.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"


typedef NS_ENUM(NSInteger, FTCategoryCellStatus) {
    FTCategoryCellStatusInactive,
    FTCategoryCellStatusSelected
};


@interface FTCategoryCell : FTBasicCell

@property (nonatomic, strong) NSDictionary *categoryData;

+ (FTCategoryCell *)categoryCellForTable:(UITableView *)tableView withTitle:(NSString *)title andData:(NSDictionary *)categoryData;


@end
