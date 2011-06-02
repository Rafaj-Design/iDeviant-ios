//
//  FTLang.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 14/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTLang.h"
#import "Configuration.h"


@implementation FTLang

static NSMutableDictionary *debugDictionary;

+ (NSString *)get:(NSString *)key c:(NSString *)comment {
	if (kDebug) {
		if (!debugDictionary) debugDictionary = [[NSMutableDictionary alloc] init];
		[debugDictionary setValue:key forKey:key];
	}
	return NSLocalizedString(key, comment);
}

+ (NSString *)get:(NSString *)key {
	return [self get:key c:key];
}

+ (void)printLanguageDebug {
	if (kDebug) {
		if (debugDictionary) {
			NSString *output = @"Output: \n";
			for (NSString *key in [debugDictionary allKeys]) {
				NSString *test = NSLocalizedString(key, key);
				NSString *translation = (![test isEqualToString:key]) ? test : @""; 
				output = [output stringByAppendingFormat:@"\"%@\" = \"%@\";\n", key, translation];
			}
			NSLog(@"%@", output);
		}
	}
}


@end
