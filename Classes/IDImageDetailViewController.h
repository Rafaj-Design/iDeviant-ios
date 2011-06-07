//
//  IDImageDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"
#import "FTPageScrollView.h"
#import "FTImageZoomView.h"
#import "FTToolbar.h"


@interface IDImageDetailViewController : FTViewController <UIActionSheetDelegate, FTImageZoomViewDelegate, FTPageScrollViewDelegate> {
    
	FTPageScrollView *mainView;
	
	NSString *imageUrl;
	
	FTToolbar *bottomBar;
	
	UIActivityIndicatorView *ai;
	
	int currentIndex;
	
}

@property (nonatomic, retain) FTPageScrollView *mainView;

@property (nonatomic, retain) NSString *imageUrl;

@property (nonatomic) int currentIndex;


@end
