//
//  IDAppDelegate.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 12/01/2013.
//  Copyright (c) 2013 Ondrej Rafaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDViewController;

@interface IDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IDViewController *viewController;

@end
