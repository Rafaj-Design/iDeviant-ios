//
//  FTImagePage.h
//  LazyLoadingTest
//
//  Created by Ondrej Rafaj on 04/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPage.h"
#import "IDImageZoomView.h"
#import "IDImageView.h"


@interface FTImagePage : FTPage <IDImageViewDelegate, IDImageZoomViewDelegate> {
	
	IDImageView *imageView;
	
	IDImageZoomView *imageZoomView;
	
	UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic, retain) IDImageView *imageView;

@property (nonatomic, retain) IDImageZoomView *imageZoomView;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


- (void)imageWithContentsOfFile:(NSString *)path;

- (void)imageNamed:(NSString *)imageName withDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate;

- (void)imageNamed:(NSString *)imageName;

- (void)imageWithUrl:(NSURL *)url;

- (void)zoomedImageWithContentsOfFile:(NSString *)path;

- (void)zoomedImageNamed:(NSString *)imageName withDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate;

- (void)zoomedImageNamed:(NSString *)imageName;

- (void)zoomedImageWithUrl:(NSURL *)url andDelegate:(id <IDImageViewDelegate, IDImageZoomViewDelegate>)delegate;
- (void)zoomedImageWithUrl:(NSURL *)url;


@end
