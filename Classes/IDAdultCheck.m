//
//  IDAdultCheck.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 17/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDAdultCheck.h"


@implementation IDAdultCheck


+ (void)checkForUnlock:(NSString *)unlockString {
	if ([unlockString isEqualToString:@"ineedthisplease"]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ineedthisplease"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else if ([unlockString isEqualToString:@"ihadenough"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ineedthisplease"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (BOOL)canAccessAdultStuff {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"ineedthisplease"];
}


@end
