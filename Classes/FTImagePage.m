//
//  FTImagePage.m
//  LazyLoadingTest
//
//  Created by Ondrej Rafaj on 04/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImagePage.h"


@implementation FTImagePage

@synthesize imageView;
@synthesize imageZoomView;


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
	}
	return self;
}

#pragma mark Image view settings

- (void)imageWithContentsOfFile:(NSString *)path {
	[self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
}

- (void)imageNamed:(NSString *)imageName withDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate {
	if (!imageView) {
		imageView = [[FTImageView alloc] initWithFrame:self.bounds];
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor clearColor]];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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

- (void)imageWithUrl:(NSURL *)url andDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate {
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

- (void)zoomedImageNamed:(NSString *)imageName withDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate {
	if (!imageZoomView) {
		imageZoomView = [[FTImageZoomView alloc] initWithFrame:self.bounds];
		[imageZoomView setContentMode:UIViewContentModeScaleAspectFit];
		[imageZoomView setBackgroundColor:[UIColor clearColor]];
		if (delegate) {
			[imageZoomView setZoomDelegate:delegate];
			[imageZoomView.imageView setDelegate:delegate];
		}
		[imageZoomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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

- (void)zoomedImageWithUrl:(NSURL *)url andDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate {
	[self zoomedImageNamed:nil];
	[imageZoomView setImage:nil];
	if (delegate) {
		[imageZoomView setZoomDelegate:delegate];
		[imageZoomView.imageView setDelegate:delegate];
	}
	[imageZoomView.imageView loadImageFromUrl:[url absoluteString]];
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
	[imageZoomView release];
	[super dealloc];
}


@end
