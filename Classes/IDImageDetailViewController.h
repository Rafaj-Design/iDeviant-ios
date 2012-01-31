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
#import "FTShare.h"
#import "FTImagePage.h"

@class IDImageDetailViewController;

@protocol IDImageDetailViewControllerDelegate <NSObject>

- (void)imageDetailViewController:(IDImageDetailViewController *)controller didFinishWithItem:(NSDictionary *)item atIndex:(int)index;

@end

@interface IDImageDetailViewController : IDViewController <UIActionSheetDelegate, FTImageViewDelegate, FTImageZoomViewDelegate, FTPageScrollViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
	
	id <IDImageDetailViewControllerDelegate> delegate;
	
	FTPageScrollView *mainView;
	FTToolbar *bottomBar;
	
	NSMutableArray *imagePages;
	
	NSString *imageUrl;
	
    UIBarButtonItem *actionButton;
	NSInteger currentIndex;
	
	NSArray *listThroughData;
	IDHorizontalItems *shortcutView;
    UIImage *currentImage;

	BOOL isOverlayShowing;
	
	UITapGestureRecognizer *tap, *doubletap;
}

@property (nonatomic, assign) id <IDImageDetailViewControllerDelegate> delegate;

@property (nonatomic, retain) FTPageScrollView *mainView;
@property (nonatomic, retain) FTToolbar *bottomBar;

@property (nonatomic, retain) NSMutableArray *imagePages;

@property (nonatomic, retain) NSString *imageUrl;

@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, retain) NSArray *listThroughData;
@property (nonatomic, retain) IDHorizontalItems *shortcutView;
@property (nonatomic, retain) UIImage *currentImage;

@property (nonatomic) BOOL isOverlayShowing;

@property (nonatomic, retain) UITapGestureRecognizer *tap, *doubletap;

- (void)setListData:(NSArray *)array;
- (void)maintainPages;

- (void)updateTitle;
- (FTImagePage *)pageForIndex:(int)index;

- (CGRect)frameForToolbar;
- (CGRect)frameForPage;

- (void)toggleNavigationVisibility;


@end
