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


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor clearColor]];
		[imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self addSubview:imageView];
	}
	return self;
}

#pragma mark Settings

- (void)imageNamed:(NSString *)imageName {
	NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@""];
	[self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
}

- (void)imageWithContentsOfFile:(NSString *)path {
	[self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:path]]];
}

- (void)imageWithUrl:(NSURL *)url {
	
}

#pragma mark Memory management

- (void)dealloc {
	[imageView release];
	[super dealloc];
}


@end
