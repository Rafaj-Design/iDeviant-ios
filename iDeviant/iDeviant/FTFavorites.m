//
//  FTFavorites.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTFavorites.h"


@interface FTFavorites ()

@property (nonatomic, readonly) NSMutableArray *popularFavoritesCache;
@property (nonatomic, readonly) NSMutableArray *newestFavoritesCache;

@end


@implementation FTFavorites


#pragma mark Filesystem

- (NSString *)pathToFavoritesFile:(FTConfigFeedType)feedType {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"favorites-%ld.plist", feedType]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSArray array] writeToFile:path atomically:YES];
    }
    return path;
}

#pragma mark Managing Favorites

- (void)save {
    [_popularFavoritesCache writeToFile:[self pathToFavoritesFile:FTConfigFeedTypePopular] atomically:YES];
    [_newestFavoritesCache writeToFile:[self pathToFavoritesFile:FTConfigFeedTypeTimeSorted] atomically:YES];
}

- (NSArray *)favoritesForFeedType:(FTConfigFeedType)feedType {
    return (feedType == FTConfigFeedTypePopular) ? _popularFavoritesCache : _newestFavoritesCache;
}

- (BOOL)isCategoryInFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    for (NSDictionary *cat in [self favoritesForFeedType:feedType]) {
        if ([[category objectForKey:@"path"] isEqualToString:[cat objectForKey:@"path"]]) {
            return YES;
        }
    }
    return NO;
}

- (void)addCategoryToFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    if ([self isCategoryInFavorites:category forFeedType:feedType]) return;
    [(NSMutableArray *)[self favoritesForFeedType:feedType] addObject:category];
    [self save];
}

- (void)removeCategoryFromFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    if (![self isCategoryInFavorites:category forFeedType:feedType]) return;
    [(NSMutableArray *)[self favoritesForFeedType:feedType] removeObject:category];
    [self save];
    if ([_delegate respondsToSelector:@selector(favorites:didRemoveCategory:withFeedType:)]) {
        [_delegate favorites:self didRemoveCategory:category withFeedType:feedType];
    }
}

+ (NSArray *)favoritesForFeedType:(FTConfigFeedType)feedType {
    return [[FTFavorites sharedFavorites] favoritesForFeedType:feedType];
}

+ (BOOL)isCategoryInFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    return [[FTFavorites sharedFavorites] isCategoryInFavorites:category forFeedType:feedType];
}

+ (void)addCategoryToFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    [[FTFavorites sharedFavorites] addCategoryToFavorites:category forFeedType:feedType];
}

+ (void)removeCategoryFromFavorites:(NSDictionary *)category forFeedType:(FTConfigFeedType)feedType {
    [[FTFavorites sharedFavorites] removeCategoryFromFavorites:category forFeedType:feedType];
}

#pragma mark Initialization

+ (FTFavorites *)sharedFavorites {
    static FTFavorites *object = nil;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        object = [[FTFavorites alloc] init];
    });
    return object;
}

- (id)init {
    self = [super init];
    if (self) {
        _popularFavoritesCache = [NSMutableArray arrayWithContentsOfFile:[self pathToFavoritesFile:FTConfigFeedTypePopular]];
        _newestFavoritesCache = [NSMutableArray arrayWithContentsOfFile:[self pathToFavoritesFile:FTConfigFeedTypeTimeSorted]];
    }
    return self;
}


@end
