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
#import "Configuration.h"


// test
#import "IDDetailTableViewController.h"


//static FTReachability *internetReachable;
//static FTReachability *hostReachable;


@implementation IDViewController

@synthesize data;
@synthesize categoriesData;
@synthesize isLandscape;
@synthesize soundController;
@synthesize itemsToDisplay;
@synthesize isSearchBar;
@synthesize internetActive;
//@synthesize hostActive;
@synthesize message;


#pragma mark Positioning

- (int)recalculateHeightForStatusBar:(int)height {
	BOOL status = YES;
	if (status) {
		height -= 20;
	}
	
	BOOL navigation = YES;
	if ([self.navigationController.navigationBar isTranslucent]) navigation = NO;
	else if ([self.navigationController.navigationBar isHidden]) navigation = NO;
	if (navigation) {
		if (isLandscape) height -= 32;
		else height -= 44;
	}
	return height;
}

- (CGRect)fullScreeniPhoneFrame {
	if (isLandscape) {
		return CGRectMake(0, 0, 480, [self recalculateHeightForStatusBar:320]);
	}
	else {
		return CGRectMake(0, 0, 320, [self recalculateHeightForStatusBar:480]);
	}
}

- (CGRect)fullScreeniPadFormFrame {
    return CGRectMake(0, 0, 540, 620);
}

- (CGRect)fullScreeniPadFrame {
	if (isLandscape) {
		return CGRectMake(0, 0, 1024, [self recalculateHeightForStatusBar:768]);
	}
	else {
		return CGRectMake(0, 0, 768, [self recalculateHeightForStatusBar:1024]);
	}
}

- (CGRect)fullScreenFrame {
	//	if ([FTSystem isTabletSize]) {
	//		return [self fullScreeniPadFrame];
	//	}
	//	else {
	return [self fullScreeniPhoneFrame];
	//	}
}

- (CGRect)frameForMessageLabel {
	CGRect r = [self fullScreenFrame];
	r.size.height = 16;
	if (self.navigationController.navigationBar.alpha == 0) {
		
	}
	else {
		//r.origin.y = self.navigationController.navigationBar.frame.size.height;
	}
	return r;
}

#pragma mark Messages

- (void)displayMessage:(NSString *)text {
	if ([message isHidden]) {
		[message setAlpha:0];
		[message setHidden:NO];
	}
	else return;
	[message setFrame:[self frameForMessageLabel]];
	[message setText:[FTLang get:text]];
	
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

#pragma mark Parsing

- (void)refresh {
	//[self setTitle:@"refreshing"];
    
    //loader when push refresh button

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	
	
	
	
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	[table setUserInteractionEnabled:NO];
	
	[UIView beginAnimations:nil context:nil];
	[table setAlpha:0.3];
	[UIView commitAnimations];
}

- (void)enablingTableEdit:(BOOL)edit {
	
}

- (void)toggleEditTable {
	[table setEditing:!table.editing animated:YES];
	[self enablingTableEdit:table.editing];
	[self enableEditButton];
}

- (void)getDataForParams:(NSString *)params {
	if (internetActive) {
		// Creating the URL
		NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?%@", params] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		// Start download / parse
		NSURL *feedURL = [NSURL URLWithString:url];
		feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		feedParser.delegate = self;
		feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
	}
	else {
		if (kFakeData) {
			[feedParser release];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"fake-data" ofType:@"xml"];
			//NSFileManager *fm = [[NSFileManager alloc] init];
			NSURL *feedURL = [[NSURL alloc] initFileURLWithPath:path];
			feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
			[feedURL release];
			[feedParser setDelegate:self];
			feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
			feedParser.connectionType = ConnectionTypeAsynchronously;
			[feedParser parse];
		}
	}
}

// rss.xml?q=boost:popular+in:photography/architecture/exterior+max_age:8h&type=deviation

- (void)getDataForSearchString:(NSString *)search andCategory:(NSString *)category {
	//[self internetActive];
    //if (internetActive) {
		// Crazy check :)
		[IDAdultCheck checkForUnlock:search];
		
		// Adding search string if any
		NSString *searchString = @"";
		if (search) searchString = [NSString stringWithFormat:@"%@", search];
		

		// Adding category string if any
		NSString *categoryString = @"";
		if (category) if (![category isEqualToString:@""]) categoryString = [NSString stringWithFormat:@"+in:%@", category];
		
		// Creating the URL (special:newest)
		NSString *url = [[NSString stringWithFormat:@"http://backend.deviantart.com/rss.xml?q=%@%@&type=deviation", categoryString, searchString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		// Start download / parse
		NSURL *feedURL = [NSURL URLWithString:url];
		[feedParser release];
		feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		[feedParser setDelegate:self];
		feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
		/*}
		 else {
		 if (kFakeData) {
		 [feedParser release];
		 NSString *path = [[NSBundle mainBundle] pathForResource:@"fake-data" ofType:@"xml"];
		 //NSFileManager *fm = [[NSFileManager alloc] init];
		 NSURL *feedURL = [[NSURL alloc] initFileURLWithPath:path];
		 feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
		 [feedURL release];
		 [feedParser setDelegate:self];
		 feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		 feedParser.connectionType = ConnectionTypeAsynchronously;
		 [feedParser parse];
		 }
		 }*/
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

#pragma mark Reachability notification methods & settings

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
			if (refreshButton) {
				[self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
			}
			if ([data count] == 0) {
				//[self refresh];
			}
		}
		else {
			if (refreshButton) {
				[self.navigationItem setRightBarButtonItem:nil animated:YES];
			}
		}
	}
}

#pragma mark View lifecycle

- (void)doLayoutLocalSubviews {
	// Layout local elements
	[UIView beginAnimations:nil context:nil];
	[backgroundImageView setFrame:[self fullScreenFrame]];
	[table setFrame:[self fullScreenFrame]];
	[message setFrame:[self frameForMessageLabel]];
	[UIView commitAnimations];
}

- (void)doLayoutSubviews {
	
}

-(void) showHideNavbar:(id)sender {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
    // Disallow recognition of tap gestures in the segmented control.
//    if ((touch.view == yourButton)) {//change it to your condition
//        return NO;
//    }
	CGPoint location = [touch locationInView:self.navigationController.navigationBar];
	
	CGRect titleFrame;
	
	for (UIView *view in [[[self navigationController] navigationBar] subviews]) {
		if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationItemView"]) {
			titleFrame = [view frame];
		}
	}
	
	if ((location.x >= CGRectGetMinX(titleFrame)) && (location.x <= CGRectGetMaxX(titleFrame))) {
		if ((location.y >= CGRectGetMinY(titleFrame)) && (location.y <= CGRectGetMaxY(titleFrame))) {
			NSLog(@"within");
			[self.navigationController popToRootViewControllerAnimated:YES];
			return YES;
		}
	}
	
    return NO;
}

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
	
	[self enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg.png"]];
	
	message = [[UILabel alloc] initWithFrame:[self frameForMessageLabel]];
	[message setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_ok_messagebg.png"]]];
	[message setTextColor:[UIColor whiteColor]];
	[message setText:@"Lorem ipsum dolor sit amet"];
	[message setTextAlignment:UITextAlignmentCenter];
	[message setFont:[UIFont boldSystemFontOfSize:10]];
	[self.view addSubview:message];
	[message setHidden:YES];
		
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideNavbar:)];
	[tapGesture setDelegate:(id<UIGestureRecognizerDelegate>)self];
	[self.navigationController.navigationBar addGestureRecognizer:tapGesture];
	[tapGesture release];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    [self doLayoutSubviews];
	[self doLayoutLocalSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
	isLandscape = UIInterfaceOrientationIsLandscape([FTSystem interfaceOrientation]);
	[super viewWillAppear:animated];
	[self doLayoutSubviews];
	[self doLayoutLocalSubviews];
	if (table) [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (searchBarHeader) {
		if ([searchBarHeader isFirstResponder]) {
			[searchBarHeader resignFirstResponder];
			[searchBarHeader setShowsCancelButton:NO animated:YES];
		}
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self checkNetworkStatus:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ([FTSystem isTabletSize]){
        return YES;
    }
	else {
        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation) || toInterfaceOrientation == UIInterfaceOrientationPortrait;
    }
}

#pragma mark Handler for navigating backwards

- (void)dismissMe:(id)sender {
    [self goBack];
}

#pragma mark Managing view controllers

- (void)dismissModalViewController {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
	[modalViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[super presentModalViewController:modalViewController animated:animated];
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Sound controller

- (void)playSound:(NSString *)soundName {
	[soundController playSound:soundName];
}

#pragma mark Background image

- (void)enableBackgroundWithImage:(UIImage *)image {
	if (!backgroundImageView) {
		backgroundImageView = [[UIImageView alloc] initWithFrame:[self fullScreenFrame]];
		[backgroundImageView setBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:backgroundImageView];
		[self.view sendSubviewToBack:backgroundImageView];
	}
	[backgroundImageView setImage:image];
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
	table = [[UITableView alloc] initWithFrame:[self fullScreenFrame] style:style];
	//[table setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[table setDataSource:self];
	[table setDelegate:self];
	[table setBackgroundColor:[UIColor clearColor]];
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
	}
	else {
		UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditTable)];
		[self.navigationItem setRightBarButtonItem:edit animated:YES];
		[edit release];
	}
}

#pragma mark View stuff

- (void)setTitle:(NSString *)newTitle {
	[super setTitle:[FTLang get:newTitle]];
	//[FlurryAPI logEvent:[NSString stringWithFormat:@"Screen: %@", newTitle]];
}

#pragma mark Table view data source & delegate methods

//- (void)setData:(NSArray *)newData {
//	[data release];
//	data = newData;
//	[data retain];
//	[table reloadData];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (isSearchBar) {
		return 44;
	}
	else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		if (isSearchBar) {
			if (!searchBarHeader) {
				searchBarHeader = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
				[searchBarHeader setTintColor:[UIColor lightGrayColor]];
				[searchBarHeader setDelegate:self];
				[searchBarHeader setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				[searchBarHeader setPlaceholder:[FTLang get:@"searchplaceholder"]];
			}
			return searchBarHeader;
		}
	}
	return nil;
}

- (void)getDataFromBundlePlist:(NSString *)plist {
	NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@""];
	NSArray *arr = [NSArray arrayWithContentsOfFile:path];
	[self setData:arr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
	
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
		[cell setBackgroundColor:[UIColor whiteColor]];
		[cell.cellTitleLabel setText:[d objectForKey:@"name"]];		
		[cell.cellTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLTPro-LtCn" size:19]];
    }
	
	[self configureCell:cell withIndexPath:indexPath forTableView:tableView];
	if ([[d objectForKey:@"subcategories"] count] == 0) {
		if (!internetActive) {
			[cell.accessoryArrow setImage:[UIImage imageNamed:@"DA_arrow-x.png"]];
		}
	}
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Show detail
	IDDetailTableViewController *detail = [[IDDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detail.item = (MWFeedItem *)[data objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
	
	// Deselect
	[table deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Memory management

- (void)recreateElements {
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	[self recreateElements];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [super dealloc];
}

#pragma mark Parsing delegate methods (MWFeedParserDelegate)

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
	[parsedItems removeAllObjects];
	[table setUserInteractionEnabled:NO];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	//[self setTitle:info.title];
	
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	//NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];	
    NSLog(@"parsed item: %@", item);
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSArray *arr = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[self setData:[parsedItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:arr]]];
	[arr release];
	
	[self enableTable];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//[self setData:nil];
	[table reloadData];
	[imageView stopAnimating];
    [imageView setHidden:YES];
	[self enableRefreshButton];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
	[self setTitle:@"failed"];
	[self setData:[NSArray array]];
	[parsedItems removeAllObjects];
	
	[self enableTable];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Search bar delegate

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
  

    NSString *searchinpopular = [NSString stringWithFormat:@"boost:popular+%@",[searchBarHeader text]]; 
	[self getDataForSearchString:searchinpopular andCategory:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBarHeader setShowsCancelButton:NO animated:YES];
	[searchBarHeader resignFirstResponder];
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
	}
	else {
		if (internetActive) {
			IDJustItemsViewController *c = [[IDJustItemsViewController alloc] init];
			[c inheritConnectivity:internetActive];
			[c setJustCategory:[currentCategoryPath stringByAppendingPathComponent:[d objectForKey:@"path"]]];
			[c setTitle:[d objectForKey:@"name"]];
			[self.navigationController pushViewController:c animated:YES];
			[c release];
		}
	}
}

- (void)launchItemInTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MWFeedItem *item = [data objectAtIndex:indexPath.row];
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	for (MWFeedItem *i in data) {
		NSLog(@"Title: %@", i.title);
		[arr addObject:i];
	}
	BOOL canAccess = YES;
	if ([item.rating isEqualToString:@"adult"]) {
		if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;
	}
	if (canAccess) {
		if ([item.contents count] > 0) {
			if (item.text) {
				IDDocumentDetailViewController *c = [[IDDocumentDetailViewController alloc] init];
				[c inheritConnectivity:internetActive];
				NSString *tempPath = [[NSBundle mainBundle] pathForResource:@"document-template" ofType:@"html"];
				NSString *temp = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
				NSDictionary *arr = [NSDictionary dictionaryWithObject:item.text forKey:@"{CONTENT}"];
				NSString *text = [FTText parseCodes:arr inTemplate:temp];
				[c setContent:text];
				[self.navigationController pushViewController:c animated:YES];
				[c release];
			}
			else {
				IDImageDetailViewController *c = [[IDImageDetailViewController alloc] init];
				[c inheritConnectivity:internetActive];
				[c setCurrentIndex:indexPath.row];
				[c setListData:arr];
				//[c.data retain];
				[c setImageUrl:[[item.contents objectAtIndex:0] objectForKey:@"url"]];
				[self.navigationController pushViewController:c animated:YES];
				[c release];
			}
		}
	}
	else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	[arr release];
	
	if (kDebugCauseCrash) {
		[UIView animateWithDuration:0.7 animations:^{
			self.view.alpha = 0.0;
		} completion:^(BOOL finished) {
			NSLog(@"Crashing...");
#ifndef __clang_analyzer__
			CFRelease(NULL);
#endif
		}];
	}
}


@end
