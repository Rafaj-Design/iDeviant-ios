//
//  FTImagePage.m
//  LazyLoadingTest
//
//  Created by Ondrej Rafaj on 04/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImagePage.h"
#import "IDImageView.h"


@implementation FTImagePage

@synthesize imageView;
@synthesize imageZoomView;
@synthesize activityIndicator;

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityIndicator centerInSuperView];
		[activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
		
		[activityIndicator startAnimating];
		[self addSubview:activityIndicator];
		
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	}
	return self;
}

#pragma mark Image view settings

- (void)imageWithContentsOfFile:(NSString *)path {
	[self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
}

- (void)imageNamed:(NSString *)imageName withDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate {
	if (!imageView) {
		imageView = [[IDImageView alloc] initWithFrame:self.bounds];
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor clearColor]];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[imageView setDelegate:(id<IDImageViewDelegate>)self];
		[self addSubview:imageView];
	}
	if (imageName) {
		NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@""];
		[self imageWithContentsOfFile:path];
	}
}

- (void)imageNamed:(NSString *)imageName {
	[self imageNamed:imageName withDelegate:nil];
}

- (void)imageWithUrl:(NSURL *)url andDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate {
	[self imageNamed:nil];
	if (delegate) {
		[imageZoomView setZoomDelegate:delegate];
		[imageZoomView.imageView setDelegate:delegate];
	}
	[imageZoomView.imageView loadImageFromUrl:[url absoluteString]];
}

- (void)imageWithUrl:(NSURL *)url {
	[self imageWithUrl:url andDelegate:nil];
}

#pragma mark Zoomed image view settings

- (void)zoomedImageWithContentsOfFile:(NSString *)path {
	[self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
}

- (void)zoomedImageNamed:(NSString *)imageName withDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate {
	if (!imageZoomView) {
		imageZoomView = [[IDImageZoomView alloc] initWithFrame:self.bounds];
		[imageZoomView setContentMode:UIViewContentModeScaleAspectFit];
		[imageZoomView setBackgroundColor:[UIColor clearColor]];
		if (delegate) {
			[imageZoomView setZoomDelegate:delegate];
			[imageZoomView.imageView setDelegate:delegate];
		}
		[imageZoomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[self addSubview:imageZoomView];
	}
	if (imageName) {
		NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@""];
		[self.imageZoomView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
	}
}

- (void)zoomedImageNamed:(NSString *)imageName {
	[self zoomedImageNamed:imageName withDelegate:nil];
}

- (void)zoomedImageWithUrl:(NSURL *)url andDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate {
	[self zoomedImageNamed:nil];
	[imageZoomView setImage:nil];
	if (delegate) {
		[imageZoomView setZoomDelegate:delegate];
		[imageZoomView.imageView setDelegate:delegate];
	}
	[imageZoomView.imageView loadImageFromUrl:[url absoluteString]];
}

- (void)zoomedImageWithUrl:(NSURL *)url {
	[self zoomedImageNamed:nil];
	[imageZoomView setImage:nil];
	
	[imageZoomView setZoomDelegate:(id <IDImageZoomViewDelegate>)self];
	[imageZoomView.imageView setDelegate:(id <IDImageViewDelegate>)self];

	[imageZoomView.imageView loadImageFromUrl:[url absoluteString]];
}


#pragma mark - IDImageViewDelegate

-(void)imageViewDidStartLoadingImage:(IDImageView *)imgView{
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)imageView:(IDImageView *)imgView didFinishLoadingImage:(UIImage *)image {
	NSLog(@"Line: %d, File: %s %@", __LINE__, __FILE__,  NSStringFromSelector(_cmd));
	
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark Memory management

- (void)dealloc {
	
	[imageZoomView.imageView.imageRequest cancel];
	[imageZoomView.imageView.imageRequest setDelegate:nil];
	
	
	[imageView release];
	[imageZoomView release];
	[super dealloc];
}


@end
