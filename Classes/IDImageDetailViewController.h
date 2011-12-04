//
//  IDImageDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDViewController.h"
#import "FTPageScrollView.h"
#import "FTImageZoomView.h"
#import "FTToolbar.h"
#import "IDHorizontalItems.h"


@class IDImageDetailViewController;

@protocol IDImageDetailViewControllerDelegate <NSObject>

- (void)imageDetailViewController:(IDImageDetailViewController *)controller didFinishWithItem:(NSDictionary *)item atIndex:(int)index;

@end


@interface IDImageDetailViewController : IDViewController <UIActionSheetDelegate, FTImageViewDelegate, FTImageZoomViewDelegate, FTPageScrollViewDelegate> {
    
	FTPageScrollView *mainView;
	
	NSString *imageUrl;
	
	FTToolbar *bottomBar;
    
    UIBarButtonItem *actionButton;
	
	//UIActivityIndicatorView *ai;
	
	int currentIndex;
	
	id <IDImageDetailViewControllerDelegate> delegate;
	
	NSArray *listThroughData;
	
	IDHorizontalItems *shortcutView;
	
}

@property (nonatomic, retain) FTPageScrollView *mainView;

@property (nonatomic, retain) NSString *imageUrl;

@property (nonatomic) int currentIndex;

@property (nonatomic, assign) id <IDImageDetailViewControllerDelegate> delegate;


- (void)setListData:(NSArray *)array;


@end
