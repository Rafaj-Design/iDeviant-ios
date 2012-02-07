//
//  IDViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSystem.h"
#import "FTSounds.h"
#import "MWFeedParser.h"
#import "UINavigationBar+IDTools.h"
#import "UIView+Layout.h"
//#import "IDLang.h"
//#import "FlurryAPI.h"
#import "FTReachability.h"

@interface IDViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate> {
	
	NSArray *data;
	NSArray *categoriesData;
	UITableView *table;
	
	UIImageView *backgroundImageView;
	
	BOOL isLandscape;
	
	FTSounds *soundController;
	
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	
	BOOL isSearchBar;
	UISearchBar *searchBarHeader;
	
//	FTReachability *internetReachable;
	Reachability *internetReachable;
	
	BOOL internetActive;
	//BOOL hostActive;
	
	UIBarButtonItem *refreshButton;
	
	UILabel *message;
	UIActivityIndicatorView *ai;
    UIImageView* imageView;
	
	BOOL popping;
	
	UIView *gestureView;
	UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *categoriesData;

@property (nonatomic, readonly) BOOL isLandscape;

@property (nonatomic, retain) FTSounds *soundController;

@property (nonatomic, retain) NSArray *itemsToDisplay;

@property (nonatomic) BOOL isSearchBar;

@property (nonatomic, readonly) BOOL internetActive;
//@property (nonatomic, readonly) BOOL hostActive;

@property (nonatomic, retain) UILabel *message;

@property (nonatomic) BOOL popping;

@property (nonatomic, retain) UIView *gestureView;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) Reachability *internetReachable;

- (CGRect)fullScreenFrame;

- (CGRect)frameForMessageLabel;

- (void)displayMessage:(NSString *)text;

- (void)setData:(NSArray *)newData;

- (void)getDataFromBundlePlist:(NSString *)plist;

- (void)setTitle:(NSString *)newTitle;

- (void)createTableViewWithSearchBar:(BOOL)searchBar andStyle:(UITableViewStyle)style;

- (void)createTableViewWithSearchBar:(BOOL)searchBar;

- (void)createTableView;

//- (void)enableBackgroundWithImage:(UIImage *)image;

- (void)playSound:(NSString *)soundName;

- (void)doLayoutSubviews;
- (void)doLayoutLocalSubviews;

- (void)enableRefreshButton;
- (void)enableEditButton;
- (void)enablingTableEdit:(BOOL)edit;

// Cells

- (UITableViewCell *)tableView:(UITableView *)tableView categoryCellForRowAtIndexPath:(NSIndexPath *)indexPath withNibFile:(NSString *)nibName;
- (UITableViewCell *)tableView:(UITableView *)tableView itemCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView categoryCellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)launchCategoryInTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath andCurrentCategoryPath:(NSString *)currentCategoryPath;
- (void)launchItemInTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;


// Data

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView;

- (void)getDataForParams:(NSString *)params;

- (void)getDataForSearchString:(NSString *)search andCategory:(NSString *)category;

- (void)getDataForCategory:(NSString *)category;

- (void)getDataForSearchString:(NSString *)search;

- (void)getFeedData;

- (void)inheritConnectivity:(BOOL)internet;



@end
