//
//  FTImageView.m
//  FTLibrary
//
//  Created by Tim Storey on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTImageView.h"
#import "UIColor+IGTools.h"
#import "ASIHTTPRequest.h"
#import "FTFilesystem.h"
#import "FTText.h"


@implementation FTImageView

@synthesize overlayImage;
@synthesize delegate;


#pragma mark Initilization

//set the image resizable and centered
- (void)doSetup {
	// Basic self setup
	[self setContentMode:UIViewContentModeScaleAspectFill];
	[self setClipsToBounds:YES];
	
	// Adding overlay image
    overlayImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [overlayImage setBackgroundColor:[UIColor clearColor]];
    [overlayImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [overlayImage setContentMode:UIViewContentModeCenter];
    [self addSubview:overlayImage];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrameWithRandomColor:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Settings

- (void)setRandomColorBackground {
    [self setBackgroundColor:[UIColor randomColor]];
}

- (void)doFlashWithColor:(UIColor *)color {
	flashOverlay = [[UIView alloc] initWithFrame:self.bounds];
	[flashOverlay setBackgroundColor:color];
	[flashOverlay setAlpha:0];
	[self addSubview:flashOverlay];
	[UIView animateWithDuration:0.3
					 animations:^{
						 [flashOverlay setAlpha:1];
					 } 
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:0.2 
										  animations:^{
											  [flashOverlay setAlpha:0];
										  }
										  completion:^(BOOL finished) {
											  [flashOverlay removeFromSuperview];
											  [flashOverlay release];
										  }];
					 }];
}

#pragma mark Background image loading

- (void)loadImage:(NSString *)url {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSData *data;
	NSString *path = [[FTFilesystemPaths getImagesDirectoryPath] stringByAppendingPathComponent:[FTText getSafeText:url]];
	@synchronized(self) {
		if (![FTFilesystemIO isFile:path]) {
			data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
			[data writeToFile:path atomically:YES];
		}
		else {
			data = [NSData dataWithContentsOfFile:path];
		}
	}
	UIImage *img = [UIImage imageWithData:data];
	[self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
	
	if ([delegate respondsToSelector:@selector(imageView:didFinishLoadingImage:)]) {
		[delegate imageView:self didFinishLoadingImage:img];
	}
	
	[pool release];
}

- (void)loadImageFromUrlOnBackground:(NSString *)url {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorInBackground:@selector(loadImage:) withObject:url];
	[pool release];
}

- (void)loadImageFromUrl:(NSString *)url {
	[NSThread detachNewThreadSelector:@selector(loadImageFromUrlOnBackground:) toTarget:self withObject:url];
}

#pragma mark Memory management

- (void)dealloc {
    [overlayImage release];
    [super dealloc];
}

@end
