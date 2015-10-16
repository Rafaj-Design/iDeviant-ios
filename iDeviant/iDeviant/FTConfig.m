//
//  FTConfig.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 17/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTConfig.h"


#define dFTConfigFeedTypeKey                                @"FTConfigFeedTypeKey"
#define dFTConfigFavoritesFeedTypeKey                       @"FTConfigFavoritesFeedTypeKey"


@implementation FTConfig

@synthesize feedType = _feedType;


#pragma mark Feed type

- (void)setFeedType:(FTConfigFeedType)feedType {
    _feedType = feedType;
    [[NSUserDefaults standardUserDefaults] setInteger:_feedType forKey:dFTConfigFeedTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFavoritesFeedType:(FTConfigFeedType)favoritesFeedType {
    _favoritesFeedType = favoritesFeedType;
    [[NSUserDefaults standardUserDefaults] setInteger:_feedType forKey:dFTConfigFavoritesFeedTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)sortStringForFeedType:(FTConfigFeedType)feedType {
    switch (feedType) {
        case FTConfigFeedTypePopular:
            return @"&boost:popular";
            break;
            
        case FTConfigFeedTypeTimeSorted:
            return @"&sort:time";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark Initialization

+ (FTConfig *)sharedConfig {
    static FTConfig *object = nil;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        object = [[FTConfig alloc] init];
    });
    return object;
}

- (id)init {
    self = [super init];
    if (self) {
        _feedType = [[NSUserDefaults standardUserDefaults] integerForKey:dFTConfigFeedTypeKey];
        _favoritesFeedType = [[NSUserDefaults standardUserDefaults] integerForKey:dFTConfigFavoritesFeedTypeKey];
    }
    return self;
}


@end
