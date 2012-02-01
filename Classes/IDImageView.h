//
//  IDImageView.h
//  iDeviant
//
//  Created by Adam Horacek on 01.02.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"


@class IDImageView;

@protocol IDImageViewDelegate <NSObject>

@optional

- (void)imageView:(IDImageView *)imgView didFinishLoadingImage:(UIImage *)image;

- (void)imageView:(IDImageView *)imgView didFinishLoadingImageFromInternet:(UIImage *)image;

- (void)imageViewDidFailLoadingImage:(IDImageView *)imgView withError:(NSError *)error;

- (void)imageViewDidStartLoadingImage:(IDImageView *)imgView;

@end


@interface IDImageView : UIImageView <ASIHTTPRequestDelegate> {
    
    UIImageView *overlayImage;
	
	UIView *flashOverlay;
	
	id <IDImageViewDelegate> delegate;
	
	UIActivityIndicatorView *activityIndicator;
	
	UIProgressView *progressLoadingView;
	
	ASIHTTPRequest *imageRequest;
	BOOL useAsiHTTPRequest;
	
	BOOL debugMode;
	UILabel *debugLabel;
	
	NSString *imageUrl;
	
}

@property (nonatomic, retain) UIImageView *overlayImage;

@property (nonatomic, assign) id <IDImageViewDelegate> delegate;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIProgressView *progressLoadingView;

@property (nonatomic, retain) ASIHTTPRequest *imageRequest;

@property (nonatomic) BOOL useAsiHTTPRequest;

@property (nonatomic, readonly) BOOL debugMode;

@property (nonatomic, readonly) NSString *imageUrl;

- (id)initWithFrameWithRandomColor:(CGRect)frame;
- (void)setRandomColorBackground;

- (void)doFlashWithColor:(UIColor *)color;

- (BOOL)isCacheFileForUrl:(NSString *)url;

- (void)loadImageFromUrl:(NSString *)url;

//- (void)enableProgressLoadingView:(BOOL)enable;

- (void)enableActivityIndicator:(BOOL)enable;

- (void)enableDebugMode:(BOOL)debugMode;

//animations

- (void)setImage:(UIImage *)image dissolveInTime:(CGFloat)time;

- (void)setImage:(UIImage *)image dissolveInTime:(CGFloat)time allowUserInteractionWillAnimating:(BOOL)userInteraction;

@end