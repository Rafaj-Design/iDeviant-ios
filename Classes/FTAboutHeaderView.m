//
//  FTAboutHeaderView.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 21/06/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAboutHeaderView.h"


@implementation FTAboutHeaderView


#pragma mark Initialization

- (void)doSetup {
	[self setContentMode:UIViewContentModeScaleAspectFit];
	[self setBackgroundColor:[UIColor redColor]];
	[self setFrame:CGRectMake(0, 0, 320, 100)];
}

- (id)init {
	self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
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



#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end
