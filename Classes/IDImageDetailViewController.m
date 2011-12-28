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
#import "FTLang.h"

#define kIDImageDetailViewControllerMaxAlpha				0.6f


@implementation IDImageDetailViewController

@synthesize mainView;
@synthesize imageUrl;
@synthesize currentIndex;
@synthesize delegate;
@synthesize currentImage;


#pragma mark Positioning

- (CGRect)frameForToolbar {
	CGRect r = [super fullScreenFrame];
	r.origin.y = (r.size.height - 44);
	r.size.height = 44;
	return r;
}

- (CGRect)getFrameForPage {
	if (isLandscape) return CGRectMake(0, 0, 480, 320);
	else return CGRectMake(0, 0, 320, 480);
}

- (CGRect)frameForShortcutView {
	if (isLandscape) return CGRectMake(0, 100, 480, 74);
	else return CGRectMake(0, 250, 320, 74);
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
    [actionButton release];
	[ai release];
	[message release];
	[listThroughData release];
	[shortcutView release];
    [super dealloc];
}

#pragma Display stuff

- (void)updateTitle {
	NSString *t = [NSString stringWithFormat:@"%d / %d", (currentIndex + 1), [listThroughData count]];
	[self setTitle:t];
}

#pragma mark Generating pages

- (FTPage *)pageForIndex:(int)index {
	//NSLog(@"Page index: %d", index);
	if (currentIndex < 0 || currentIndex >= [listThroughData count]) return nil;
	NSLog(@"Page index: %d", index);
	MWFeedItem *item = [listThroughData objectAtIndex:currentIndex];
	
	FTImagePage *page = [[[FTImagePage alloc] initWithFrame:[self getFrameForPage]] autorelease];
	[page setPageIndex:index];
    
    //info box on image [loaded from cash/web]
	//[page zoomedImageNamed:@"wallpaper.jpg"];
	BOOL canAccess = YES;
	if ([item.rating isEqualToString:@"adult"]) {
		if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;
	}
	if (canAccess) {
		if ([item.contents count] > 0) {
			//[cell.cellImageView loadImageFromUrl:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]];
			[page.imageZoomView.imageView enableDebugMode:YES];
			[page zoomedImageWithUrl:[NSURL URLWithString:[[item.contents objectAtIndex:0] objectForKey:@"url"]] andDelegate:self];
			//[page.imageZoomView.imageView enableActivityIndicator:YES];
			//[page.imageZoomView.imageView enableProgressLoadingView:YES];
		}
	}
	else {
		
	}
	return page;
}

#pragma mark Navigation animations

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

- (void)toggleShortcut {
	int alpha = (shortcutView.alpha == 0) ? 1 : 0;
	[UIView beginAnimations:nil context:nil];
	[shortcutView setAlpha:alpha];
	[UIView commitAnimations];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
	[shortcutView.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
	[self.view setBackgroundColor:[UIColor blackColor]];
	
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	
	[self.navigationController.navigationBar setTranslucent:YES];
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:kIDImageDetailViewControllerMaxAlpha];
	[UIView commitAnimations];
	
	//UIBarButtonItem *favsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didClickActionButton:)];
	//[self.navigationItem setRightBarButtonItem:favsButton];
	//[favsButton release];
	
	FTPage *page = [self pageForIndex:currentIndex];
	mainView = [[FTPageScrollView alloc] initWithFrame:[super fullScreenFrame]];
	[mainView setDummyPageImage:[UIImage imageNamed:@"dummy.png"]];
	[mainView setInitialPage:page withDelegate:self];
	//[mainView setPageScrollDelegate:self];
	[mainView setPage:page pageCount:0 animate:YES];
	[self.view addSubview:mainView];
	
	
	
//	[mainView setZoomDelegate:self];
//	[mainView loadImageFromUrl:imageUrl];
	/*
	UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewTwice:)];
	[doubletap setNumberOfTapsRequired:2];
	[mainView addGestureRecognizer:doubletap];
	[doubletap release];
	*/
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewOnce:)];
	//[tap requireGestureRecognizerToFail:doubletap];
	[mainView addGestureRecognizer:tap];
	[tap release];
	
	bottomBar = [[FTToolbar alloc] initWithFrame:[self frameForToolbar]];
	[self.view addSubview:bottomBar];
	
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickActionButton:)];
	[bottomBar setItems:[NSArray arrayWithObjects:actionButton, nil]];
	//[actionButton release];
	
	ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
	[ai setHidesWhenStopped:YES];
	[ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self.view addSubview:ai];
    actionButton.enabled=false;
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
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setTranslucent:NO];
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:1.0];
	[UIView commitAnimations];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark Layout

- (void)doLayoutSubviews {
	[UIView beginAnimations:nil context:nil];
	[mainView setFrame:[super fullScreenFrame]];
	[bottomBar setFrame:[self frameForToolbar]];
	[ai centerInSuperView];
	[shortcutView centerInSuperView];
	[UIView commitAnimations];
	
	[mainView reload];
}

#pragma mark Gesture recognizers

- (void)didTapViewOnce:(UITapGestureRecognizer *)recognizer {
	if (!shortcutView) [self toggleNavigationVisibility];
	else {
		if (shortcutView.alpha == 0) {
			[self toggleNavigationVisibility];
		}
		else {
			[UIView beginAnimations:nil context:nil];
			[shortcutView setAlpha:0];
			[UIView commitAnimations];
		}
	}
}

/*
- (void)didTapViewTwice:(UITapGestureRecognizer *)recognizer {
	if (!shortcutView) {
		shortcutView = [[IDHorizontalItems alloc] initWithFrame:[self frameForShortcutView] andData:data];
		[mainView addSubview:shortcutView];
		[shortcutView setAlpha:0];
	}
	[mainView bringSubviewToFront:shortcutView];
	float alpha = self.navigationController.navigationBar.alpha;
	if (alpha == 0.0) {
		[self toggleShortcut];
	}
	else {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [self toggleShortcut];
						 }
						 completion:^(BOOL finished) {
							 [self toggleNavigationVisibility];
						 }
		 ];
	}
	
}
*/
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
    [ai stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    actionButton.enabled=true;
    
}

#pragma mark Actions methods

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)info {
	

}

- (void)saveCurrentImageToGallery {

	UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[FTLang get:@"imagesaved"] message:nil
												   delegate:self cancelButtonTitle:[FTLang get:@"OK"] otherButtonTitles:nil, nil];
	[alert show];
    
	[alert release];
	//[FlurryAPI logEvent:@"Func: Saving image"];
}

- (void)postCurrentImageOnFacebook {
	//iDeviantAppDelegate *appDelegate = (iDeviantAppDelegate *)[UIApplication sharedApplication].delegate;
	//if (![appDelegate.facebook isSessionValid]) [appDelegate.facebook authorize:nil delegate:appDelegate];
	//[FlurryAPI logEvent:@"Func: Facebooking image"];
}

- (void)emailCurrentImage {
	//[FlurryAPI logEvent:@"Func: Emailing image"];
    /*
    FTShareMailData *mailData = [[FTShareMailData alloc] init];

    //[mailData addAttachmentWithObject:self.currentImage type:@"jpg" andName:@"iDVimg"];
    [mailData setSubject:@"iDeviant"];
    [mailData setPlainBody:@"iDeviant"];
    
    [[FTShare alloc] shareViaMail:mailData];
    */
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setMailComposeDelegate:self];
    [mc setSubject:[NSString stringWithFormat:@"iDeviant"]];
    [mc setMessageBody:@"\n\n\n\niDeviant app by Fuerte International UK - http://www.fuerteint.com/" isHTML:NO];
    [mc setMessageBody:@"</br></br></br></br>iDeviant app by <a href='http://www.fuerteint.com/'>Fuerte International UK</a>" isHTML:YES];
    if (self.currentImage) {
        [mc addAttachmentData:UIImagePNGRepresentation(self.currentImage) mimeType:@"jpeg/png" fileName:[NSString stringWithFormat:@"%@.png", self.navigationController.title]];
    }
    //[mc addAttachmentData:self.currentImage mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png", self.navigationController.title]];
    //self.currentImage = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    //[mc addAttachmentData:self.currentImage mimeType:@"image/png" fileName:@"Fuerte_International_UK.png"];
    [mc setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentModalViewController:mc animated:YES];

}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled.");
            //[FTTracking logEvent:@"Mail: Mail canceled"];
            break;
        case MFMailComposeResultSaved:
            //[UIAlertView showMessage:FTLangGet(@"Your email has been saved") withTitle:FTLangGet(@"Email")];
            
            //[FTTracking logEvent:@"Mail: Mail saved"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            //[FTTracking logEvent:@"Mail: Mail sent"];
            //[UIAlertView showMessage:FTLangGet(@"Your email has been sent") withTitle:FTLangGet(@"Email")];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            //[UIAlertView showMessage:[error localizedDescription] withTitle:FTLangGet(@"Error")];
            //[FlurryAnalytics logError:@"Mail" message:@"Mail send failed" error:error];
            break;
        default:
            break;
    }
    //[self toggleBottomBar];
    // hide the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    

}

#pragma mark Actions

- (void)didClickActionButton:(UIBarButtonItem *)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[FTLang get:@"actionswithimagetitle"] delegate:self cancelButtonTitle:[FTLang get:@"cancelbutton"] destructiveButtonTitle:nil otherButtonTitles:[FTLang get:@"savetogalleryit"], [FTLang get:@"facebookit"], [FTLang get:@"emailit"], nil];
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

#pragma mark Image view delegate & data source methods

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	[ai stopAnimating];
    self.currentImage = image;
    actionButton.enabled=true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark Page scroll view delegate & data source methods


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	[ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
    return [self pageForIndex:(currentIndex - 1)];
}

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
    [ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
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
