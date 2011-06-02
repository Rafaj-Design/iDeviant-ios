//
//  BuildChecks.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "IGABuildChecks.h"
#import "IGAMemTools.h"


#define kIGABuildChecksMemoryThreshold 60


@interface IGABuildChecks (private)

+ (void)checkZombies:(NSMutableArray *)errors;
+ (void)checkMemory:(NSMutableArray *)errors;

@end

@implementation IGABuildChecks

+ (BOOL)perform {
	NSMutableArray *errors = [[NSMutableArray alloc] initWithCapacity:0];
	
	[self checkZombies:errors];
	//[self checkMemory:errors];
	
	BOOL inError = [errors count] > 0;
	
	if (inError) {
		NSString *errorDescription = @"The following issues were detected: \n\n";
		
		for(NSString *error in errors) {
			errorDescription = [errorDescription stringByAppendingFormat:@"%@\n", error];
		}
				
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Build Issues" message:errorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[errors release];
	
	return !inError;
}

#pragma mark Check Methods

+ (void)checkZombies:(NSMutableArray *)errors {
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		[errors addObject:@"System log: NSZombies are enabled"];
	}
}

+ (void)checkMemory:(NSMutableArray *)errors {
	NSInteger avaiableMemory = [IGAMemTools getAvailableMemory]  / 1000000;
	if (avaiableMemory < kIGABuildChecksMemoryThreshold) {
		NSString *errorDescription = [[NSString alloc] initWithFormat:@"Memory log: Low memory - %d MB. Restart device", avaiableMemory];
		[errors addObject:errorDescription];
		[errorDescription release];
	}
}

@end
