//
//  IDImageDetailViewController.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 15/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTViewController.h"
#import "FTPagesScrollView.h"
#import "FTImageZoomView.h"
#import "FTToolbar.h"


@interface IDImageDetailViewController : FTViewController <UIActionSheetDelegate, FTImageZoomViewDelegate> {
    
	FTImageZoomView *mainView;
	
	NSString *imageUrl;
	
	FTToolbar *bottomBar;
	
	UIActivityIndicatorView *ai;
	
	UILabel *message;
	
}

@property (nonatomic, retain) FTImageZoomView *mainView;

@property (nonatomic, retain) NSString *imageUrl;


@end
