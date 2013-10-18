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

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIImageView *imageView;

@end


@implementation FTDetailImageViewController


#pragma mark Creating elements

- (void)createImageView {
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    [_imageView setAutoresizingWidthAndHeight];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_scrollView addSubview:_imageView];
}

- (void)createMainScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setAutoresizingWidthAndHeight];
    [_scrollView setClipsToBounds:YES];
    [_scrollView setMaximumZoomScale:4];
    [_scrollView setDelegate:self];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [_scrollView addGestureRecognizer:doubleTap];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createMainScrollView];
    [self createImageView];
}

#pragma mark Settings

- (void)setImage:(UIImage *)image {
    [_imageView setImage:image];
}

- (void)setItem:(FTMediaRSSParserFeedItem *)item {
    [super setItem:item];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.content.urlString]];
    
    __weak typeof(self) weakSelf = self;
    [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:nil progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progress;
        if (totalBytesExpectedToRead > 0 && totalBytesRead <= totalBytesExpectedToRead) {
            progress = (CGFloat) totalBytesRead / totalBytesExpectedToRead;
        }
        else {
            progress = (totalBytesRead % 1000000l) / 1000000.0f;
        }
        [super setPreloaderValue:progress];
    } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Fail");
    }];
}

#pragma merk Gesture recognizer delegate methods

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (_scrollView.zoomScale == _scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:_scrollView];
        CGSize size = CGSizeMake(_scrollView.bounds.size.width / _scrollView.maximumZoomScale,
                                 _scrollView.bounds.size.height / _scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [_scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [_scrollView zoomToRect:_scrollView.bounds animated:YES];
    }
}

#pragma mark Scroll view delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}


@end
