//
//  FTViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTArtCell.h"


@interface FTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, readonly) BOOL isLandscape;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *searchData;

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

// Positioning
- (CGFloat)screenHeight;
- (CGFloat)screenWidth;
- (BOOL)isTablet;
- (BOOL)isBigPhone;
- (BOOL)isRetina;
- (BOOL)isOS7;

// Creating and configuring view
- (void)setupView;

- (void)createSearchBar;
- (void)createSearchController;

- (void)createTableView;
- (void)fillData;

- (void)createAllElements;

// Alerts
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Cell configuration
- (void)configureArtCell:(FTArtCell *)cell forIndexPath:(NSIndexPath *)indexPath inTable:(UITableView *)tableView;


@end
