//
//  FTDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 27/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"


@class FTDetailViewController;

@protocol FTDetailViewControllerDelegate <NSObject>

- (void)detailViewController:(FTDetailViewController *)controller didScrollToItem:(FTMediaRSSParserFeedItem *)item atIndex:(NSInteger)index;

@end


@interface FTDetailViewController : FTViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, weak) id <FTDetailViewControllerDelegate> delegate;


@end
