//
//  IDImageZoomView.h
//  iDeviant
//
//  Created by Adam Horacek on 01.02.12.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTZoomView.h"
#import "IDImageView.h"


@class IDImageZoomView;

@protocol IDImageZoomViewDelegate <NSObject>

- (void)imageZoomViewDidFinishLoadingImage:(IDImageZoomView *)zoomView;

@end


@interface IDImageZoomView : FTZoomView <IDImageViewDelegate> {
	
	IDImageView *imageView;
	
	id <IDImageZoomViewDelegate> zoomDelegate;
	
	CGFloat margin;
	
	CGFloat maxA;
	CGFloat maxB;
	
}

@property (nonatomic, retain) IDImageView *imageView;

@property (nonatomic, assign) id <IDImageZoomViewDelegate> zoomDelegate;


- (id)initWithView:(UIView *)view andOrigin:(CGPoint)origin;

- (id)initWithImage:(UIImage *)image andFrame:(CGRect)frame;

- (void)setImage:(UIImage *)image;

- (void)loadImageFromUrl:(NSString *)url;

- (void)setSideMargin:(CGFloat)sideMargin;


@end