//
//  IDFavouriteCategories.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 29/05/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "IDFavouriteCategories.h"


#define kIDFavouriteCategoriesListKey						@"IDFavouriteCategoriesList"


@implementation IDFavouriteCategories

+ (NSString *)keyForCat:(NSString *)stringPath {
	return [NSString stringWithFormat:@"IDFavouriteCategories-%@", stringPath];
}

+ (NSMutableDictionary *)dictionaryDataForFavorites {
	NSDictionary *d = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kIDFavouriteCategoriesListKey];
	if (!d) {
		d = [[[NSDictionary alloc] init] autorelease];
	}
	NSMutableDictionary *data = [[[NSMutableDictionary alloc] initWithDictionary:d] autorelease];
	return data;
}

+ (NSArray *)dataForFavorites {
	NSDictionary *d = [self dictionaryDataForFavorites];
	return ([[d allKeys] count] > 0) ? [d allValues] : [NSArray array];
}

+ (BOOL)isFavouriteCategory:(NSString *)stringPath {
	return [[NSUserDefaults standardUserDefaults] boolForKey:[self keyForCat:stringPath]];
}

+ (void)toggleIsFavouriteCategory:(NSString *)stringPath withCategoryData:(NSDictionary *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *key = [self keyForCat:stringPath];
	NSMutableDictionary *d = [self dictionaryDataForFavorites];
	BOOL is = [self isFavouriteCategory:stringPath];
	if (!is) {
		NSMutableDictionary *insert = [[NSMutableDictionary alloc] initWithDictionary:data];
		[insert setValue:stringPath forKey:@"fullPath"];
		[insert setValue:[NSArray array] forKey:@"subcategories"];
		[d setValue:insert forKey:key];
		[insert release];
	}
	else [d removeObjectForKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:d forKey:kIDFavouriteCategoriesListKey];
	[[NSUserDefaults standardUserDefaults] setBool:!is forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[pool drain];
}

+ (void)cacheAllFavoriteCategories {
	
}


@end
