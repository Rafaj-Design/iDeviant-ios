//
//  IDLandscapeFavoritesViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 09/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDLandscapeFavoritesViewController.h"
#import "FTImageView.h"
#import "UIView+Layout.h"
#import "Configuration.h"


@implementation IDLandscapeFavoritesViewController


#pragma mark Creating elements
	
- (void)createGalleryScrollView {
	galleryScrollView = [[FTPagesScrollView alloc] initWithFrame:[super fullScreenFrame]];
	[galleryScrollView positionAtY:20];
	[galleryScrollView setGalleryDataSource:self];
	[galleryScrollView setGalleryDelegate:self];
	[galleryScrollView setDebugMode:kDebug];
	[self.view addSubview:galleryScrollView];
	[galleryScrollView loadContent];
}

- (void)createAllElements {
	[self createGalleryScrollView];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createAllElements];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		[self dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark Gallery data source & delegate methods

- (UIView *)galleryScrollView:(FTPagesScrollView *)gallery requestsPageAtIndex:(int)index {
	FTImageView *v = [[[FTImageView alloc] initWithFrame:gallery.bounds] autorelease];
	[v setImage:[UIImage imageNamed:[NSString stringWithFormat:@"t%d.jpg", index]]];
	//[v setBackgroundColor:[UIColor clearColor]];
	
	UILabel *label = [[UILabel alloc] initWithFrame:gallery.bounds];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor blackColor]];
	[label setFont:[UIFont boldSystemFontOfSize:50]];
	[label setText:[NSString stringWithFormat:@"t%d.jpg", index]];
	[v addSubview:label];
	[label release];
	
	return v;
}

- (int)numberOfPagesForGalleryScrollView:(FTPagesScrollView *)gallery {
	return 20;
}

- (void)galleryScrollView:(FTPagesScrollView *)gallery turnedToPage:(int)index {
	NSLog(@"Did turn page: %d", [gallery currentPageIndex]);
}

#pragma mark Memory management

- (void)dealloc {
	[galleryScrollView release];
    [super dealloc];
}


@end
