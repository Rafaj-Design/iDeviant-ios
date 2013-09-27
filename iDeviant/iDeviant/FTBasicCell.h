//
//  FTBasicCell.h
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTImageView.h"


typedef enum {
    FTBasicCellLayoutTypeSmall,
    FTBasicCellLayoutTypeDefault
} FTBasicCellLayoutType;


@interface FTBasicCell : UITableViewCell

@property (nonatomic) FTBasicCellLayoutType layoutType;
@property (nonatomic, strong) FTImageView *cellImageView;

+ (FTBasicCell *)cellForTable:(UITableView *)tableView;

- (void)createAllElements;
- (void)createImageView;

- (void)setupView;

- (CGFloat)cellHeight;
+ (CGFloat)cellHeight;


@end
