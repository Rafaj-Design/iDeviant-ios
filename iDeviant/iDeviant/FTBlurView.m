//
//  FTBlurView.m
//
//  Created by Ondrej Rafaj on 17/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBlurView.h"


@interface FTBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end


@implementation FTBlurView


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [_toolbar setFrame:[self bounds]];
}

#pragma mark Initialization

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (![self toolbar]) {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        [self.layer insertSublayer:[_toolbar layer] atIndex:0];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Settings

- (void) setBlurTintColor:(UIColor *)blurTintColor {
    [_toolbar setBarTintColor:blurTintColor];
}


@end
