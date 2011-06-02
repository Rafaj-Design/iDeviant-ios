//
//  iDeviantAppDelegate.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNavigationViewController.h"
#import "FBConnect.h"


@interface iDeviantAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    
    UIWindow *window;
    FTNavigationViewController *navigationController;
	
	Facebook *facebook;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) Facebook *facebook;


- (void)showNetworkActivity:(BOOL)visible sender:(id)sender;


@end

