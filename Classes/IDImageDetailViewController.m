//
//  IDImageDetailViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDImageDetailViewController.h"
#import "UIView+Layout.h"
#import "iDeviantAppDelegate.h"
#import "FTImagePage.h"


#define kIDImageDetailViewControllerMaxAlpha				0.6f


@implementation IDImageDetailViewController

@synthesize mainView;
@synthesize imageUrl;
@synthesize currentIndex;
@synthesize delegate;


#pragma mark Positioning

- (CGRect)frameForToolbar {
	CGRect r = [super fullScreenFrame];
	r.origin.y = (r.size.height - 44);
	r.size.height = 44;
	return r;
}

- (CGRect)getFrameForPage {
	if (isLandscape) return CGRectMake(0, 0, 480, 300);
	else return CGRectMake(0, 0, 320, 460);
}

#pragma mark Settings

- (void)setListData:(NSArray *)array {
	listThroughData = array;
	[listThroughData retain];
}

#pragma mark Memory management

- (void)dealloc {
	[mainView release];
	[imageUrl release];
	[bottomBar release];
	[ai release];
	[message release];
	[listThroughData release];
    [super dealloc];
}

#pragma Display stuff

- (void)updateTitle {
	NSString *t = [NSString stringWithFormat:@"%d / %d", (currentIndex + 1), [listThroughData count]];
	[self setTitle:t];
}

#pragma mark Generating pages

- (FTPage *)pageForIndex:(int)index {
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"wallpaper"] ofType:@"jpg"];
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
	if (!image) return nil;
	FTImagePage *page = [[[FTImagePage alloc] initWithFrame:[self getFrameForPage]] autorelease];
	[page setPageIndex:index];
	[page.imageView setImage:image];
	return page;
}

#pragma mark Navigation animation

- (void)finishNavigationToggle {
	if (bottomBar.alpha == 0) {
		[self.navigationController.navigationBar setHidden:YES];
		[bottomBar setHidden:YES];
	}
}

- (void)toggleNavigationVisibility {
	float a = 0.0;
	float alpha = self.navigationController.navigationBar.alpha;
	if (alpha == 0.0) {
		a = kIDImageDetailViewControllerMaxAlpha;
		
		[self.navigationController.navigationBar setHidden:NO];
		[bottomBar setHidden:NO];
	}
	else if (alpha == 1.0) a = 0.0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishNavigationToggle)];
	[self.navigationController.navigationBar setAlpha:a];
	[bottomBar setAlpha:a];
	[message setFrame:[super frameForMessageLabel]];
	[UIView commitAnimations];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
	[self.view setBackgroundColor:[UIColor blackColor]];
	
    [super viewDidLoad];
	[self.navigationController.navigationBar setTranslucent:YES];
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:kIDImageDetailViewControllerMaxAlpha];
	[UIView commitAnimations];
	
	UIBarButtonItem *favsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didClickActionButton:)];
	[self.navigationItem setRightBarButtonItem:favsButton];
	[favsButton release];
	
	FTPage *page = [self pageForIndex:currentIndex];
	mainView = [[FTPageScrollView alloc] initWithFrame:[super fullScreenFrame]];
	[mainView setBackgroundColor:[UIColor redColor]];
	[mainView setDummyPageImage:[UIImage imageNamed:@"dummy.png"]];
	[mainView setInitialPage:page withDelegate:self];
	//[pageScroll setPageScrollDelegate:self];
	[mainView setPage:page pageCount:0 animate:YES];
	[self.view addSubview:mainView];
	
	
	
//	[mainView setZoomDelegate:self];
//	[mainView loadImageFromUrl:imageUrl];
	
	UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewTwice:)];
	[doubletap setNumberOfTapsRequired:2];
	[mainView addGestureRecognizer:doubletap];
	[doubletap release];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewOnce:)];
	[tap requireGestureRecognizerToFail:doubletap];
	[mainView addGestureRecognizer:tap];
	[tap release];
	
	bottomBar = [[FTToolbar alloc] initWithFrame:[self frameForToolbar]];
	[self.view addSubview:bottomBar];
	
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickActionButton:)];
	[bottomBar setItems:[NSArray arrayWithObjects:actionButton, nil]];
	[actionButton release];
	
//	ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//	[ai setHidesWhenStopped:YES];
//	[ai startAnimating];
//	[self.view addSubview:ai];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self toggleNavigationVisibility];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[super enableBackgroundWithImage:nil];
	[self updateTitle];
	//[mainView setPage:[self pageForIndex:currentIndex] pageCount:0 animate:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setTranslucent:NO];
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:1.0];
	[UIView commitAnimations];
}

#pragma mark Layout

- (void)doLayoutSubviews {
	[UIView beginAnimations:nil context:nil];
	[mainView setFrame:[super fullScreenFrame]];
	[bottomBar setFrame:[self frameForToolbar]];
	[ai centerInSuperView];
	[UIView commitAnimations];
	
	[mainView reload];
}

#pragma mark Gesture recognizers

- (void)didTapViewOnce:(UITapGestureRecognizer *)recognizer {
	[self toggleNavigationVisibility];
}

- (void)didTapViewTwice:(UITapGestureRecognizer *)recognizer {
	
}

#pragma mark Image loading

- (void)imageZoomViewDidFinishLoadingImage:(FTImageZoomView *)zoomView {
	[UIView animateWithDuration:0.6
					 animations:^{
						 [ai setAlpha:0];
					 }
					 completion:^(BOOL finished) {
						 [ai stopAnimating];
					 }
	 ];
}

#pragma mark Actions methods

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)info {
	[self displayMessage:@"imagesavedtothegallery"];
}

- (void)saveCurrentImageToGallery {
//	UIImage *myImage = mainView.imageView.image;
//	UIImageWriteToSavedPhotosAlbum(myImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	[FlurryAPI logEvent:@"Func: Saving image"];
}

- (void)postCurrentImageOnFacebook {
	iDeviantAppDelegate *appDelegate = (iDeviantAppDelegate *)[UIApplication sharedApplication].delegate;
	if (![appDelegate.facebook isSessionValid]) [appDelegate.facebook authorize:nil delegate:appDelegate];
	[FlurryAPI logEvent:@"Func: Facebooking image"];
}

- (void)emailCurrentImage {
	[FlurryAPI logEvent:@"Func: Emailing image"];
}

#pragma mark Actions

- (void)didClickActionButton:(UIBarButtonItem *)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[FTLang get:@"actionswithimagetitle"] delegate:self cancelButtonTitle:[FTLang get:@"cancelbutton"] destructiveButtonTitle:nil otherButtonTitles:[FTLang get:@"savetogalleryit"], [FTLang get:@"facebookit"], [FTLang get:@"emailit"], [FTLang get:@"tweetpicit"], nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Did click button at index: %d", buttonIndex);
	if (buttonIndex == 0) {
		// Save to gallery
		[self saveCurrentImageToGallery];
	}
	else if (buttonIndex == 1) {
		[self postCurrentImageOnFacebook];
	}
	else if (buttonIndex == 2) {
		[self emailCurrentImage];
	}
}

#pragma mark Page scroll view delegate & data source methods

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	return [self pageForIndex:(currentIndex - 1)];
}

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	return [self pageForIndex:(currentIndex + 1)];
}

- (void)pageScrollView:(FTPageScrollView *)scrollView offsetDidChange:(CGPoint)offset {
	
}

- (CGSize)pageScrollView:(FTPageScrollView *)scrollView sizeForPage:(CGSize)size {
	return [self getFrameForPage].size;
}

- (void)dummyScrollInPageScrollViewDidFinish:(FTPageScrollView *)scrollView {
	NSLog(@"dummyScrollInPageScrollViewDidFinish:");
}

- (void)pageScrollView:(FTPageScrollView *)scrollView didMakePageCurrent:(FTPage *)page {
	currentIndex = page.pageIndex;
	NSLog(@"didMakePageCurrent: %d", currentIndex);
	[self updateTitle];
}


@end
