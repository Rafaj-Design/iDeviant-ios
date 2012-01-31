//
//  IDViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "IDViewController.h"
#import "IDItemsTableViewCell.h"
#import "IDCategoriesTableViewCell.h"
#import "IDAdultCheck.h"
#import "NSString+HTML.h"
#import "IDFavouriteItems.h"
#import "IDImageDetailViewController.h"
#import "IDDocumentDetailViewController.h"
#import "IDCategoriesViewController.h"
#import "IDJustItemsViewController.h"
#import "FTText.h"
#import "IDConfig.h"

@implementation IDViewController

@synthesize data;
@synthesize categoriesData;
@synthesize isLandscape;
@synthesize soundController;
@synthesize itemsToDisplay;
@synthesize isSearchBar;
@synthesize internetActive;
@synthesize message;

@synthesize popping;
@synthesize gestureView;
@synthesize tapGesture;

@synthesize internetReachable;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	if (!internetReachable) {
		internetReachable = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
	}
	[internetReachable startNotifier];
	
	isLandscape = UIInterfaceOrientationIsLandscape([FTSystem interfaceOrientation]);
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	parsedItems = [[NSMutableArray alloc] init];
	
	[self setData:[NSArray array]];
	
//	[self enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg.png"]];
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-l"]]];
	else
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-p"]]];
	
	message = [[UILabel alloc] initWithFrame:[self frameForMessageLabel]];
	[message setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_ok_messagebg.png"]]];
	[message setTextColor:[UIColor whiteColor]];
	[message setText:@"Lorem ipsum dolor sit amet"];
	[message setTextAlignment:UITextAlignmentCenter];
	[message setFont:[UIFont boldSystemFontOfSize:10]];
	[self.view addSubview:message];
	[message setHidden:YES];
	
	popping = NO;
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[gestureView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	isLandscape = UIInterfaceOrientationIsLandscape([FTSystem interfaceOrientation]);
	
	[self doLayoutSubviews];
	[self doLayoutLocalSubviews];
	
	if (table) 
		[table reloadData];
	
	if (![NSStringFromClass(self.class) isEqualToString:@"IDHomeController"] && ![NSStringFromClass(self.class) isEqualToString:@"IDImageDetailViewController"] && ![NSStringFromClass(self.class) isEqualToString:@"IDDocumentDetailViewController"]) {
		
		gestureView = [[UIView alloc] init];
		
		tapGesture = [[UITapGestureRecognizer alloc] init];
		
		[tapGesture setDelegate:(id<UIGestureRecognizerDelegate>)self];
		[tapGesture addTarget:self action:@selector(showHideNavbar:)];
		
		[gestureView addGestureRecognizer:tapGesture];
		
		for (UIView *v in [[[self navigationController] navigationBar] subviews]) {
			if ([NSStringFromClass([v class]) isEqualToString:@"UINavigationItemView"]) {
				[gestureView setFrame:[v frame]];
				[self.navigationController.navigationBar addSubview:gestureView];
			}
		}
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self checkNetworkStatus:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (searchBarHeader) {
		if ([searchBarHeader isFirstResponder]) {
			[searchBarHeader resignFirstResponder];
			[searchBarHeader setShowsCancelButton:NO animated:YES];
		}
	}
	
	if (![NSStringFromClass(self.class) isEqualToString:@"IDHomeController"] && ![NSStringFromClass(self.class) isEqualToString:@"IDImageDetailViewController"] && ![NSStringFromClass(self.class) isEqualToString:@"IDDocumentDetailViewController"]) {
		[gestureView removeGestureRecognizer:tapGesture];
		[gestureView removeFromSuperview];
		gestureView = nil;
		
		[tapGesture removeTarget:nil action:NULL];
		[tapGesture setDelegate:nil];
		tapGesture = nil;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ([FTSystem isTabletSize])
        return YES;
	else
        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	if (table) {
		if (![NSStringFromClass(self.class) isEqualToString:@"IDHomeSortingViewController"]) {
			NSMutableArray *cells = [[NSMutableArray alloc] init];
			for (NSInteger j = 0; j < [table numberOfSections]; ++j)
			{
				for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
				{
					if ([table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] != nil)
						[cells addObject:[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
				}
			}
			
			for (IDTableViewCell *cell in cells) {
				if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
					[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade-land"]]];
				else {
					[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade"]]];
				}
			}
		}
	}
	
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-l"]]];
	else
		[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_bg-p"]]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    [self doLayoutSubviews];
	[self doLayoutLocalSubviews];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
}

#pragma mark - View stuff

- (void)doLayoutLocalSubviews {
	[UIView beginAnimations:nil context:nil];
	
	[backgroundImageView setFrame:self.view.bounds];
	[table setFrame:self.view.bounds];
	[message setFrame:[self frameForMessageLabel]];
	
	[UIView commitAnimations];
}

- (void)doLayoutSubviews {
	if (table) {
		NSMutableArray *cells = [[NSMutableArray alloc] init];
		for (NSInteger j = 0; j < [table numberOfSections]; ++j)
			for (NSInteger i = 0; i < [table numberOfRowsInSection:j]; ++i)
				if ([table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] != nil)
					[cells addObject:[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
		
		for (IDTableViewCell *cell in cells)
			if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
				[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade-land"]]];
			else
				[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade"]]];
		
		[cells release];
	}
}

-(void) showHideNavbar:(id)sender {
	if (!popping)
		[self.navigationController popToRootViewControllerAnimated:YES];
	
	[self.gestureView removeGestureRecognizer:tapGesture];
	popping = YES;
}

#pragma mark - Positioning

- (CGRect)fullScreenFrame {
	return [[UIScreen mainScreen] applicationFrame];
}

- (CGRect)frameForMessageLabel {
	CGRect frame = self.view.bounds;
	frame.size.height = 16;
	return frame;
}

#pragma mark Messages

- (void)displayMessage:(NSString *)text {
	if ([message isHidden]) {
		[message setAlpha:0];
		[message setHidden:NO];
	} else
		return;
	
	[message setFrame:[self frameForMessageLabel]];
	[message setText:[IDLang get:text]];
	
	[UIView animateWithDuration:0.4
					 animations:^{
						 [message setAlpha:1];
						 if (table) {
							 [table positionAtY:[message height]];
						 }
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:0.8
											   delay:2
											 options:UIViewAnimationOptionAllowUserInteraction
										  animations:^{
											  if (table) {
												  [table positionAtY:0];
											  }
											  [message setAlpha:0];
										  }
										  completion:^(BOOL finished) {
											  [message setHidden:YES];
										  }
						  ];
					 }
	 ];
}

#pragma mark - Refreshing data

- (void)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	[table setUserInteractionEnabled:NO];
	
	[UIView beginAnimations:nil context:nil];
	[table setAlpha:0.3];
	[UIView commitAnimations];
}

#pragma mark - Editing

- (void)enablingTableEdit:(BOOL)edit {
	
}

- (void)toggleEditTable {
	[table setEditing:!table.editing animated:YES];
	[self enablingTableEdit:table.editing];
	[self enableEditButton];
}

#pragma mark - Getting data

- (void)getDataForParams:(NSString *)params {
		NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=%@", params] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSURL *feedURL = [NSURL URLWithString:url];
		feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		feedParser.delegate = self;
		feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
}

- (void)getDataForSearchString:(NSString *)search andCategory:(NSString *)category {	

	[IDAdultCheck checkForUnlock:search];
		
	NSString *searchString = @"";
	
	if (search)
		searchString = [NSString stringWithFormat:@"+%@", search];

	NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=boost:popular%@", searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


	NSString *categoryString = @"";
	
	if (category && (![category isEqualToString:@""])) {
		categoryString = [NSString stringWithFormat:@"+in:%@+sort:time", category];
		url = [url stringByAppendingString:categoryString];
	}
	
	NSURL *feedURL = [NSURL URLWithString:url];
	[feedParser release];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	[feedParser setDelegate:self];
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
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

#pragma mark - Reachability

- (void)inheritConnectivity:(BOOL)internet {
	internetActive = internet;
}

- (void)checkNetworkStatus:(NSNotification *)notice {
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	BOOL previousStatus = internetActive;
	switch (internetStatus) {
		case NotReachable: {
			NSLog(@"The internet is down.");
			internetActive = NO;
			break;
		}
		case ReachableViaWiFi: {
			NSLog(@"The internet is working via WIFI.");
			internetActive = YES;
			break;
		}
		case ReachableViaWWAN: {
			NSLog(@"The internet is working via WWAN.");
			internetActive = YES;
			break;
		}
	}
	
	if (previousStatus != internetActive) {
		[table reloadData];
		if (internetActive) {
			if (refreshButton)
				[self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
			if ([data count] == 0)
				[self refresh];
		} else if (refreshButton)
				[self.navigationItem setRightBarButtonItem:nil animated:YES];
	}
}

#pragma mark Sound controller

- (void)playSound:(NSString *)soundName {
	[soundController playSound:soundName];
}

#pragma mark Settings

- (void)enableTable {
	[table setUserInteractionEnabled:YES];
	[table reloadData];
	
	[UIView beginAnimations:nil context:nil];
	[table setAlpha:1];
	[UIView commitAnimations];
}

- (void)createTableViewWithSearchBar:(BOOL)searchBar andStyle:(UITableViewStyle)style {
	isSearchBar = searchBar;
	table = [[UITableView alloc] initWithFrame:self.view.bounds style:style];
	[table setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[table setAutoresizesSubviews:YES];
	[table setDataSource:self];
	[table setDelegate:self];
	[table setBackgroundColor:[UIColor clearColor]];
	[table setAllowsSelection:YES];
	[self.view addSubview:table];
	[table reloadData];
}

- (void)createTableViewWithSearchBar:(BOOL)searchBar {
	[self createTableViewWithSearchBar:searchBar andStyle:UITableViewStylePlain];
}

- (void)createTableView {
	[self createTableViewWithSearchBar:NO andStyle:UITableViewStylePlain];
}

- (void)enableRefreshButton {
	refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	[self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
}

- (void)enableEditButton {
	if (table.editing) {
		UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditTable)];
		[self.navigationItem setRightBarButtonItem:edit animated:YES];
		[edit release];
	} else {
		UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditTable)];
		[self.navigationItem setRightBarButtonItem:edit animated:YES];
		[edit release];
	}
}

#pragma mark View stuff

- (void)setTitle:(NSString *)newTitle {
	[super setTitle:[IDLang get:newTitle]];
	//[FlurryAPI logEvent:[NSString stringWithFormat:@"Screen: %@", newTitle]];
}

- (void)getDataFromBundlePlist:(NSString *)plist {
	NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@""];
	NSArray *arr = [NSArray arrayWithContentsOfFile:path];
	[self setData:arr];
}

#pragma mark - UITableView stuff

- (void)configureCell:(IDTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade-land"]]];
	else
		[cell.background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_shade"]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView itemCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ItemCell";
    IDItemsTableViewCell *cell = (IDItemsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IDItemsTableViewCell" owner:nil options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[IDItemsTableViewCell class]]) {
                cell = (IDItemsTableViewCell *)oneObject;
                break;
            }
        }
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
		if ([data count] > 0) {
			// Configure the cell.
			MWFeedItem *item = [data objectAtIndex:indexPath.row];
			if (item) {
				// Process
				NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
				NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
				
				// Set
				cell.cellTitleLabel.text = itemTitle;
				[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:16]];
				
				NSMutableString *subtitle = [NSMutableString string];
				if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
				[subtitle appendString:itemSummary];
				
				[cell setDynamicDetailText:subtitle];
				[cell.cellDetailLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:12]];
				
				BOOL canAccess = YES;
				if ([item.rating isEqualToString:@"adult"]) {
					if (![IDAdultCheck canAccessAdultStuff]) {
						canAccess = NO;
						[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
					}
					else {
						[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-heart.png"]];
					}
				}
				else {
					[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-white.png"]];
				}
				if (canAccess) {
					if ([item.thumbnails count] > 0) {
						if (([[[item.thumbnails objectAtIndex:0] objectForKey:@"width"] intValue] <= 200) || ([[[item.thumbnails objectAtIndex:0] objectForKey:@"height"] intValue] <= 200))
							[cell.cellImageView loadImageFromUrl:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]];
					}
				}
				else {
					[cell.cellImageView setImage:[UIImage imageNamed:@"DA_adult-lock.png"]];
				}
			}
		}
    }
	[self configureCell:cell withIndexPath:indexPath forTableView:tableView];
	
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView categoryCellForRowAtIndexPath:(NSIndexPath *)indexPath withNibFile:(NSString *)nibName {
	static NSString *CellIdentifier = @"CategoryCell";
	NSDictionary *d = [categoriesData objectAtIndex:indexPath.row];
    IDCategoriesTableViewCell *cell = (IDCategoriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[IDCategoriesTableViewCell class]]) {
                cell = (IDCategoriesTableViewCell *)oneObject;
                break;
            }
        }
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		[cell setBackgroundColor:[UIColor clearColor]];
		[cell.cellTitleLabel setText:[d objectForKey:@"name"]];		
		[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:19]];
    }
	
	[self configureCell:cell withIndexPath:indexPath forTableView:tableView];
	if ([[d objectForKey:@"subcategories"] count] == 0)
		if (!internetActive)
			[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
	
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView categoryCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self tableView:tableView categoryCellForRowAtIndexPath:indexPath withNibFile:@"IDCategoriesTableViewCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	[self configureCell:cell withIndexPath:indexPath forTableView:tableView];
	return cell;
}

- (void)launchCategoryInTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath andCurrentCategoryPath:(NSString *)currentCategoryPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *d = [categoriesData objectAtIndex:indexPath.row];
	
	if ([[d objectForKey:@"subcategories"] count] > 0) {
		IDCategoriesViewController *c = [[IDCategoriesViewController alloc] init];
		[c inheritConnectivity:internetActive];
		[c setCurrentCategory:d];
		[c setCurrentCategoryPath:[currentCategoryPath stringByAppendingPathComponent:[d objectForKey:@"path"]]];
		[c setTitle:[d objectForKey:@"name"]];
		[c setCategoriesData:[d objectForKey:@"subcategories"]];
		[self.navigationController pushViewController:c animated:YES];
		[c release];
	} else
		if (internetActive) {
			IDJustItemsViewController *c = [[IDJustItemsViewController alloc] init];
			[c inheritConnectivity:internetActive];
			[c setJustCategory:[currentCategoryPath stringByAppendingPathComponent:[d objectForKey:@"path"]]];
			[c setTitle:[d objectForKey:@"name"]];
			[self.navigationController pushViewController:c animated:YES];
			[c release];
		}
}

- (void)launchItemInTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MWFeedItem *item = [data objectAtIndex:indexPath.row];
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	for (MWFeedItem *i in data) {
		[arr addObject:i];
	}
	
	BOOL canAccess = YES;
	
	if ([item.rating isEqualToString:@"adult"])
		if (![IDAdultCheck canAccessAdultStuff]) 
			canAccess = NO;
	
	if (canAccess) {
		if ([item.contents count] > 0) {
			if (item.text) {
				IDDocumentDetailViewController *c = [[IDDocumentDetailViewController alloc] init];
				[c setTitle:[item title]];
				[c inheritConnectivity:internetActive];
				NSString *tempPath = [[NSBundle mainBundle] pathForResource:@"document-template" ofType:@"html"];
				NSString *temp = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
				NSDictionary *arr = [NSDictionary dictionaryWithObject:item.text forKey:@"{CONTENT}"];
				NSString *text = [FTText parseCodes:arr inTemplate:temp];
				[c setContent:text];
				[self.navigationController pushViewController:c animated:YES];
				[c release];
			} else {
				IDImageDetailViewController *c = [[IDImageDetailViewController alloc] init];
				[c inheritConnectivity:internetActive];
				[c setCurrentIndex:indexPath.row];
				[c setListData:arr];
				//[c.data retain];
				[c setImageUrl:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]];
				[self.navigationController pushViewController:c animated:YES];
				[c release];
			}
		}
	} else
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[arr release];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (isSearchBar)
		return 44;
	else
		return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0)
		if (isSearchBar) {
			if (!searchBarHeader) {
				searchBarHeader = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
				[searchBarHeader setTintColor:[UIColor lightGrayColor]];
				[searchBarHeader setDelegate:self];
				[searchBarHeader setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				[searchBarHeader setPlaceholder:[IDLang get:@"searchplaceholder"]];
			}
			return searchBarHeader;
		}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[table deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
//	NSLog(@"Started Parsing: %@", parser.url);
	[parsedItems removeAllObjects];
	[table setUserInteractionEnabled:NO];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//	NSLog(@"Parsed Feed Info: “%@”", info.title);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item) 
		[parsedItems addObject:item];	
//    NSLog(@"parsed item: %@", item);
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
//	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSArray *arr = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[self setData:[parsedItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:arr]]];
	[arr release];
	
	[self enableTable];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[table reloadData];
	[imageView stopAnimating];
    [imageView setHidden:YES];
	[self enableRefreshButton];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
//	NSLog(@"Finished Parsing With Error: %@", error);
	[self setData:[NSArray array]];
	[parsedItems removeAllObjects];
	
	[self enableTable];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[searchBarHeader setShowsCancelButton:YES animated:YES];
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBarHeader setShowsCancelButton:NO animated:YES];
	[searchBarHeader resignFirstResponder];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    int i;
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (i=1; i<=40; i++) {
        NSString *str = [NSString stringWithFormat:@"search_anim_%i@2x.png", i];
        UIImage* img = [UIImage imageNamed:str];
        [imgs addObject:img];
    }
    NSArray *images = [NSArray arrayWithArray:imgs];
    [imgs release];
    
	[imageView setHidden:NO];
    [imageView setAnimationImages:images];
    [imageView startAnimating];

	[self getDataForSearchString:[searchBarHeader text] andCategory:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBarHeader setShowsCancelButton:NO animated:YES];
	[searchBarHeader resignFirstResponder];
}

#pragma mark - Memory management

- (void)dealloc {
	[table release];
	[data release];
	[categoriesData release];
	[backgroundImageView release];
	[formatter release];
	[parsedItems release];
	[itemsToDisplay release];
	[feedParser cancelParsing];
	[feedParser release];
	[searchBarHeader release];
	[internetReachable release];
	[refreshButton release];
	[message release];
	[gestureView release];
	[tapGesture release];
	
    [super dealloc];
}

@end
