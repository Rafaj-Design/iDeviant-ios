//
//  FTDetailBasicViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"


@class FTMediaRSSParserFeedItem;

@interface FTDetailBasicViewController : FTViewController

@property (nonatomic, strong) FTMediaRSSParserFeedItem *item;

- (void)setPreloaderValue:(CGFloat)value;
- (void)showPreloader;
- (void)hidePreloader;


@end
