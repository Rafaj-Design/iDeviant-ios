//
//  iDeviantAppDelegate.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNavigationViewController.h"

#include "FBConnect.h"

@class MWFeedItem;

@interface iDeviantAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate, FBDialogDelegate> {
    UIWindow *window;
    FTNavigationViewController *navigationController;
	
	Facebook *facebook;
	NSMutableDictionary *fbParams;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSMutableDictionary *fbParams;

- (void)showNetworkActivity:(BOOL)visible sender:(id)sender;
- (void)postFbMessageWithObject:(MWFeedItem *)item;
@end

