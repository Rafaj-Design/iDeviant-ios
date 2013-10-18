//
//  FTConfig.h
//  iDeviant
//
//  Created by Ondrej Rafaj on 17/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CONFIG_API_URL                                  @"http://backend.deviantart.com/rss.xml?q="


typedef NS_ENUM(NSInteger, FTConfigFeedType) {
    FTConfigFeedTypePopular,
    FTConfigFeedTypeTimeSorted,
    FTConfigFeedTypeNone
};


@interface FTConfig : NSObject

@property (nonatomic) FTConfigFeedType feedType;
@property (nonatomic) FTConfigFeedType favoritesFeedType;

+ (FTConfig *)sharedConfig;

+ (NSString *)sortStringForFeedType:(FTConfigFeedType)feedType;


@end
