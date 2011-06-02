//
//  FTMacros.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iDeviantAppDelegate.h"

#define ShowNetworkActivity [(iDeviantAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkActivity:TRUE sender:self];
#define HideNetworkActivity [(iDeviantAppDelegate *)[[UIApplication sharedApplication] delegate] showNetworkActivity:FALSE sender:self];

#define DegreesToRadian(x) (M_PI * (x) / 180.0)