//
//  FTImageView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTImageView.h"
#import "UIImageView+AFNetworking.h"


@implementation FTImageView


#pragma mark Initialization

- (void)setupView {
    [self setContentMode:UIViewContentModeScaleAspectFit];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithDefaultImage:(UIImage *)image andUrlString:(NSString *)urlString {
    self = [super initWithImage:image];
    if (self) {
        [self setupView];
        [self setUrlString:urlString];
    }
    return self;
}

#pragma mark Settings

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    [self setImageWithURL:[NSURL URLWithString:_urlString]];
}


@end
