 //
//  FTDynamicContentView.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 26/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTDynamicContentView : UIView {
    
	NSMutableArray *elements;
	
	BOOL enableAutoLayout;
	
	CGFloat topMargin;
	CGFloat leftMargin;
	CGFloat rightMargin;
	CGFloat bottomMargin;
	
}

@property (nonatomic, readonly) NSMutableArray *elements;

@property (nonatomic) BOOL enableAutoLayout;


// Adding elements
- (void)addElement:(UIView *)element andAutoResizeForView:(BOOL)autoresize;
- (void)addElement:(UIView *)element;

- (void)addImageView:(UIImageView *)imageView;
- (void)addImage:(UIImage *)image withContentMode:(UIViewContentMode)contentMode;
- (void)addImage:(UIImage *)image;

- (void)addLabel:(UILabel *)label;
- (void)addText:(NSString *)text withFont:(UIFont *)font;

// Layout
- (void)layout;
- (void)setTopMargin:(CGFloat)tm withLeftMargin:(CGFloat)lm withRightMargin:(CGFloat)rm andBottomMargin:(CGFloat)bm;
- (void)setGeneralMargin:(CGFloat)margin;



@end
