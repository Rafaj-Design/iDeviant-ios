//
//  FTNoResultsCell.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTNoResultsCell.h"


@implementation FTNoResultsCell


#pragma mark Initialization

+ (UITableViewCell *)noResultCellForTable:(UITableView *)tableView {
    static NSString *identifier = @"noResultCellIdentifier";
    FTNoResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTNoResultsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [self.detailTextLabel setText:FTLangGet(@"No deviations were found ...")];
    [self.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
}


@end
