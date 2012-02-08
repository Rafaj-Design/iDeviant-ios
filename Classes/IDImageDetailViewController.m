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
#import "IDAdultCheck.h"
#import "FTImagePage.h"
#import "FTPageScrollView.h"

#define kIDImageDetailViewControllerMaxAlpha				0.6f

@implementation IDImageDetailViewController

@synthesize delegate;
@synthesize mainView;
@synthesize bottomBar;
@synthesize imagePages;
@synthesize imageUrl;
@synthesize actionButton;
@synthesize currentIndex;
@synthesize listThroughData;
@synthesize shortcutView;
@synthesize currentImage;
@synthesize isOverlayShowing;
@synthesize tap, doubletap;

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	
//	[self.view setFrame:[[UIScreen mainScreen] applicationFrame]];
	self.wantsFullScreenLayout = YES;

	NSLog(@"[[UIScreen mainScreen] applicationFrame]: %@, self.view.frame: %@, self.view.bounds: %@", NSStringFromCGRect([[UIScreen mainScreen] applicationFrame]), NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	[self.navigationController.navigationBar setTranslucent:YES];
//	self.navigationController.wantsFullScreenLayout = NO;
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:kIDImageDetailViewControllerMaxAlpha];
	[UIView commitAnimations];
	
//	[self.navigationController.navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
	
	isOverlayShowing = YES;
	
	imagePages = [[NSMutableArray alloc] init];
	
    FTImagePage *imagePage = [self pageForIndex:currentIndex];
	
	mainView = [[FTPageScrollView alloc] initWithFrame:self.view.bounds];
//	[mainView setAlwaysBounceHorizontal:YES];
    [mainView setDummyPageImage:[UIImage imageNamed:@"dummy.png"]];
    [mainView setInitialPage:imagePage withDelegate:(id<FTPageScrollViewDelegate>)self];
	[mainView setPage:imagePage pageCount:[listThroughData count] animate:YES];
	
	FTPage *rPage = [self pageForIndex:(currentIndex + 1)];
	FTPage *lPage = [self pageForIndex:(currentIndex - 1)];
	
	[mainView performSelector:@selector(setRightPage:) withObject:rPage];
	[mainView performSelector:@selector(setLeftPage:) withObject:lPage];
	
    [mainView setScrollEnabled:YES];
    [mainView setBouncesZoom:YES];
	[mainView setBounces:YES];
    [mainView setPagingEnabled:YES];
	
	[mainView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	[self.view addSubview:mainView];
	
	bottomBar = [[FTToolbar alloc] initWithFrame:[self frameForToolbar]];
	[bottomBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
	[self.view addSubview:bottomBar];
	
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickActionButton:)];
	[bottomBar setItems:[NSArray arrayWithObjects:actionButton, nil]];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"viewDidAppear: self.view.frame: %@, self.view.bounds: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	
	[self toggleNavigationVisibility];

//	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
//	[self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear: self.view.frame: %@, self.view.bounds: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
	[self updateTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
//	[super viewWillDisappear:animated];
	
	[self.navigationController.navigationBar setTranslucent:NO];
	
	[UIView beginAnimations:nil context:nil];
	
	[self.navigationController.navigationBar setAlpha:1.0];
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	for (FTImagePage *p in imagePages) {
		
		[p.imageZoomView setZoomDelegate:nil];
		[p.imageZoomView.imageView setDelegate:nil];
		
		[p.imageZoomView.imageView.imageRequest cancel];
		[p.imageZoomView.imageView.imageRequest setDelegate:nil];
	}

	if (delegate && [delegate respondsToSelector:@selector(didFinishAtIndex:)])
		[delegate performSelector:@selector(didFinishAtIndex:) withObject:currentIndex];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
    if (!isOverlayShowing)
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
    if (!isOverlayShowing) 
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
//	[self.view setFrame:[[UIScreen mainScreen] bounds]];
	[bottomBar setFrame:[self frameForToolbar]];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

#pragma mark - View stuff

- (void)doLayoutSubviews {
	[UIView beginAnimations:nil context:nil];
	
//	[mainView setFrame:[super fullScreenFrame]];
//	[bottomBar setFrame:[self frameForToolbar]];
	[shortcutView centerInSuperView];
	
	[UIView commitAnimations];
	
    [mainView reload];
}

#pragma - mark Positioning

- (CGRect)frameForToolbar {
	NSInteger height;
	if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight))
		height = 34;
	else
		height = 44;
	
	
	CGRect r = self.view.bounds;
	r.origin.y = (r.size.height - height);
	r.size.height = height;
	return r;
}

- (CGRect)getFrameForPage {
	if (isLandscape) 
		return CGRectMake(0, 0, 480, 320);
	else 
		return CGRectMake(0, 0, 320, 480);
}

#pragma - mark Settings

- (void)setListData:(NSArray *)array {
	listThroughData = array;
	[listThroughData retain];
}

#pragma - Display stuff

- (void)updateTitle {
	NSString *t = [NSString stringWithFormat:@"%d / %d", (currentIndex + 1), [listThroughData count]];
	[self setTitle:t];
}

#pragma mark - Generating pages

- (NSString *)urlForItem:(MWFeedItem *)item {
	
	NSString *contentUrl = [[item.contents objectAtIndex:0] objectForKey:@"url"];
	NSString *extension = [[contentUrl pathExtension] lowercaseString];
	
	if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"])
		return [[item.contents objectAtIndex:0] objectForKey:@"url"];
	else
		return [[item.thumbnails objectAtIndex:0] objectForKey:@"url"];
}

- (FTImagePage *)pageForIndex:(int)index {

	if (index < 0 || index >= [listThroughData count]) 
			return nil;

	MWFeedItem *item = [listThroughData objectAtIndex:index];
	
//	FTImagePage *imagePage = [[FTImagePage alloc] initWithFrame:[self getFrameForPage]];
	FTImagePage *imagePage = [[FTImagePage alloc] initWithFrame:self.view.bounds];

	[imagePage setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	[imagePage.activityIndicator centerInSuperView];
	
	BOOL canAccess = YES;
	if ([item.rating isEqualToString:@"adult"])
		if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;

	if (canAccess) {
		if (([item.thumbnails count] > 0) && ([item.contents count] > 0)) {
			[imagePage.imageZoomView.imageView enableDebugMode:YES];
			[imagePage.imageZoomView.imageView setDelegate:(id<FTImageViewDelegate>)self];
			
			[imagePage zoomedImageWithUrl:[NSURL URLWithString:[self urlForItem:item]]];
			
			[imagePage.imageZoomView setShowsHorizontalScrollIndicator:NO];
			[imagePage.imageZoomView setShowsVerticalScrollIndicator:NO];
			
		} else {
			[imagePage release];
			if (currentIndex < index)
				return [self pageForIndex:(index + 1)];
			else
				return [self pageForIndex:(index - 1)];
		}
	}
	else
		if (currentIndex < index)
			return [self pageForIndex:(index + 1)];
		else
			return [self pageForIndex:(index - 1)];
	
	[imagePage setPageIndex:index];
	
	[imagePages addObject:imagePage];
	[imagePage release];
	
	return imagePage;
}

#pragma mark - Navigation animations

- (void)toggleNavigationVisibility {
	NSLog(@"applicationFrame before: %@", NSStringFromCGRect([[UIScreen mainScreen] applicationFrame]));
	
//	[self.navigationController.navigationBar setNeedsLayout];
	
//	[self.navigationController.view setNeedsLayout];
	
//	self.navigationController.navigationBar setFrame:CG
	
//	CGRect frame = self.navigationController.view.frame;

	
	
	
	if (isOverlayShowing)
		isOverlayShowing = NO;
	else
		isOverlayShowing = YES;

	float a = 0.0;
	float alpha = self.navigationController.navigationBar.alpha;

	if (alpha == 0.0) {
		a = kIDImageDetailViewControllerMaxAlpha;
		
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
		[self.navigationController.navigationBar setHidden:NO];
		
		[bottomBar setHidden:NO];
	}
	else if (alpha == 1.0) {
		a = 0.0;
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	} else if (alpha == kIDImageDetailViewControllerMaxAlpha) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	}
	
	
	if (a == 0) {
		[self.navigationController.navigationBar setHidden:YES];
		[bottomBar setHidden:YES];
	} else {
		[self.navigationController.navigationBar setHidden:NO];
		[bottomBar setHidden:NO];
	}
	
//	CGRect frame = self.navigationController.navigationBar.frame;
//	
//	if (frame.origin.y == 0) {
//		frame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
//		self.navigationController.navigationBar.frame = frame;
//	}
	
	[self.navigationController.view setNeedsLayout];
	[[[UIApplication sharedApplication] keyWindow] layoutSubviews];
	

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];

	[self.navigationController.navigationBar setAlpha:a];
	[bottomBar setAlpha:a];
	
	[UIView commitAnimations];
}

- (void)toggleShortcut {
	int alpha = (shortcutView.alpha == 0) ? 1 : 0;
	[UIView beginAnimations:nil context:nil];
	[shortcutView setAlpha:alpha];
	[UIView commitAnimations];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
	[shortcutView.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}



#pragma mark - Gesture recognizers

- (void)didTapViewOnce:(UITapGestureRecognizer *)recognizer {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	if (!shortcutView) 
		[self toggleNavigationVisibility];
	else {
		if (shortcutView.alpha == 0) {
			[self toggleNavigationVisibility];
		} else {
			[UIView beginAnimations:nil context:nil];
			
			[shortcutView setAlpha:0];
			
			[UIView commitAnimations];
		}
	}
}


- (void)didTapViewTwice:(UITapGestureRecognizer *)recognizer {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
	float scale = [[(FTImagePage *)[recognizer view] imageZoomView] zoomScale];
	if (scale != 1.0)
		scale = 1.0;
	else
		scale = 1.5;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[[(FTImagePage *)[recognizer view] imageZoomView] setZoomScale:scale];
	
	[UIView commitAnimations];    
}

#pragma mark - Image loading

- (void)imageViewDidFailLoadingImage:(FTImageView *)imgView withError:(NSError *)error {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)imageView:(FTImageView *)imgView didFinishLoadingImageFromInternet:(UIImage *)image {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
}

- (void)imageZoomViewDidFinishLoadingImage:(FTImageZoomView *)zoomView {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

#pragma mark Actions methods

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)info {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)saveCurrentImageToGallery {

	UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[IDLang get:@"imagesaved"] message:nil
												   delegate:self cancelButtonTitle:[IDLang get:@"OK"] otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
	//[FlurryAPI logEvent:@"Func: Saving image"];
}

- (void)emailCurrentImage {
	//[FlurryAPI logEvent:@"Func: Emailing image"];
	
	MWFeedItem *item = [listThroughData objectAtIndex:currentIndex];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setMailComposeDelegate:self];
    [mc setSubject:[NSString stringWithFormat:@"%@ by iDeviant", [item title]]];
		
	NSString *htmlBody = [NSString stringWithFormat:@"<br/><br/><a href=\"%@\"><img src=\"%@\"/></a><br/><br/>Copyright <a href=\"%@\">%@</a><br/>iDeviant app by <a href=\"http://www.fuerteint.com/\">Fuerte International UK</a><br/><img src=\"http://new.fuerteint.com/wp-content/themes/theme1177/images/logo.png\"/>", [item link], [self urlForItem:item], [item link], [[item credits] objectAtIndex:0]];
    [mc setMessageBody:htmlBody isHTML:YES];
	[mc setModalPresentationStyle:UIModalPresentationPageSheet];
	
	[mc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	
    [super presentModalViewController:mc animated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
//            NSLog(@"Mail send canceled.");
            //[FTTracking logEvent:@"Mail: Mail canceled"];
            break;
        case MFMailComposeResultSaved:
            //[UIAlertView showMessage:IDLangGet(@"Your email has been saved") withTitle:IDLangGet(@"Email")];
            
            //[FTTracking logEvent:@"Mail: Mail saved"];
            break;
        case MFMailComposeResultSent:
//            NSLog(@"Mail sent.");
            //[FTTracking logEvent:@"Mail: Mail sent"];
            //[UIAlertView showMessage:IDLangGet(@"Your email has been sent") withTitle:IDLangGet(@"Email")];
            break;
        case MFMailComposeResultFailed:
//            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            //[UIAlertView showMessage:[error localizedDescription] withTitle:IDLangGet(@"Error")];
            //[FlurryAnalytics logError:@"Mail" message:@"Mail send failed" error:error];
            break;
        default:
            break;
    }
    //[self toggleBottomBar];
    
    //[self doLayoutSubviews];
    // hide the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    

}

#pragma mark Actions

- (void)didClickActionButton:(UIBarButtonItem *)sender {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[IDLang get:@"actionswithimagetitle"] delegate:self cancelButtonTitle:[IDLang get:@"cancelbutton"] destructiveButtonTitle:nil otherButtonTitles:[IDLang get:@"savetogalleryit"], [IDLang get:@"facebookit"], [IDLang get:@"emailit"], nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
//	NSLog(@"Did click button at index: %d", buttonIndex);
	if (buttonIndex == 0) {
		// Save to gallery
		[self saveCurrentImageToGallery];
	}
	else if (buttonIndex == 1) {
		iDeviantAppDelegate *appDelegate = [(iDeviantAppDelegate *)[UIApplication sharedApplication] delegate];
		
		MWFeedItem *item = [listThroughData objectAtIndex:currentIndex];
		[appDelegate postFbMessageWithObject:item];
	}
	else if (buttonIndex == 2) {
		[self emailCurrentImage];
	}
}

#pragma mark - Image view delegate & data source methods

-(void)imageViewDidStartLoadingImage:(FTImageView *)imgView{
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

	NSString *url = [self urlForItem:[listThroughData objectAtIndex:currentIndex]];	

	for (FTImagePage *p in imagePages) {
		if ([p.imageView.imageUrl isEqualToString:url]){
			[p.activityIndicator stopAnimating];
			[p.activityIndicator removeFromSuperview];
		}
	}
	
    self.currentImage = image;
    actionButton.enabled=true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Page scroll view delegate & data source methods

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    actionButton.enabled=false;
	if (currentIndex > 0)
		return [self pageForIndex:(currentIndex - 1)];
	else
		return nil;
}

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    actionButton.enabled=false;
	return [self pageForIndex:(currentIndex + 1)];
	
	if (currentIndex < [listThroughData count])
		return [self pageForIndex:(currentIndex + 1)];
	else
		return nil;
}


- (void)pageScrollView:(FTPageScrollView *)scrollView offsetDidChange:(CGPoint)offset {
	
}

- (CGSize)pageScrollView:(FTPageScrollView *)scrollView sizeForPage:(CGSize)size {
	return [self getFrameForPage].size;
}

- (void)dummyScrollInPageScrollViewDidFinish:(FTPageScrollView *)scrollView {

}


- (void)selektor:(FTImagePage *)imagePage {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

	[imagePage.imageZoomView setZoomScale:1.5];
	
	[UIView commitAnimations];
}

- (void)maintainPages {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	NSInteger count = [imagePages count];
	
	if (count > 3) {
		for (NSInteger i = 0; i < (count - 3); i++) {
			
			[[[imagePages objectAtIndex:i] imageZoomView] setZoomDelegate:nil];
			[[[imagePages objectAtIndex:i] imageZoomView].imageView setDelegate:nil];
			
			[[[imagePages objectAtIndex:i] imageZoomView].imageView.imageRequest cancel];
			[[[imagePages objectAtIndex:i] imageZoomView].imageView.imageRequest setDelegate:nil];
			
			[imagePages removeObjectAtIndex:i];
		}
	}
}

- (void)pageScrollView:(FTPageScrollView *)scrollView didMakePageCurrent:(FTImagePage *)imagePage {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

	if (doubletap) {
		[doubletap removeTarget:nil action:NULL];
		doubletap = nil;
	}
	doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewTwice:)];
	[doubletap setNumberOfTapsRequired:2];
	[imagePage addGestureRecognizer:doubletap];
	
	if (tap) {
		[tap removeTarget:nil action:NULL];
		tap = nil;
	}

	tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewOnce:)];
	[tap requireGestureRecognizerToFail:doubletap];
	[imagePage addGestureRecognizer:tap];
		
	currentIndex = imagePage.pageIndex;
	
	[self updateTitle];
	[self maintainPages];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
}

#pragma mark FTShareFacebookDelegate

- (void)facebookDidPost:(NSError *)error {
	NSString *messageString;
	if (error)
		messageString = [NSString stringWithFormat:@"Error occured while posting image on Facebook: %@", [error localizedDescription]];
	else
		messageString = @"Your photo has been successfuly posted";

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alertView show];
	[alertView release];
}

#pragma mark Memory management

- (void)dealloc {
	[mainView release];
	[imagePages release];
	[imageUrl release];
	[bottomBar release];
    [actionButton release];
	[message release];
	[listThroughData release];
	[shortcutView release];
	[currentImage release];
	
	[tap release];
	[doubletap release];
	
    [super dealloc];
}

@end
