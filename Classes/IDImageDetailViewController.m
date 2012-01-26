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
//#import "FTPageScrollViewDelegate.h"
#import "FTPageScrollView.h"

#define kIDImageDetailViewControllerMaxAlpha				0.6f

@implementation IDImageDetailViewController

@synthesize delegate;
@synthesize mainView;
@synthesize imagePages;
@synthesize imageUrl;
@synthesize actionButton;
@synthesize currentIndex;
@synthesize listThroughData;
@synthesize shortcutView;
@synthesize currentImage;
@synthesize isOverlayShowing;
@synthesize tap, doubletap;

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



#pragma Display stuff

- (void)updateTitle {
	NSString *t = [NSString stringWithFormat:@"%d / %d", (currentIndex + 1), [listThroughData count]];
	[self setTitle:t];
}

#pragma mark Generating pages



- (NSString *)urlForItem:(MWFeedItem *)item {
	
	NSString *contentUrl = [[item.contents objectAtIndex:0] objectForKey:@"url"];
	NSString *extension = [[contentUrl pathExtension] lowercaseString];
	
	if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpeg"] || [extension isEqualToString:@"jpg"]) {
		NSLog(@"url: %@, ext: %@",[[item.contents objectAtIndex:0] objectForKey:@"url"], extension);
		return [[item.contents objectAtIndex:0] objectForKey:@"url"];
	} else {
		NSLog(@"url: %@, ext: %@",[[item.thumbnails objectAtIndex:0] objectForKey:@"url"], extension);
		return [[item.thumbnails objectAtIndex:0] objectForKey:@"url"];
	}
}

- (FTImagePage *)pageForIndex:(int)index {
	NSLog(@"index: %d, currentIndex: %d, [listThroughData count]: %d", index, currentIndex, [listThroughData count]);

	if (index < 0 || index >= [listThroughData count]) 
			return nil;

	MWFeedItem *item = [listThroughData objectAtIndex:index];
	
	FTImagePage *imagePage = [[FTImagePage alloc] initWithFrame:[self getFrameForPage]];
	[imagePage.activityIndicator centerInSuperView];
	
	BOOL canAccess = YES;
	if ([item.rating isEqualToString:@"adult"]) {
		if (![IDAdultCheck canAccessAdultStuff]) canAccess = NO;
	}

	if (canAccess) {
		if ([item.thumbnails count] > 0) {
			[imagePage.imageZoomView.imageView enableDebugMode:YES];
			[imagePage.imageZoomView.imageView setDelegate:(id<FTImageViewDelegate>)self];
			
			[imagePage zoomedImageWithUrl:[NSURL URLWithString:[self urlForItem:item]] andDelegate:self];
		} else {
			[imagePage release];
			if (currentIndex < index) {
				return [self pageForIndex:(index + 1)];
			} else {
				return [self pageForIndex:(index - 1)];
			}
		}
	}
	else {
		if (currentIndex < index) {
			return [self pageForIndex:(index + 1)];
		} else {
			return [self pageForIndex:(index - 1)];
		}
	}
	[imagePage setPageIndex:index];
	
	[imagePages addObject:imagePage];
	[imagePage release];
	
	NSLog(@"%@", imagePages);
	return imagePage;
}

#pragma mark Navigation animations

- (void)finishNavigationToggle {
	if (bottomBar.alpha == 0) {
		[self.navigationController.navigationBar setHidden:YES];
		[bottomBar setHidden:YES];
	}
}

- (void)toggleNavigationVisibility {
	if (isOverlayShowing)
		isOverlayShowing = NO;
	else
		isOverlayShowing = YES;

	float a = 0.0;
	float alpha = self.navigationController.navigationBar.alpha;
	
	BOOL hide = NO;

	if (alpha == 0.0) {
		a = kIDImageDetailViewControllerMaxAlpha;
		
		[self.navigationController.navigationBar setHidden:NO];
//		self.view.frame = self.view.bounds;
		
		[bottomBar setHidden:NO];
		hide = NO;
	}
	else if (alpha == 1.0) {
		a = 0.0;
		hide = YES;
	} else if (alpha == kIDImageDetailViewControllerMaxAlpha) {
		hide = YES;
	}
	
	[[UIApplication sharedApplication] setStatusBarHidden:hide];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
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
	
	isOverlayShowing = YES;
	
	imagePages = [[NSMutableArray alloc] init];
	
    FTImagePage *imagePage = [self pageForIndex:currentIndex];
	
	NSLog(@"%@", imagePages);
	
    mainView = [[FTPageScrollView alloc] initWithFrame:[super fullScreenFrame]];
    [mainView setDummyPageImage:[UIImage imageNamed:@"dummy.png"]];
    [mainView setInitialPage:imagePage withDelegate:(id<FTPageScrollViewDelegate>)self];
	[mainView setPage:imagePage pageCount:[listThroughData count] animate:YES];
	
	FTPage *rPage = [self pageForIndex:(currentIndex + 1)];
	FTPage *lPage = [self pageForIndex:(currentIndex - 1)];
	
//	mainView performSelector:@selector(setRightPage:nil)
	
	[mainView performSelector:@selector(setRightPage:) withObject:rPage];
	[mainView performSelector:@selector(setLeftPage:) withObject:lPage];
	
    [mainView setScrollEnabled:YES];
    [mainView setBouncesZoom:YES];
    [mainView setPagingEnabled:YES];
		
	[self.view addSubview:mainView];
	
//	ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
//	[ai setHidesWhenStopped:YES];
//	//	[ai setBackgroundColor:[UIColor redColor]];
////    [ai startAnimating];
//	[self.view addSubview:ai];	
	
	bottomBar = [[FTToolbar alloc] initWithFrame:[self frameForToolbar]];
	[self.view addSubview:bottomBar];
	
	actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didClickActionButton:)];
	[bottomBar setItems:[NSArray arrayWithObjects:actionButton, nil]];

}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self toggleNavigationVisibility];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[super enableBackgroundWithImage:nil];
	[self updateTitle];
	
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
//	[ai stopAnimating];
	
	[UIView beginAnimations:nil context:nil];
	
	[self.navigationController.navigationBar setAlpha:1.0];
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
//	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
//	page = nil;
//	for (FTPage *p in imagePages) {
//		[p release];
//	}
//	
//	mainView = nil;
//	imagePages = nil;
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
		
	NSString *htmlBody = [NSString stringWithFormat:@"</br></br><a href=\"%@\"><img src=\"%@\" /></a></br></br>Copyright <a href=\"%@\">%@</a></br>iDeviant app by <a href=\"http://www.fuerteint.com/\">Fuerte International UK</a>", [item link], [self urlForItem:item], [item link], [[item credits] objectAtIndex:0]];
    [mc setMessageBody:htmlBody isHTML:YES];
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
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

	NSString *url = [self urlForItem:[listThroughData objectAtIndex:currentIndex]];
	
	NSLog(@"start: imgView.imageUrl: %@, url: %@", imgView.imageUrl, url);
	
	if ([imgView.imageUrl isEqualToString:url]) {
		NSLog(@"START ANIMATING");
//		[ai startAnimating];
	}
	
	[ai setAlpha:1.0];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));

	NSString *url = [self urlForItem:[listThroughData objectAtIndex:currentIndex]];

	NSLog(@"finish: imgView.imageUrl: %@, url: %@", imgView.imageUrl, url);
	
	if ([imgView.imageUrl isEqualToString:url]) {
		NSLog(@"STOP ANIMATING");
//		[ai stopAnimating];
	}
	

	for (FTImagePage *p in imagePages) {
		if ([p.imageView.imageUrl isEqualToString:url]){
			NSLog(@"STOP ANIMATING");
			[p.activityIndicator stopAnimating];
		}
	}
	
    self.currentImage = image;
    actionButton.enabled=true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark Page scroll view delegate & data source methods

- (FTPage *)leftPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
//	NSLog(@"currentIndex - 1: %d", currentIndex - 1);
	
//	[ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
	if (currentIndex > 0)
		return [self pageForIndex:(currentIndex - 1)];
	else
		return nil;
}

- (FTPage *)rightPageForPageScrollView:(FTPageScrollView *)scrollView withTouchCount:(NSInteger)touchCount {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
//	NSLog(@"currentIndex + 1: %d", currentIndex + 1);
	
//    [ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    actionButton.enabled=false;
	return [self pageForIndex:(currentIndex + 1)];
	
	if (currentIndex < [listThroughData count])
		return [self pageForIndex:(currentIndex + 1)];
	else
		return nil;
}


- (void)pageScrollView:(FTPageScrollView *)scrollView offsetDidChange:(CGPoint)offset {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
}

- (CGSize)pageScrollView:(FTPageScrollView *)scrollView sizeForPage:(CGSize)size {
	return [self getFrameForPage].size;
    //[ai stopAnimating];
}

- (void)dummyScrollInPageScrollViewDidFinish:(FTPageScrollView *)scrollView {
	NSLog(@"dummyScrollInPageScrollViewDidFinish:");
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
//	NSLog(@"imagePages.count: %d", imagePages.count);
	NSInteger count = [imagePages count];
	
	if (count > 3) {
		for (NSInteger i = 0; i < (count - 3); i++) {
			[imagePages removeObjectAtIndex:i];
		}
	}
}

- (void)pageScrollView:(FTPageScrollView *)scrollView didMakePageCurrent:(FTImagePage *)imagePage {
//	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
	
	if (![[imagePage gestureRecognizers] containsObject:doubletap]) {
		if (doubletap) {
			doubletap = nil;
			[doubletap release];
		}
		doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewTwice:)];
		[doubletap setNumberOfTapsRequired:2];
		[imagePage addGestureRecognizer:doubletap];
		[doubletap release];
	}
	
	if (![[mainView gestureRecognizers] containsObject:tap]) {
		if (tap) {
			tap = nil;
			[tap release];
		}
		tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewOnce:)];
		[tap requireGestureRecognizerToFail:doubletap];
		[mainView addGestureRecognizer:tap];
		[tap release];
	}	
		
	currentIndex = imagePage.pageIndex;
	NSLog(@"didMakePageCurrent: %d", currentIndex);
	
	if (imagePage.imageView.image != nil) {
		NSLog(@"imagePage.imageView.image != nil");
//		[ai stopAnimating];
	}
	
	[self updateTitle];
	[self maintainPages];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
}

- (void)showHideNavbar:(id)sender {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (!isOverlayShowing)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (!isOverlayShowing)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[ai setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}

#pragma mark Memory management

- (void)dealloc {
	[mainView release];
	[imagePages release];
	[imageUrl release];
	[bottomBar release];
    [actionButton release];
	[ai release];
	[message release];
	[listThroughData release];
	[shortcutView release];
	[currentImage release];
	
    [super dealloc];
}

@end
