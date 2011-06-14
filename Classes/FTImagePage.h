//
//  FTImagePage.h
//  LazyLoadingTest
//
//  Created by Ondrej Rafaj on 04/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPage.h"
#import "FTImageZoomView.h"
#import "FTImageView.h"


@interface FTImagePage : FTPage {
	
	FTImageView *imageView;
	
	FTImageZoomView *imageZoomView;
	
}

@property (nonatomic, retain) FTImageView *imageView;

@property (nonatomic, retain) FTImageZoomView *imageZoomView;


- (void)imageWithContentsOfFile:(NSString *)path;

- (void)imageNamed:(NSString *)imageName withDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate;

- (void)imageNamed:(NSString *)imageName;

- (void)imageWithUrl:(NSURL *)url;

- (void)zoomedImageWithContentsOfFile:(NSString *)path;

- (void)zoomedImageNamed:(NSString *)imageName withDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate;

- (void)zoomedImageNamed:(NSString *)imageName;

- (void)zoomedImageWithUrl:(NSURL *)url andDelegate:(id <FTImageViewDelegate, FTImageZoomViewDelegate>)delegate;


@end
