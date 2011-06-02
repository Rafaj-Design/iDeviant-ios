//
//  FTImageZoomView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 07/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImageZoomView.h"


@implementation FTImageZoomView

@synthesize imageView;
@synthesize zoomDelegate;


#pragma mark Initialization

- (void)doImageZoomViewSetup {
	int imageWidth = [(UIImageView *)zoomedView image].size.width;
	int zoomWidth = self.frame.size.width;
	int max = imageWidth / zoomWidth;
	if (max < [self minimumZoomScale]) max = [self minimumZoomScale];
	[self setMaximumZoomScale:(max + 10)];
}

- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin {
	return nil;
}

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame {
	FTImageView *v = [[FTImageView alloc] initWithImage:image];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[v setContentMode:UIViewContentModeScaleAspectFit];
	[v setDelegate:self];
	CGRect r = v.frame;
	r.size = frame.size;
	[v setFrame:r];
    self = [super initWithView:v andOrigin:frame.origin];
	//[self setImageView:v];
	[v release];
    if (self) {
        [self doImageZoomViewSetup];
    }
    return self;
}

#pragma mark Settings

- (void)setImage:(UIImage *)image {
	if (!zoomedView) {
		FTImageView *v = [[FTImageView alloc] initWithImage:image];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[v setContentMode:UIViewContentModeScaleAspectFit];
		[v setDelegate:self];
		CGRect r = v.frame;
		r.size = self.frame.size;
		[v setFrame:r];
		[super addZoomedView:v];
		[self setImageView:v];
		[v release];
	}
	else [(FTImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
}

- (void)loadImageFromUrl:(NSString *)url {
	if (!zoomedView) {
		FTImageView *v = [[FTImageView alloc] initWithFrame:self.bounds];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[v setContentMode:UIViewContentModeScaleAspectFit];
		[v setDelegate:self];
		CGRect r = v.frame;
		r.size = self.frame.size;
		[v setFrame:r];
		[super addZoomedView:v];
		[self setImageView:v];
		[v release];
	}
	[(FTImageView *)zoomedView loadImageFromUrl:url];
}

#pragma mark Positioning

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self doImageZoomViewSetup];
}

#pragma mark Scrollview delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"Did scroll: %@", NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark Image view delegate

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	[(FTImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
	if ([zoomDelegate respondsToSelector:@selector(imageZoomViewDidFinishLoadingImage:)]) {
		[zoomDelegate imageZoomViewDidFinishLoadingImage:self];
	}
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
    [super dealloc];
}

@end
