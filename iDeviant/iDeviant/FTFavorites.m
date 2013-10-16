//
//  FTFavorites.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 16/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTFavorites.h"


@interface FTFavorites ()

@property (nonatomic, readonly) NSMutableArray *favoritesCache;

@end


@implementation FTFavorites


#pragma mark Filesystem

- (NSString *)pathToFavoritesFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSArray array] writeToFile:path atomically:YES];
    }
    return path;
}

#pragma mark Managing Favorites

- (void)save {
    [_favoritesCache writeToFile:[self pathToFavoritesFile] atomically:YES];
}

- (NSArray *)favorites {
    return _favoritesCache;
}

- (BOOL)isCategoryInFavorites:(NSDictionary *)category {
    for (NSDictionary *cat in _favoritesCache) {
        if ([[category objectForKey:@"path"] isEqualToString:[cat objectForKey:@"path"]]) {
            return YES;
        }
    }
    return NO;
}

- (void)addCategoryToFavorites:(NSDictionary *)category {
    if ([self isCategoryInFavorites:category]) return;
    [_favoritesCache addObject:category];
    [self save];
}

- (void)removeCategoryFromFavorites:(NSDictionary *)category {
    if (![self isCategoryInFavorites:category]) return;
    [_favoritesCache removeObject:category];
    [self save];
    if ([_delegate respondsToSelector:@selector(favorites:didRemoveCategory:)]) {
        [_delegate favorites:self didRemoveCategory:category];
    }
}

+ (NSArray *)favorites {
    return [[FTFavorites sharedFavorites] favorites];
}

+ (BOOL)isCategoryInFavorites:(NSDictionary *)category {
    return [[FTFavorites sharedFavorites] isCategoryInFavorites:category];
}

+ (void)addCategoryToFavorites:(NSDictionary *)category {
    [[FTFavorites sharedFavorites] addCategoryToFavorites:category];
}

+ (void)removeCategoryFromFavorites:(NSDictionary *)category {
    [[FTFavorites sharedFavorites] removeCategoryFromFavorites:category];
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
        _favoritesCache = [NSMutableArray arrayWithContentsOfFile:[self pathToFavoritesFile]];
    }
    return self;
}


@end
