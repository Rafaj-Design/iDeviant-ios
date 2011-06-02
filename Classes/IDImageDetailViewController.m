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


#define kIDImageDetailViewControllerMaxAlpha				0.6f


@implementation IDImageDetailViewController

@synthesize mainView;
@synthesize imageUrl;


#pragma mark Positioning

- (CGRect)frameForToolbar {
	CGRect r = [super fullScreenFrame];
	r.origin.y = (r.size.height - 44);
	r.size.height = 44;
	return r;
}

- (CGRect)frameForMessageLabel {
	CGRect r = [super fullScreenFrame];
	r.size.height = 16;
	if (self.navigationController.navigationBar.alpha == 0) {
		
	}
	else {
		r.origin.y = self.navigationController.navigationBar.frame.size.height;
	}
	return r;
}

#pragma mark Memory management

- (void)dealloc {
	[mainView release];
	[imageUrl release];
	[bottomBar release];
	[ai release];
	[message release];
    [super dealloc];
}

#pragma mark Messages

- (void)displayMessage:(NSString *)text {
	if ([message isHidden]) {
		[message setAlpha:0];
		[message setHidden:NO];
	}
	[message setFrame:[self frameForMessageLabel]];
	[message setText:[FTLang get:text]];
	
	[UIView animateWithDuration:0.4
					 animations:^{
						 [message setAlpha:1];
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:0.8
											   delay:2
											 options:UIViewAnimationOptionAllowUserInteraction
										  animations:^{
											  [message setAlpha:0];
										  }
										  completion:^(BOOL finished) {
											  [message setHidden:YES];
										  }
						  ];
					 }
	 ];
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
	[message setFrame:[self frameForMessageLabel]];
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
	
	mainView = [[FTImageZoomView alloc] initWithFrame:[super fullScreenFrame]];
	[self.view addSubview:mainView];
	[mainView setZoomDelegate:self];
	[mainView loadImageFromUrl:imageUrl];
	
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
	
	ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[ai setHidesWhenStopped:YES];
	[ai startAnimating];
	[self.view addSubview:ai];
	
	message = [[UILabel alloc] initWithFrame:[self frameForMessageLabel]];
	[message setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DA_ok_messagebg.png"]]];
	[message setTextColor:[UIColor whiteColor]];
	[message setText:@"Lorem ipsum dolor sit amet"];
	[message setTextAlignment:UITextAlignmentCenter];
	[message setFont:[UIFont boldSystemFontOfSize:10]];
	[self.view addSubview:message];
	[message setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self toggleNavigationVisibility];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[super enableBackgroundWithImage:nil];
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
	[message setFrame:[self frameForMessageLabel]];
	[UIView commitAnimations];
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
	UIImage *myImage = mainView.imageView.image;
	UIImageWriteToSavedPhotosAlbum(myImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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


@end
