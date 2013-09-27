//
//  FTViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 25/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"
#import "FTDetailViewController.h"
#import "FTImageCache.h"
#import "FTBasicCell.h"


@interface FTViewController ()

@property (nonatomic, strong) MWFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *tempParsedItems;

@end


@implementation FTViewController


#pragma mark Positioning

- (BOOL)isTablet {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (BOOL)isBigPhone {
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

- (CGFloat)screenHeight {
    CGFloat h = 0;
    if ([self isTablet]) {
        h = self.isLandscape ? 748 : 1004;
    }
    else {
        h = self.isLandscape ? 300 : ([self isBigPhone] ? 548 : 460);
    }
    return h;
}

- (CGFloat)screenWidth {
    CGFloat w = 0;
    if ([self isTablet]) {
        w = self.isLandscape ? 1024 : 768;
    }
    else {
        w = self.isLandscape ? ([self isBigPhone] ? 568 : 480) : 320;
    }
    return w;
}

- (void)layoutElements {
    if (_popover) {
        [_popover dismissPopoverAnimated:YES];
    }
}

- (BOOL)isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

- (BOOL)isOS7 {
#if defined __IPHONE_7_0
    return YES;
#else
    return NO;
#endif
    
}

#pragma mark Data

- (void)fillData {
    
}

#pragma mark Data

- (void)getDataForParams:(NSString *)params {
	NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=%@", params] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *feedURL = [NSURL URLWithString:url];
	_feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	[_feedParser setDelegate:self];
    [_feedParser setFeedParseType:ParseTypeFull];
    [_feedParser setConnectionType:ConnectionTypeAsynchronously];
    [_feedParser parse];
}

- (void)getDataForSearchString:(NSString *)search andCategory:(NSString *)category {
	//[IDAdultCheck checkForUnlock:search];
	NSString *searchString = @"";
	if (search) searchString = [NSString stringWithFormat:@"+%@", search];
	NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=boost:popular%@", searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSString *categoryString = @"";
	if (category && (![category isEqualToString:@""])) {
		categoryString = [NSString stringWithFormat:@"+in:%@+sort:time", category];
		url = [url stringByAppendingString:categoryString];
	}
	
	NSURL *feedURL = [NSURL URLWithString:url];
	_feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    [_feedParser setDelegate:self];
    [_feedParser setFeedParseType:ParseTypeFull];
    [_feedParser setConnectionType:ConnectionTypeAsynchronously];
    [_feedParser parse];
}

- (void)getDataForCategory:(NSString *)category {
	[self getDataForSearchString:nil andCategory:category];
}

- (void)getDataForSearchString:(NSString *)search {
	[self getDataForSearchString:search andCategory:nil];
}

- (void)getFeedData {
	[self getDataForSearchString:nil];
}

#pragma mark Creating elements

- (void)createSearchBarWithSearchOptionTitles:(NSArray *)searchOptions {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_searchBar setPlaceholder:FTLangGet(@"searchdesc")];
    [_searchBar setBarTintColor:[UIColor colorWithHexString:@"5E7162"]];
    if (searchOptions) {
        [_searchBar setScopeButtonTitles:searchOptions];
    }
}

- (void)createSearchBar {
    [self createSearchBarWithSearchOptionTitles:nil];
}

- (void)createSearchController {
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [_searchController setDelegate:self];
    [_searchController setSearchResultsDataSource:self];
    [_searchController setSearchResultsDelegate:self];
    [_searchController setDisplaysSearchBarInNavigationBar:NO];
    [_tableView setTableHeaderView:_searchBar];
}

- (void)createTableView {
    [self fillData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingWidthAndHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    
}

#pragma mark Settings

- (void)setNeedsCloseButton:(BOOL)needsCloseButton {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Close") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setLeftBarButtonItem:close];
}

#pragma mark Initialization

- (void)setupView {
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"EFEFF4"]];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    [self createAllElements];
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self isTablet]) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
    }
}

- (void)viewWillLayoutSubviews {
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    [self layoutElements];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    _isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    return YES;
}

#pragma mark Effects

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
    [alert show];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _searchController.searchResultsTableView) {
        if (_searchData) return _searchData.count;
        else return 0;
    }
    else {
        if (_data) return _data.count;
        else return 10;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FTLangGet(@"Remove");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)configureArtCell:(FTArtCell *)cell forIndexPath:(NSIndexPath *)indexPath inTable:(UITableView *)tableView {
    MWFeedItem *item = [(_searchIsEnabled ? _searchData : _data) objectAtIndex:indexPath.row];
    [cell.textLabel setText:item.title];
    [cell.detailTextLabel setText:item.summary];
    [cell.cellImageView setImage:nil];
    
    NSLog(@"Thumbnails: %@", item.thumbnails);
    
    if ([item.thumbnails count] > 0) {
        NSString *url = [[item.thumbnails lastObject] objectForKey:@"url"];
        [[FTImageCache sharedCache] imageForURL:[NSURL URLWithString:url] success:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.cellImageView setImage:image];
                [cell setNeedsLayout];
            });
        } failure:^(NSError *error) {
            
        } progress:^(CGFloat progress) {
            NSLog(@"Progress: %f", progress);
        }];
    }
}

- (FTArtCell *)artCellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"artCellId";
    FTArtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FTArtCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [self configureArtCell:cell forIndexPath:indexPath inTable:tableView];
    return cell;
}

- (FTBasicCell *)basicCellForTableView:(UITableView *)tableView {
    static NSString *cellId = @"cellId";
    FTBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    [cell.textLabel setText:@"Title"];
    [cell.detailTextLabel setText:@"Description"];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _searchController.searchResultsTableView) {
        return [self artCellForTableView:tableView withIndexPath:indexPath];
    }
    else {
        return [self basicCellForTableView:tableView];
    }
}

- (void)showDetailFor:(MWFeedItem *)item inDataSet:(NSArray *)data {
    FTDetailViewController *c = [[FTDetailViewController alloc] init];
    [c setItems:data];
    [c setSelectedIndex:[data indexOfObject:item]];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _searchController.searchResultsTableView) {
        MWFeedItem *item = [_searchData objectAtIndex:indexPath.row];
        [self showDetailFor:item inDataSet:_searchData];
    }
}

#pragma mark Search bar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [_searchController setActive:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    [_searchController setActive:NO animated:YES];
    _searchController.searchBar.text = str;
    _searchData = nil;
    _searchIsEnabled = NO;
    return YES;
}

#pragma mark Search controller delegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    _searchIsEnabled = YES;
    if (searchString.length >= 3) {
        [self getDataForSearchString:searchString andCategory:_categoryCode];
    }
    else {
        [_searchController.searchResultsTableView reloadData];
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"Search option: %ld", (long)searchOption);
    return YES;
}

#pragma mark Feed parser delegate methods

- (void)feedParserDidStart:(MWFeedParser *)parser {
    _tempParsedItems = [NSMutableArray array];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item) {
        [_tempParsedItems addObject:item];
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if (_searchIsEnabled) {
        _searchData = _tempParsedItems;
    }
    else {
        _data = _tempParsedItems;
    }
    
//	for (MWFeedItem *item in _tempParsedItems) {
//		BOOL canAccess = YES;
//		if ([item.rating isEqualToString:@"adult"]) {
//			//if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;
//		}
//		if (canAccess)
//			if (([item.contents count] > 0) && (item.thumbnails.count > 0)) {
//				NSString *contentUrl = [[item.contents objectAtIndex:0] objectForKey:@"url"];
//				NSString *extension = [[contentUrl pathExtension] lowercaseString];
//				
//				if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"]){
//					//[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[item.contents objectAtIndex:0] objectForKey:@"url"]]]];
//					//[itms addObject:item];
//				}
//				else {
//					//[photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]]]];
//					//[itms addObject:item];
//				}
//			}
//	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_tableView reloadData];
    [_searchController.searchResultsTableView reloadData];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    if (_searchIsEnabled) {
        _searchData = [NSArray array];
    }
    else {
        _data = [NSArray array];
    }
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}




@end
