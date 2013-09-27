//
//  FTDetailImageViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailImageViewController.h"


@interface FTDetailImageViewController ()

@property (nonatomic, strong) FTImageView *imageView;

@end


@implementation FTDetailImageViewController


#pragma mark Creating elements

- (void)createImageView {
    CGRect r = self.view.bounds;
    
    _imageView = [[FTImageView alloc] initWithFrame:r];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_imageView];
    [_imageView setAutoresizingWidthAndHeight];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createImageView];
}


@end
