//
//  FTDynamicContentView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 26/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTDynamicContentView.h"


@implementation FTDynamicContentView

@synthesize elements;
@synthesize enableAutoLayout;


#pragma mark Initialization

- (void)doInit {
	elements = [[NSMutableArray alloc] init];
	enableAutoLayout = YES;
}

- (id)init {
    self = [super init];
    if (self) {
		[self doInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self doInit];
    }
    return self;
}

#pragma mark Adding general elements

- (void)addElement:(UIView *)element andAutoResizeForView:(BOOL)autoresize {
	if (enableAutoLayout) {
		[self layout];
	}
}

- (void)addElement:(UIView *)element {
	
}

- (void)addSubview:(UIView *)view {
	[self addElement:view];
}

- (void)addImageView:(UIImageView *)imageView {
	
}

- (void)addImage:(UIImage *)image withContentMode:(UIViewContentMode)contentMode {
	
}

- (void)addImage:(UIImage *)image {
	
}

- (void)addLabel:(UILabel *)label {
	
}

- (void)addText:(NSString *)text withFont:(UIFont *)font {
	
}

#pragma mark Layout

- (void)layout {
	
}

- (void)setTopMargin:(CGFloat)tm withLeftMargin:(CGFloat)lm withRightMargin:(CGFloat)rm andBottomMargin:(CGFloat)bm {
	
}

- (void)setGeneralMargin:(CGFloat)margin {
	
}

#pragma mark Memory management

- (void)dealloc {
	[elements release];
    [super dealloc];
}


@end
