//
//  KTThumbsView.h
//  Sample
//
//  Created by Kirby Turner on 3/23/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDViewController;
@class KTThumbView;

@interface KTThumbsView : UIScrollView <UIScrollViewDelegate>
{
@private
   IDViewController *controller_;
   BOOL thumbsHaveBorder_;
   NSInteger thumbsPerRow_;
   CGSize thumbSize_;
   
   NSMutableSet *reusableThumbViews_;
   
   // We use the following ivars to keep track of 
   // which thumbnail view indexes are visible.
   int firstVisibleIndex_;
   int lastVisibleIndex_;
   int lastItemsPerRow_;
}

@property (nonatomic, assign) IDViewController *controller;
@property (nonatomic, assign) BOOL thumbsHaveBorder;
@property (nonatomic, assign) NSInteger thumbsPerRow;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) NSMutableArray *photos, *itms;

- (KTThumbView *)dequeueReusableThumbView;
- (void)reloadData;

@end
