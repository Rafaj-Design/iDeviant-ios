//
//  FTDetailImageViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailImageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FTDownload.h"


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

#pragma mark Settings

- (void)setItem:(FTMediaRSSParserFeedItem *)item {
    [super setItem:item];
    
    [_imageView setImageWithURL:[NSURL URLWithString:self.item.content.urlString]];
}


@end
