//
//  IDImageZoomView.m
//  iDeviant
//
//  Created by Adam Horacek on 01.02.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "IDImageZoomView.h"


@implementation IDImageZoomView

@synthesize imageView;
@synthesize zoomDelegate;


#pragma mark Layout

- (void)doZoomLayout {
	if (imageView.image) {
		if (maxA == 0) {
			
		}
		if (maxB == 0) {
			
		}
		if (self.zoomScale > 0) {
			NSLog(@"Zoom apply");
		}
	}
}

#pragma mark Initialization

- (void)doImageZoomViewSetup {
	int imageWidth = [(UIImageView *)zoomedView image].size.width;
	int zoomWidth = self.frame.size.width;
	int max = imageWidth / zoomWidth;
	if (max < [self minimumZoomScale]) max = [self minimumZoomScale];
	[self setMaximumZoomScale:(max + 10)];
	[self doZoomLayout];
}

- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin {
	return nil;
}

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame {
	// Basic margin
	margin = 10;
	maxA = 0;
	maxB = 0;
	
	// Creating view
	IDImageView *v = [[IDImageView alloc] initWithImage:image];
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
		IDImageView *v = [[IDImageView alloc] initWithImage:image];
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
	else [(IDImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
}

- (void)loadImageFromUrl:(NSString *)url {
	if (!zoomedView) {
		IDImageView *v = [[IDImageView alloc] initWithFrame:self.bounds];
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
	[(IDImageView *)zoomedView loadImageFromUrl:url];
}

#pragma mark Positioning

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self doImageZoomViewSetup];
}

- (void)setSideMargin:(CGFloat)sideMargin {
	
}

#pragma mark Scrollview delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self doZoomLayout];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self doZoomLayout];
}

#pragma mark Image view delegate

- (void)imageView:(IDImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	[(IDImageView *)zoomedView setImage:image];
	[self doImageZoomViewSetup];
	if ([zoomDelegate respondsToSelector:@selector(imageZoomViewDidFinishLoadingImage:)]) {
		[zoomDelegate imageZoomViewDidFinishLoadingImage:self];
	}
}

- (void)imageViewDidFailLoadingImage:(IDImageView *)imgView withError:(NSError *)error {
	
}

- (void)imageViewDidStartLoadingImage:(IDImageView *)imgView {
	
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
    [super dealloc];
}


@end
