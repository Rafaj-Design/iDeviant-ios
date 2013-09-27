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
    if (value == 100) {
        [self hidePreloader];
    }
}

- (void)showPreloader {
    [_progressView setHidden:NO];
    [_progressView setAlpha:0];
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_progressView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePreloader {
    [UIView animateWithDuration:0.0 delay:0.3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_progressView setAlpha:0];
    } completion:^(BOOL finished) {
        [_progressView setHidden:NO];
    }];
}


@end
