//
//  FTDetailImageViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailImageViewController.h"
#import "FTImageCache.h"
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

- (void)setItem:(MWFeedItem *)item {
    [super setItem:item];
    
    NSString *url = [[item.thumbnails lastObject] objectForKey:@"url"];
    if ([FTDownload isFileForUrlString:url andCacheLifetime:FTDownloadCacheLifetimeForever]) {
        NSString *path = [FTDownload fileForUrlString:url andCacheLifetime:FTDownloadCacheLifetimeForever];
        NSData *d = [NSData dataWithContentsOfFile:path];
        [_imageView setImage:[UIImage imageWithData:d]];
    }
    
    NSDictionary *content = [self.item.contents lastObject];
    url = [content objectForKey:@"url"];
    
    [[FTImageCache sharedCache] imageForURL:[NSURL URLWithString:url] success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageView setImage:image];
            [self.view setNeedsLayout];
            [super hidePreloader];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super hidePreloader];
        });
    } progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Progress: %f", progress);
            [super setPreloaderValue:progress];
        });
    }];
}


@end
