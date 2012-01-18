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
//#import "IDLang.h"
#import "FTImagePage.h"

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
	[page release];
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
	
	page = [[FTImagePage alloc] initWithFrame:[self getFrameForPage]];
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
			[page zoomedImageWithUrl:[NSURL URLWithString:[[item.thumbnails objectAtIndex:0] objectForKey:@"url"]] andDelegate:self];
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
//		[[UIApplication sharedApplication] setStatusBarHidden:YES];
		[bottomBar setHidden:YES];
	} 
	else {
//		[[UIApplication sharedApplication] setStatusBarHidden:NO];
	}
	
	NSLog(@"bounds: %@", NSStringFromCGRect(self.view.bounds));
	NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
}

- (void)toggleNavigationVisibility {
	float a = 0.0;
	float alpha = self.navigationController.navigationBar.alpha;
	
	BOOL hide = NO;

	if (alpha == 0.0) {
		a = kIDImageDetailViewControllerMaxAlpha;
		
		[self.navigationController.navigationBar setHidden:NO];
		self.view.frame = self.view.bounds;
		[bottomBar setHidden:NO];
		hide = NO;
	}
	else if (alpha == 1.0) {
		a = 0.0;
		hide = YES;
	} else if (alpha == kIDImageDetailViewControllerMaxAlpha) {
		hide = YES;
	}

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishNavigationToggle)];

	[[UIApplication sharedApplication] setStatusBarHidden:hide];
	[self.navigationController.navigationBar setAlpha:a];
	
//	self.view.frame = self.view.bounds;
	
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
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
	[ai setHidesWhenStopped:YES];
    [ai startAnimating];
	[self.view addSubview:ai];
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
    [mainView setScrollEnabled:NO];
    [mainView setBouncesZoom:YES];
    [mainView setPagingEnabled:YES];
	[self.view addSubview:mainView];
	
	//[mainView loadImageFromUrl:imageUrl];
	
	bottomBar = [[FTToolbar alloc] initWithFrame:[self frameForToolbar]];
	[self.view addSubview:bottomBar];
	
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickActionButton:)];
	[bottomBar setItems:[NSArray arrayWithObjects:actionButton, nil]];
	//[actionButton release];
	
    //actionButton.enabled=false;
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
	
	[self.navigationController.navigationBar setTranslucent:YES];
	
	[UIView beginAnimations:nil context:nil];
	[self.navigationController.navigationBar setAlpha:kIDImageDetailViewControllerMaxAlpha];
	[UIView commitAnimations];
	
    [mainView setFrame:[super fullScreenFrame]];
    [bottomBar setFrame:[self frameForToolbar]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar setTranslucent:NO];
	[ai stopAnimating];
	
	[UIView beginAnimations:nil context:nil];
	
	[self.navigationController.navigationBar setAlpha:1.0];
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
//	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	page = nil;
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
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	NSLog(@"bounds: %@", NSStringFromCGRect(self.view.bounds));
	NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
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
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
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

#pragma mark Image loading

- (void)imageViewDidFailLoadingImage:(FTImageView *)imgView withError:(NSError *)error {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)imageView:(FTImageView *)imgView didFinishLoadingImageFromInternet:(UIImage *)image {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (void)imageZoomViewDidFinishLoadingImage:(FTImageZoomView *)zoomView {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	[UIView animateWithDuration:0.6
					 animations:^{
						 [ai setAlpha:0];
//						 [[UIApplication sharedApplication] setStatusBarHidden:YES];
//						 self.view.frame = self.view.bounds;
					 }
					 completion:^(BOOL finished) {
						 self.currentImage=zoomView.imageView.image;
                         [ai stopAnimating];
                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                         actionButton.enabled=true;
					 }
	 ];
    

}

#pragma mark Actions methods

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)info {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	NSLog(@"%@", info);
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
	
//	NSString *plainBody = [NSString stringWithFormat:@"\n\n\%@n\niDeviant app by Fuerte International UK - http://www.fuerteint.com/", [item link]];
//	[mc setMessageBody:plainBody isHTML:NO];
	
	NSString *htmlBody = [NSString stringWithFormat:@"</br></br><a href=\"%@\"><img src=\"%@\" /></a></br></br>iDeviant app by <a href='http://www.fuerteint.com/'>Fuerte International UK</a>", [item link], [[[item contents] objectAtIndex:0] objectForKey:@"url"]];
    [mc setMessageBody:htmlBody isHTML:YES];
	
//	mc 
//    if (self.currentImage) {
//        [mc addAttachmentData:UIImagePNGRepresentation(self.currentImage) mimeType:@"jpeg/png" fileName:[NSString stringWithFormat:@"%@.png", self.navigationController.title]];
//    }
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
            //[UIAlertView showMessage:IDLangGet(@"Your email has been saved") withTitle:IDLangGet(@"Email")];
            
            //[FTTracking logEvent:@"Mail: Mail saved"];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent.");
            //[FTTracking logEvent:@"Mail: Mail sent"];
            //[UIAlertView showMessage:IDLangGet(@"Your email has been sent") withTitle:IDLangGet(@"Email")];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
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
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[IDLang get:@"actionswithimagetitle"] delegate:self cancelButtonTitle:[IDLang get:@"cancelbutton"] destructiveButtonTitle:nil otherButtonTitles:[IDLang get:@"savetogalleryit"], [IDLang get:@"facebookit"], [IDLang get:@"emailit"], nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	NSLog(@"Did click button at index: %d", buttonIndex);
	if (buttonIndex == 0) {
		// Save to gallery
		[self saveCurrentImageToGallery];
	}
	else if (buttonIndex == 1) {
//		[self postCurrentImageOnFacebook];
		iDeviantAppDelegate *appDelegate = [(iDeviantAppDelegate *)[UIApplication sharedApplication] delegate];
		
		MWFeedItem *item = [listThroughData objectAtIndex:currentIndex];
		[appDelegate postFbMessageWithObject:item];
	}
	else if (buttonIndex == 2) {
		[self emailCurrentImage];
	}
}

#pragma mark Image view delegate & data source methods

-(void)imageViewDidStartLoadingImage:(FTImageView *)imgView{
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
    [ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	[ai stopAnimating];
    self.currentImage = image;
    actionButton.enabled=true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark Page scroll view delegate & data source methods


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}
/*
- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	//[ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
    return [self pageForIndex:(currentIndex - 1)];
}

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
    //[ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
	return [self pageForIndex:(currentIndex + 1)];
}
*/

- (void)pageScrollView:(FTPageScrollView *)scrollView offsetDidChange:(CGPoint)offset {
	
}

- (CGSize)pageScrollView:(FTPageScrollView *)scrollView sizeForPage:(CGSize)size {
	return [self getFrameForPage].size;
    //[ai stopAnimating];
}

- (void)dummyScrollInPageScrollViewDidFinish:(FTPageScrollView *)scrollView {
	NSLog(@"dummyScrollInPageScrollViewDidFinish:");
}


- (void)selektor:(FTImagePage *)page {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

	[page.imageZoomView setZoomScale:1.5];
	
	[UIView commitAnimations];
}

- (void)pageScrollView:(FTPageScrollView *)scrollView didMakePageCurrent:(FTImagePage *)page {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
	UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewTwice:)];
	[doubletap setNumberOfTapsRequired:2];
	[page addGestureRecognizer:doubletap];
	[doubletap release];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewOnce:)];
	[tap requireGestureRecognizerToFail:doubletap];
	[mainView addGestureRecognizer:tap];
	[tap release];
		
	currentIndex = page.pageIndex;
	NSLog(@"didMakePageCurrent: %d", currentIndex);
	[self updateTitle];
    
}

#pragma mark - FTPageScrollViewDelegate

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	return nil;
}

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
	return nil;
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


@end
