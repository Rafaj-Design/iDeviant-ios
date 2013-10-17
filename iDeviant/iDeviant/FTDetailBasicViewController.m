//
//  FTDetailBasicViewController.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDetailBasicViewController.h"
#import "MBProgressHUD.h"


@interface FTDetailBasicViewController ()

@property (nonatomic, strong) MBRoundProgressView *progressView;

@end


@implementation FTDetailBasicViewController


#pragma mark Creating elements

- (void)createProgressView {
    _progressView = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [_progressView setProgress:0.3f];
    [self.view addSubview:_progressView];
    [_progressView setHidden:YES];
    [_progressView centerInSuperview];
    [_progressView setAutoresizingCenter];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createProgressView];
}

#pragma mark Settings

- (void)setPreloaderValue:(CGFloat)value {
    [_progressView setProgress:value];
    if (_progressView.isHidden) {
        [self showPreloader];
    }
    if (value >= 1) {
        [self hidePreloader];
    }
}

- (void)showPreloader {
    [_progressView setHidden:NO];
    [_progressView setAlpha:1];
    [self.view bringSubviewToFront:_progressView];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_progressView setAlpha:1];
    } completion:^(BOOL finished) {
        NSLog(@"Preloader frame: %@", NSStringFromCGRect(_progressView.frame));
    }];
}

- (void)hidePreloader {
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_progressView setAlpha:0];
    } completion:^(BOOL finished) {
        [_progressView setHidden:YES];
    }];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}


@end
