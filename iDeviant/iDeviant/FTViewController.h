//
//  FTViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTArtCell.h"
#import "MWFeedParser.h"


@interface FTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MWFeedParserDelegate>

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, readonly) BOOL isLandscape;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *searchData;
@property (nonatomic) BOOL searchIsEnabled;

@property (nonatomic, strong) NSString *categoryCode;

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;

@property (nonatomic) BOOL needsCloseButton;

// Positioning
- (CGFloat)screenHeight;
- (CGFloat)screenWidth;
- (BOOL)isTablet;
- (BOOL)isBigPhone;
- (BOOL)isRetina;
- (BOOL)isOS7;

// Creating and configuring view
- (void)setupView;

- (void)createSearchBarWithSearchOptionTitles:(NSArray *)searchOptions;
- (void)createSearchBar;
- (void)createSearchController;

- (void)createTableView;
- (void)fillData;

- (void)showDetailFor:(MWFeedItem *)item inDataSet:(NSArray *)data;

- (void)createAllElements;

// Data
- (void)getDataForParams:(NSString *)params;
- (void)getDataForSearchString:(NSString *)search andCategory:(NSString *)category;
- (void)getDataForCategory:(NSString *)category;
- (void)getDataForSearchString:(NSString *)search;
- (void)getFeedData;

// Alerts
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Cell configuration
- (FTArtCell *)artCellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;
- (void)configureArtCell:(FTArtCell *)cell forIndexPath:(NSIndexPath *)indexPath inTable:(UITableView *)tableView;


@end