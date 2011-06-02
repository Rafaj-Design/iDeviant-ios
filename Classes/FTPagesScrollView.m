//
//  FTPagesScrollView.m
//  FTLibrary
//
//  Created by Tim Storey on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTPagesScrollView.h"


@interface FTPagesScrollView (Private)

- (void)assembleDebugMessage;

- (int)getNumberOfPages;

@end


@implementation FTPagesScrollView

@synthesize numberOfPagesToPreloadOnEachSide;
@synthesize galleryDelegate;
@synthesize galleryDataSource;
@synthesize currentPageIndex;


#pragma mark Positioning

- (CGRect)frameForScreen {
    return self.bounds;
}

- (CGRect)frameForScreenAtIndex:(int)index {
    CGRect r = self.bounds;
	r.origin.x = (index * self.frame.size.width);
	return r;
}

#pragma mark Calculations

//#warning Not sure about the calculation
- (int)numberOfScreens {
	if (currentPageIndex <= _numberOfPagesToPreloadOnEachSide) {
		return (currentPageIndex + _numberOfPagesToPreloadOnEachSide + 1);
	}
	else {
		return ((2 * _numberOfPagesToPreloadOnEachSide) + 1);
	}
}

- (CGSize)contentSize {
	return CGSizeMake(([self numberOfScreens] * self.frame.size.width), self.frame.size.height);
}

- (void)setContentSize:(CGSize)contentSize {
	// Leave empty as this value should be dynamic
}

- (int)nextLeftIndex {
	return (currentPageIndex - _numberOfPagesToPreloadOnEachSide - 1);
}

- (int)nextRightIndex {
	return (currentPageIndex + _numberOfPagesToPreloadOnEachSide + 1);
}

- (int)firstCachedIndex {
	int index = (currentPageIndex - _numberOfPagesToPreloadOnEachSide - 1);
	if (index < 0) index = 0;
	return index;
}

- (int)lastCachedIndex {
	int index = [self nextRightIndex];
	int ns = [self numberOfScreens];
	if (index >= ns) index = (ns - 1);
	return index;
}

- (CGPoint)offsetForCurrentIndex {
	int x = (_numberOfPagesToPreloadOnEachSide * self.frame.size.width);
	if (currentPageIndex < _numberOfPagesToPreloadOnEachSide) {
		x = (currentPageIndex * self.frame.size.width);
	}
	else if ((currentPageIndex + _numberOfPagesToPreloadOnEachSide) > [self getNumberOfPages]) {
		NSLog(@"Going to the right");
	}
	int y = 0;
	return CGPointMake(x, y);
}

#pragma mark Data source methods

- (UIView *)getPageForIndex:(int)index {
    if ([galleryDataSource respondsToSelector:@selector(galleryScrollView:requestsPageAtIndex:)]) {
        return [galleryDataSource galleryScrollView:self requestsPageAtIndex:index];
    }
    else return nil;
}

- (int)getNumberOfPages {
    if ([galleryDataSource respondsToSelector:@selector(numberOfPagesForGalleryScrollView:)]) {
        return [galleryDataSource numberOfPagesForGalleryScrollView:self];
    }
    return 0;
}

#pragma mark Layout

- (void)doLayoutPages {
	NSLog(@"Number of screens: %d", [self numberOfScreens]);
	NSLog(@"First index: %d", [self firstCachedIndex]);
	int i = 0;
	for (UIView *v in galleryCache) {
		[v setFrame:[self frameForScreenAtIndex:i]];
		i++;
	}
	[super setContentSize:[self contentSize]];
	[super setContentOffset:[self offsetForCurrentIndex] animated:NO];
	if (isDebugMode) {
		[self assembleDebugMessage];
	}
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
	[self doLayoutPages];
}

#pragma mark Settings

- (void)goToPage:(int)index animated:(BOOL)animated {
    if (!animated) {
        //turn off scroll animation
        //either scrollRectToVisible:(CGRect) animated(BOOL):
        //or setContentOffset:(CGPOint) animated:(BOOL)
    }
}

- (void)goToPage:(int)index {
    [self goToPage:index animated:NO];
}

- (void)numberOfPagesToPreloadOnEachSide:(int)number {
	_numberOfPagesToPreloadOnEachSide = number;
	[self doLayoutPages];
}

- (int)numberOfPagesToPreloadOnEachSide {
	return _numberOfPagesToPreloadOnEachSide;
}

- (void)reload {
	NSArray *arr = [[NSArray alloc] initWithArray:(NSArray *)galleryCache];
	for (UIView *v in arr) {
		[v removeFromSuperview];
		[galleryCache removeObject:v];
	}
	[arr release];
	[self loadContent];
}

#pragma mark Pages

- (void)addPageToTheRight {
	UIView *p;
	if ([galleryCache count] > [self numberOfScreens]) {
		p = [galleryCache objectAtIndex:0];
		[p removeFromSuperview];
		[galleryCache removeObjectAtIndex:0];
	}
	int nri = [self nextRightIndex];
	if (nri < [self getNumberOfPages]) {
		p = [self getPageForIndex:nri];
		if (p) {
			[galleryCache addObject:p];
			[self addSubview:p];
		}
		currentPageIndex++;
		[self doLayoutPages];
	}
}

- (void)addPageToTheLeft {
	UIView *p;
	if ([galleryCache count] >= [self numberOfScreens]) {
		p = [galleryCache lastObject];
		[p removeFromSuperview];
		[galleryCache removeLastObject];
	}
	int nli = [self nextLeftIndex];
	if (nli > 0) {
		p = [self getPageForIndex:nli];
		if (p) {
			[galleryCache insertObject:p atIndex:0];
			[self addSubview:p];
		}
		currentPageIndex--;
		[self doLayoutPages];
	}
}

- (void)loadContent {
	for (int i = [self firstCachedIndex]; i < [self numberOfScreens]; i++) {
		UIView *p = [self getPageForIndex:i];
		if (p) {
			[galleryCache addObject:p];
			[self addSubview:p];
		}
	}
	[self doLayoutPages];
}

#pragma mark Initialisation

- (void)doSetup {
	currentPageIndex						= 0;
	_numberOfPagesToPreloadOnEachSide		= 2;
	
	[super setPagingEnabled:YES];
	[self setBackgroundColor:[UIColor clearColor]];
	[super setDelegate:self];
	
	galleryCache = [[NSMutableArray alloc] init];
}

- (id)init {
	self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark ScrollView delegate methods

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    // Leave empty, forces the use of our protocol
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int tempPageIndex = (scrollView.contentOffset.x / self.frame.size.width);
	
	// Enabling debug mode
	if (isDebugMode) {
		CGRect r = debugLabel.frame;
		r.origin.x = 10 + scrollView.contentOffset.x;
		[debugLabel setFrame:r];
		[self assembleDebugMessage];
		[self bringSubviewToFront:debugLabel];
	}
	
	// 
    if (tempPageIndex != currentPageIndex) {
		// Adding the right page
		if (tempPageIndex > currentPageIndex) {
			[self addPageToTheRight];
		}
		else {
			[self addPageToTheLeft];
		}
		//currentPageIndex = tempPageIndex;
		if ([galleryDelegate respondsToSelector:@selector(galleryScrollView:turnedToPage:)]) {
			[galleryDelegate galleryScrollView:self turnedToPage:currentPageIndex];
		}
		[self doLayoutPages];
	}
}

#pragma mark Debug mode

- (void)assembleDebugMessage {
	NSString *text = @"";
	text = [text stringByAppendingFormat:@"Preload on each side: %d\n", [self numberOfPagesToPreloadOnEachSide]];
	text = [text stringByAppendingFormat:@"Preloaded screens: %d\n", [self numberOfScreens]];
	text = [text stringByAppendingFormat:@"Total number of pages: %d\n", [self getNumberOfPages]];
	text = [text stringByAppendingFormat:@"Current scroll offset: %d\n", self.contentOffset.x];
	text = [text stringByAppendingFormat:@"Pages in cache: %d\n", [galleryCache count]];
	
	text = [text stringByAppendingFormat:@"\n"];
	
	text = [text stringByAppendingFormat:@"Current page index: %d\n", currentPageIndex];
	text = [text stringByAppendingFormat:@"Next left index: %d\n", [self nextLeftIndex]];
	text = [text stringByAppendingFormat:@"Next right index: %d\n", [self nextRightIndex]];
	text = [text stringByAppendingFormat:@"First cached index: %d\n", [self firstCachedIndex]];
	text = [text stringByAppendingFormat:@"Last cached index: %d\n", [self lastCachedIndex]];
	
	[debugLabel setText:text];
}

- (BOOL)debugMode {
	return isDebugMode;
}

- (void)setDebugMode:(BOOL)debug {
	isDebugMode = debug;
	if (debug) {
		debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 180)];
		[debugLabel setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
		[debugLabel setTextColor:[UIColor blackColor]];
		[debugLabel setTextAlignment:UITextAlignmentCenter];
		[debugLabel setText:@"Debug mode"];
		[debugLabel setFont:[UIFont systemFontOfSize:12]];
		[debugLabel setNumberOfLines:0];
		[self addSubview:debugLabel];
	}
	else {
		[debugLabel removeFromSuperview];
		[debugLabel release];
	}
}

#pragma mark Memory Management

- (void)dealloc {
    [galleryCache release];
	[debugLabel release];
    [super dealloc];
}


@end
