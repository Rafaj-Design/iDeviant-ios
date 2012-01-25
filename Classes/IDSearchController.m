//
//  IDSearchController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDSearchController.h"
#import "Reachability.h"

@implementation IDSearchController

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[super setIsSearchBar:YES];
	
	[self setTitle:[IDLang get:@"search"]];
	
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-p@2x.png"]];
    else
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-l@2x.png"]];
		
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    [imageView setImage:[UIImage imageNamed:@"search_anim_1@2x.png"]];
	
    [self.view addSubview:imageView];
    
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y-50)];
}

-(void)viewWillAppear:(BOOL)animated{
    [imageView setCenter:self.view.center];
	[table setFrame:self.view.bounds];
	
	[self backgroundImage];
	[self doLayoutSubviews];
}

-(void)backgroundImage {
	[backgroundImageView setFrame:[super fullScreenFrame]];
	
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-p@2x.png"]];
    else
        [super enableBackgroundWithImage:[UIImage imageNamed:@"DA_bg-empty-l@2x.png"]];
		
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	if (internetStatus == NotReachable) {
        [imageView setImage:[UIImage imageNamed:@"DD_grandma@2x.png"]];
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			[imageView setFrame: CGRectMake(0.0, 0.0, 200.0, 250.0)];
			[imageView setCenter:self.view.center]; 
		} else {
			[imageView setFrame: CGRectMake(0.0, 0.0, 160.0, 200.0)];
			imageView.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
		}
    } else {
		[imageView setImage:[UIImage imageNamed:@"search_anim_1@2x.png"]];
		[imageView setFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
		[imageView setCenter:self.view.center];
	}
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (!internetActive)
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [ai setCenter:self.view.center];
    [imageView setCenter:self.view.center];
	[table setFrame:self.view.bounds];
	
	[self doLayoutSubviews];
	[self backgroundImage];
}

#pragma mark Table delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0)
		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
	else
        if (isLandscape)
			return 217;
		else
			return 372;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [data count];
	
	if (count == 0) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setScrollEnabled:FALSE];
        [imageView setHidden:NO];
    } else{
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tableView setScrollEnabled:TRUE];
        [imageView setHidden:YES];
    }
	
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([data count] > 0)
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	else {
		static NSString *cellIdentifier = @"EmptyCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        
		return cell;
	}
}

- (void)doLayoutSubviews {
	[table reloadData];
}

#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end
