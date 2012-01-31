//
//  iDeviantAppDelegate.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "FBConnect.h"
#include "FTDownload.h"

@class MWFeedItem;
@class FTNavigationViewController;

@interface iDeviantAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate, FBDialogDelegate, FTDownloadDelegate> {
    UIWindow *window;
    FTNavigationViewController *navigationController;
	
	Facebook *facebook;
	NSMutableDictionary *fbParams;
	
	FTDownload *timestamp, *categories;
	NSInteger version;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) FTNavigationViewController *navigationController;

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSMutableDictionary *fbParams;

@property (nonatomic, strong) FTDownload *timestamp, *categories;
@property (nonatomic) NSInteger version;

- (void)showNetworkActivity:(BOOL)visible sender:(id)sender;
- (void)postFbMessageWithObject:(MWFeedItem *)item;
@end

