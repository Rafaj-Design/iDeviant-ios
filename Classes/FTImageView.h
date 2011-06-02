//
//  FTImageView.h
//  FTLibrary
//
//  Created by Tim Storey on 27/04/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTImageView;

@protocol FTImageViewDelegate <NSObject>

- (void)imageView:(FTImageView *)imgView didFinishLoadingImage:(UIImage *)image;

@end


@interface FTImageView : UIImageView {
    
    UIImageView *overlayImage;
	
	UIView *flashOverlay;
	
	id <FTImageViewDelegate> delegate;
    
}

@property (nonatomic, retain) UIImageView *overlayImage;

@property (nonatomic, assign) id <FTImageViewDelegate> delegate;


- (id)initWithFrameWithRandomColor:(CGRect)frame;
- (void)setRandomColorBackground;

- (void)doFlashWithColor:(UIColor *)color;

- (void)loadImageFromUrl:(NSString *)url;


@end
