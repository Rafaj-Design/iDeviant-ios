//
//  IGASystem.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import "IGASystem.h"
#import "Configuration.h"


@implementation IGASystem


+ (void)log:(NSString *)message withFunction:(char *)function andLine:(int)line {
	NSLog(@"System debug: \"%@\" in %s on line %d", message, function, line);
}

+ (void)log:(NSString *)message withFunction:(char *)function {
	NSLog(@"System debug: \"%@\" in %s", message, function);
}

+ (void)log:(NSString *)message {
	NSLog(@"System debug: %@", message);
}


@end
