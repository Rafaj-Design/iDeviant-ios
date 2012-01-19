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
    
	FTPageScrollView *mainView;
	
	NSString *imageUrl;
	
	FTToolbar *bottomBar;
    
    UIBarButtonItem *actionButton;
	
	//UIActivityIndicatorView *ai;
	
	int currentIndex;
	
	id <IDImageDetailViewControllerDelegate> delegate;
	
	NSArray *listThroughData;
	
	IDHorizontalItems *shortcutView;
    
    UIImage *currentImage;
	
	FTImagePage *page;
	
	UITapGestureRecognizer *tap;
	
	BOOL isOverlayShowing;
}

@property (nonatomic, retain) FTPageScrollView *mainView;

@property (nonatomic, retain) NSString *imageUrl;

@property (nonatomic, retain) UIImage *currentImage;

@property (nonatomic) int currentIndex;

@property (nonatomic, assign) id <IDImageDetailViewControllerDelegate> delegate;

@property (nonatomic, retain) FTImagePage *page;

@property (nonatomic, retain) UITapGestureRecognizer *tap;

@property (nonatomic) BOOL isOverlayShowing;


- (void)setListData:(NSArray *)array;


@end
